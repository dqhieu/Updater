//
//  Updater.swift
//  Updater
//
//  Created by Dinh Quang Hieu on 21/09/2023.
//

import Foundation
import UIKit
import SwiftUI
import StoreKit

public enum UpdaterCheckType {
  case onDemand
  case onForeground
}

public final class Updater {
  
  public static let shared = Updater()
  
  public func start(type: UpdaterCheckType = .onForeground) {
    switch type {
    case .onDemand:
      Task {
        try await checkForUpdate()
      }
    case .onForeground:
      observeForegroundNotification()
    }
  }
  
  public func clearLastCheckedDate() {
    UserDefaults.lastCheckedDate = nil
  }
  
  private func observeForegroundNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(onForegroundNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  // only check once a day
  @objc private func onForegroundNotification() {
    let shouldCheckForUpdate: Bool = {
      guard let lastCheckedDate = UserDefaults.lastCheckedDate else { return true }
      if Calendar.current.isDate(lastCheckedDate, inSameDayAs: Date()) { return false }
      return true
    }()
    guard shouldCheckForUpdate else { return }
    UserDefaults.lastCheckedDate = Date()
    Task {
      try? await checkForUpdate()
    }
  }
      
  private func checkForUpdate() async throws {
    let bundleId = Bundle.main.bundleIdentifier!
    let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
    let (data, _) = try await URLSession.shared.data(for: request)
    let result = try JSONDecoder().decode(LookupResult.self, from: data)
    guard let appDetail = result.results.first else { return }
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    guard isNewer(lhs: appDetail.version, rhs: currentVersion) else { return }
    if let skippedVersion = UserDefaults.skippedVersion, skippedVersion == appDetail.version { return }
    DispatchQueue.main.async { [weak self] in
      self?.presentBottomSheetIfNeeded(appDetail: appDetail)
    }
  }
  
  private func presentBottomSheetIfNeeded(appDetail: AppDetail) {
    guard let windowScene = getFirstForegroundScene() else {
      return
    }
    
    let window = UIWindow(windowScene: windowScene)
    let viewController = UpdaterViewController(appDetail: appDetail)
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    viewController.window = window
    viewController.showUpdate()
  }
  
  private func isNewer(lhs: String, rhs: String) -> Bool {
    return rhs.compare(lhs, options: .numeric) == .orderedAscending
  }
  
  private func getFirstForegroundScene() -> UIWindowScene? {
    let connectedScenes = UIApplication.shared.connectedScenes
    if let windowActiveScene = connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
      return windowActiveScene
    } else if let windowInactiveScene = connectedScenes.first(where: { $0.activationState == .foregroundInactive }) as? UIWindowScene {
      return windowInactiveScene
    } else {
      return nil
    }
  }
  
}

