//
//  AvoidContactsGuideViewModel.swift
//  SignUp
//
//  Created by eunseou on 1/17/25.
//

import Observation
import UseCases
import UIKit
import Entities

@MainActor
@Observable
final class AvoidContactsGuideViewModel {
  enum Action {
    case tapAccepetButton
    case showShettingAlert
    case cancelAlert
  }
  
  private(set) var showToast = false
  private(set) var moveToCompleteSignUp: Bool = false
  var isPresentedAlert: Bool = false
  private let requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  private let fetchContactsUseCase: FetchContactsUseCase
  private let blockContactsUseCase: BlockContactsUseCase
  
  init(
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase,
    fetchContactsUseCase: FetchContactsUseCase,
    blockContactsUseCase: BlockContactsUseCase
  ) {
    self.requestContactsPermissionUseCase = requestContactsPermissionUseCase
    self.fetchContactsUseCase = fetchContactsUseCase
    self.blockContactsUseCase = blockContactsUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .tapAccepetButton:
      Task {
        await handleAcceptButtonTap()
      }
    case .showShettingAlert:
      openSettings()
    case .cancelAlert:
      isPresentedAlert = false
    }
  }
  
  @MainActor
  private func handleAcceptButtonTap() async {
    do {
      let isAuthorized = try await requestContactsPermissionUseCase.execute()
      
      if isAuthorized {
        await isToastVisible()
        let userContacts = try await fetchContactsUseCase.execute()
        _ = try await blockContactsUseCase.execute(phoneNumbers: userContacts)
      } else {
        isPresentedAlert = true
      }
    } catch {
      print("\(error.localizedDescription)")
    }
  }
  
  @MainActor
  private func isToastVisible() async {
    showToast = true
    try? await Task.sleep(for: .seconds(2))
    showToast = false
    moveToCompleteSignUp = true
  }
  
  private func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString),
          UIApplication.shared.canOpenURL(url) else { return }
    
    UIApplication.shared.open(url)
  }
}
