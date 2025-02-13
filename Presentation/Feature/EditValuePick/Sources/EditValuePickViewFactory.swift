//
//  EditValuePickViewFactory.swift
//  EditValuePick
//
//  Created by summercat on 2/12/25.
//

import SwiftUI
import UseCases

public struct EditValuePickViewFactory {
  public static func createEditValuePickViewFactory(
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase,
    updateProfileValuePicksUseCase: UpdateProfileValuePicksUseCase
  ) -> some View {
    EditValuePickView(
      getProfileValuePicksUseCase: getProfileValuePicksUseCase,
      updateProfileValuePicksUseCase: updateProfileValuePicksUseCase
    )
  }
}
