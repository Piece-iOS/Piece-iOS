//
//  MatchingTimer.swift
//  MatchingMain
//
//  Created by eunseou on 1/8/25.
//

import SwiftUI
import DesignSystem

// MARK: - 타이머
struct MatchingTimer: View {
  @Bindable var matchingTimerViewModel: MatchingTimerViewModel
  let prefixMessage: String
  
  var body: some View {
    HStack(spacing: 4) {
      Text(prefixMessage)
      Text(matchingTimerViewModel.state.timeString)
        .pretendard(.body_S_SB)
        .foregroundColor(.subDefault)
      Text("남았어요")
    }
    .pretendard(.body_S_M)
    .foregroundStyle(Color.grayscaleLight1)
    .padding(.vertical, 12)
    .frame(maxWidth: .infinity, maxHeight: 44)
    .background(
      Rectangle()
        .foregroundStyle(Color.grayscaleWhite.opacity(0.1))
    )
    .cornerRadius(8)
  }
}

#Preview {
  MatchingTimer(matchingTimerViewModel: MatchingTimerViewModel(), prefixMessage: "소중한 인연이 사라지기까지")
}
