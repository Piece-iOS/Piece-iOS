//
// MatchResultView.swift
// MatchResult
//
// Created by summercat on 2025/02/20.
//

import SwiftUI
import Entities
import DesignSystem
import Router
import UseCases

struct MatchResultView: View {
  @State var viewModel: MatchResultViewModel
  @Environment(Router.self) private var router: Router
  
  init(
    nickname: String,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    getMatchContactsUseCase: GetMatchContactsUseCase
  ) {
    _viewModel = .init(wrappedValue: .init(
      nickname: nickname,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      getMatchContactsUseCase: getMatchContactsUseCase
    ))
  }

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      NavigationBar(
        title: "",
        rightButtonTap: {
          router.pop()
        }
      )
      
      headerText
        .padding(.top, 20)
      
      ZStack(alignment: .center) {
        AsyncImage(url: URL(string: viewModel.imageUri)) { image in
          image.image?
            .resizable()
            .scaledToFill()
        }
        .frame(width: 220, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .opacity(viewModel.photoOpacity)
        .animation(.easeIn(duration: 0.3), value: viewModel.photoOpacity)
        
        PCLottieView(
          .matching_motion,
          loopMode: .playOnce,
          width: 500,
          height: 500
        )  { animationFinished in
          viewModel.handleAction(.matchingAnimationDidFinish(animationFinished))
        }
        .opacity(viewModel.matchingAnimationOpacity)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            viewModel.handleAction(.showProfilePhoto)
          }
        }
      }
      
      buttons
      contactCard
        .padding(.horizontal, 20)
        .padding(.top, 22)
    }
    .background(
      DesignSystemAsset.Images.matchingBG.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
    )
    .onAppear { viewModel.handleAction(.onAppear) }
  }
  
  private var headerText: some View {
    VStack(alignment: .center, spacing: 8) {
      Group { Text(viewModel.nickname).foregroundStyle(.primaryDefault) + Text("님과 퍼즐 완성 !").foregroundStyle(.grayscaleBlack) }
        .pretendard(.heading_L_SB)
     Text("망설이지 말고 연락해 보세요\n두 분의 평화로운 사랑을 피스가 응원해요")
        .multilineTextAlignment(.center)
        .foregroundStyle(.grayscaleDark1)
        .pretendard(.body_M_R)
    }
  }
  
  private var buttons: some View {
    HStack(spacing: 12) {
      ForEach(viewModel.contacts) { contact in
        CircleButton(
          type: viewModel.selectedContact == contact ? .solid_primary : .solid_white,
          icon: contact.icon,
          action: { viewModel.handleAction(.didTapContactIcon(contact)) }
        )
      }
    }
  }
  
  private var contactCard: some View {
    VStack(alignment: .center, spacing: 8) {
      HStack(alignment: .center, spacing: 8) {
        viewModel.selectedContact?.smallIcon
          .renderingMode(.template)
        Text(viewModel.selectedContact?.description ?? "")
          .pretendard(.body_S_SB)
      }
      .foregroundStyle(.grayscaleDark3)
      
      HStack(alignment: .center, spacing: 8) {
        Text(viewModel.selectedContact?.value ?? "")
          .pretendard(.heading_M_SB)
        Button {
          viewModel.handleAction(.didTapCopyButton)
        } label: {
          DesignSystemAsset.Icons.copy20.swiftUIImage
            .renderingMode(.template)
        }
      }
      .foregroundStyle(.grayscaleBlack)
    }
    .padding(.horizontal, 32)
    .padding(.vertical, 20)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.grayscaleWhite)
    )
  }
}

#Preview {
  let dummyMatchPhotoUseCase = DummyGetMatchPhotoUseCase()
  let dummyMatchContactsUseCase = DummyGetMatchContactsUseCase()
  
  return MatchResultView(
    nickname: "수줍은 수달",
    getMatchPhotoUseCase: dummyMatchPhotoUseCase,
    getMatchContactsUseCase: dummyMatchContactsUseCase
  )
  .environment(Router())
}

private final class DummyGetMatchPhotoUseCase: GetMatchPhotoUseCase {
  func execute() async throws -> String {
    "https://fastly-s3.allmusic.com/artist/mn0003475903/400/eznhFWvkuIfytZytXtr9bR_TZlp6n_cq-Emr2zx15tU=.jpg"
  }
}

private final class DummyGetMatchContactsUseCase: GetMatchContactsUseCase {
  func execute() async throws -> MatchContactsModel {
    MatchContactsModel(
      contacts: [
        ContactModel(type: .kakao, value: "kakao id"),
        ContactModel(type: .instagram, value: "instagram id"),
      ]
    )
  }
}
