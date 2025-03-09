//
//  PatchMatchesCheckPiece.swift
//  UseCases
//
//  Created by eunseou on 2/24/25.
//

import Entities
import RepositoryInterfaces

public protocol PatchMatchesCheckPieceUseCase {
  func execute() async throws -> VoidModel
}

final class PatchMatchesCheckPieceUseCaseImpl: PatchMatchesCheckPieceUseCase {
  private let repository: MatchesRepositoryInterface
  
  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }
  
  func execute() async throws -> VoidModel {
    try await repository.patchCheckMatchPiece()
  }
}
