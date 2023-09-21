//
//  ContentView.swift
//  Updater
//
//  Created by Dinh Quang Hieu on 21/09/2023.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")
        Button(action: {
          Updater.shared.start(type: .onDemand)
        }, label: {
          Text("Check")
        })
        Spacer()
      }
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
