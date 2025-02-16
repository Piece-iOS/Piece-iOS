//
//  ExternalDependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 2/8/25.
//

import ProjectDescription

public enum ExternalDependencies {
  case Alamofire
  case KakaoSDKCommon
  case KakaoSDKAuth
  case KakaoSDKUser
  case GoogleSignIn
  case GoogleSignInSwift
  case Lottie
  
  public var name: String {
    switch self {
    case .Alamofire: "Alamofire"
    case .GoogleSignIn: "GoogleSignIn"
    case .GoogleSignInSwift: "GoogleSignInSwift"
    case .KakaoSDKCommon: "KakaoSDKCommon"
    case .KakaoSDKAuth: "KakaoSDKAuth"
    case .KakaoSDKUser: "KakaoSDKUser"
    case .Lottie: "Lottie"
    }
  }
}
