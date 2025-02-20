//
//  MatchesEndpoint.swift
//  PCNetwork
//
//  Created by summercat on 2/11/25.
//

import Alamofire
import DTO
import Foundation
import LocalStorage

public enum MatchesEndpoint: TargetType {
  case profileBasic
  case valueTalks
  case valuePicks
  case accept
  case matchesInfos
  case refuse
  case block(matchId: Int)
  case contacts
  case image
  
  public var method: HTTPMethod {
    switch self {
    case .profileBasic: .get
    case .valueTalks: .get
    case .valuePicks: .get
    case .accept: .post
    case .matchesInfos: .get
    case .refuse: .put
    case .block: .post
    case .contacts: .get
    case .image: .get
    }
  }
  
  public var path: String {
    switch self {
    case .profileBasic: "api/matches/profiles/basic"
    case .valueTalks: "api/matches/values/talks"
    case .valuePicks: "api/matches/values/picks"
    case .accept: "api/matches/accept"
    case .matchesInfos: "api/matches/infos"
    case .refuse: "api/matches/refuse"
    case let .block(matchId): "api/matches/\(matchId)/blocks"
    case .contacts: "api/matches/contacts"
    case .image: "api/matches/images"
    }
  }
  
  public var headers: [String : String] {
    switch self {
    case .profileBasic:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    case .valueTalks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .valuePicks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .accept:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .matchesInfos:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    case .refuse:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .block:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
      
    case .contacts:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
      
    case .image:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case .profileBasic: .plain
    case .valueTalks: .plain
    case .valuePicks: .plain
    case .accept: .plain
    case .matchesInfos: .plain
    case .refuse: .plain
    case .block: .plain
    case .contacts: .plain
    case .image: .plain
    }
  }
}
