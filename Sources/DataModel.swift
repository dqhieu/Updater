//
//  DataModel.swift
//  Updater
//
//  Created by Dinh Quang Hieu on 21/09/2023.
//

import Foundation

struct LookupResult: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case results
  }
  
  let results: [AppDetail]
}

struct AppDetail: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case appID = "trackId"
    case version
  }
  
  let appID: Int
  let version: String
}
