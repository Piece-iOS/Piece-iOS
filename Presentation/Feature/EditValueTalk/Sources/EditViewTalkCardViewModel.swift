//
//  EditViewTalkCardViewModel.swift
//  EditValueTalk
//
//  Created by summercat on 2/9/25.
//

import Combine
import Entities
import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
final class EditValueTalkCardViewModel: Equatable {
  static func == (lhs: EditValueTalkCardViewModel, rhs: EditValueTalkCardViewModel) -> Bool {
    lhs.model == rhs.model
  }
  
  enum Action {
    case didUpdateAnswer(String)
    case didUpdateSummary(String)
    case didTapSummaryButton
  }
  
  enum EditingState {
    case viewing
    case editingAnswer
    case editingSummary
    case generatingAISummary
  }
  
  var model: ProfileValueTalkModel
  let index: Int
  let isEditingAnswer: Bool
  var localSummary: String
  var currentGuideText: String {
    model.guides[guideTextIndex]
  }
  
  private(set) var editingState: EditingState = .viewing
  private(set) var guideTextIndex: Int = 0
  private var cancellables: [AnyCancellable] = []
  
  let onModelUpdate: (ProfileValueTalkModel) -> Void
  
  init(
    model: ProfileValueTalkModel,
    index: Int,
    isEditingAnswer: Bool,
    onModelUpdate: @escaping (ProfileValueTalkModel) -> Void
  ) {
    self.model = model
    self.index = index
    self.isEditingAnswer = isEditingAnswer
    self.onModelUpdate = onModelUpdate
    self.localSummary = model.summary
    startTimer()
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case let .didUpdateAnswer(answer):
      model.answer = answer
      onModelUpdate(model)
      
    case let .didUpdateSummary(summary):
      localSummary = summary
      
    case .didTapSummaryButton:
      didTapSummaryButton()
    }
  }
  
  func updateSummary(_ summary: String) {
    localSummary = summary
    model.summary = summary
    editingState = .viewing
  }
    

  private func increaseGuideTextIndex() {
    guideTextIndex = (guideTextIndex + 1) % model.guides.count
  }
  
  private func didTapSummaryButton() {
    switch editingState {
    case .viewing:
      editingState = .editingSummary
      
    case .editingAnswer:
      break
      
    case .editingSummary:
      model.summary = localSummary
      onModelUpdate(model)
      editingState = .viewing
      
    case .generatingAISummary:
      break
    }
  }
  
  private func startTimer() {
    Timer.publish(every: 3, on: .main, in: .common).autoconnect()
      .sink { [weak self] _ in
        self?.increaseGuideTextIndex()
      }
      .store(in: &cancellables)
  }
}
