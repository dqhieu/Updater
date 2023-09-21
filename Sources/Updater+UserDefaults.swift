//
//  Updater+UserDefaults.swift
//  Updater
//
//  Created by Dinh Quang Hieu on 21/09/2023.
//

import Foundation

extension UserDefaults {
  
  enum UpdaterKeys: String {
    case skippedVersion
    case lastCheckedDate
  }
  
  static var skippedVersion: String? {
    get {
      return standard.string(forKey: UpdaterKeys.skippedVersion.rawValue)
    } set {
      standard.set(newValue, forKey: UpdaterKeys.skippedVersion.rawValue)
    }
  }
  
  static var lastCheckedDate: Date? {
    get {
      return standard.object(forKey: UpdaterKeys.lastCheckedDate.rawValue) as? Date
    } set {
      standard.set(newValue, forKey: UpdaterKeys.lastCheckedDate.rawValue)
    }
  }
  
}
