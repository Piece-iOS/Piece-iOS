//
//  MatchMainViewFactory.swift
//  MatchingMain
//
//  Created by eunseou on 2/15/25.
//

import SwiftUI
import UseCases

public struct MatchMainViewFactory {
  @ViewBuilder
  public static func createMatchMainView(
    getUserInfoUseCase: GetUserInfoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  ) -> some View {
    MatchingMainView(
      getUserInfoUseCase: getUserInfoUseCase,
      acceptMatchUseCase: acceptMatchUseCase,
      getMatchesInfoUseCase: getMatchesInfoUseCase,
      getUserRejectUseCase: getUserRejectUseCase,
      patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase
    )
  }
}
