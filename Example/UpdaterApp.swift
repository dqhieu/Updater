//
//  UpdaterApp.swift
//  Updater
//
//  Created by Dinh Quang Hieu on 21/09/2023.
//

import SwiftUI

@main
struct UpdaterApp: App {
  
  init() {
    Updater.shared.start()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
