//
// SettingsView.swift
// Settings
//
// Created by summercat on 2025/02/12.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct SettingsView: View {
  @State var viewModel: SettingsViewModel
  @Environment(Router.self) var router
  
  init(
    fetchTermsUseCase: FetchTermsUseCase,
    notificationPermissionUseCase: NotificationPermissionUseCase,
    checkContactsPermissionUseCase: CheckContactsPermissionUseCase,
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase,
    fetchContactsUseCase: FetchContactsUseCase,
    blockContactsUseCase: BlockContactsUseCase,
    getContactsSyncTimeUseCase: GetContactsSyncTimeUseCase,
    patchLogoutUseCase: PatchLogoutUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        fetchTermsUseCase: fetchTermsUseCase,
        notificationPermissionUseCase: notificationPermissionUseCase,
        checkContactsPermissionUseCase: checkContactsPermissionUseCase,
        requestContactsPermissionUseCase: requestContactsPermissionUseCase,
        fetchContactsUseCase: fetchContactsUseCase,
        blockContactsUseCase: blockContactsUseCase,
        getContactsSyncTimeUseCase: getContactsSyncTimeUseCase,
        patchLogoutUseCase: patchLogoutUseCase
      )
    )
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HomeNavigationBar(
        title: "Settings",
        foregroundColor: .grayscaleBlack
      )
      Divider(weight: .normal, isVertical: false)
      ScrollView(showsIndicators: false) {
        VStack(spacing: 16) {
          ForEach(
            Array(zip(viewModel.sections.indices, viewModel.sections)),
            id: \.1.id
          ) { index, section in
            makeSections(section)
            if index != viewModel.sections.count - 1 {
              Divider(weight: .normal, isVertical: false)
            }
          }
          
          PCTextButton(content: "탈퇴하기")
            .onTapGesture {
              viewModel.handleAction(.withdrawButtonTapped)
            }
          
          Spacer()
        }
        .padding(.vertical, 20)
      }
      .contentMargins(.horizontal, 20)
      .padding(.bottom, 89) // 탭바 높이 만큼 패딩
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .pcAlert(isPresented: $viewModel.showLogoutAlert) {
      AlertView(
        title: {
          Text("로그아웃")
        },
        message: "로그아웃하시겠습니까?",
        firstButtonText: "취소",
        secondButtonText: "확인",
        firstButtonAction: { viewModel.showLogoutAlert = false },
        secondButtonAction: { viewModel.handleAction(.confirmLogoutButton) }
      )
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .onChange(of: viewModel.destination) { _, destination in
      guard let destination else { return }
      router.push(to: destination)
      viewModel.handleAction(.clearDestination)
    }
  }
  
  @ViewBuilder
  private func makeSections(_ section: SettingSection) -> some View {
    switch section.id {
    case .notification:
      SettingsNotificationSettingSectionView(
        title: section.title,
        isMatchingNotificationOn: $viewModel.isMatchingNotificationOn,
        isPushNotificationOn: $viewModel.isPushNotificationEnabled,
        matchingNotificationToggled: { isEnabled in viewModel.handleAction(.matchingNotificationToggled(isEnabled)) },
        pushNotificationToggled: { isEnabled in viewModel.handleAction(.pushNotificationToggled(isEnabled)) }
      )
    case .system:
      SettingsSystemSettingSectionView(
        title: section.title,
        isBlockingFriends: $viewModel.isBlockContactsEnabled,
        date: $viewModel.updatedDate,
        blockContactsToggled: { isEnabled in viewModel.handleAction(.blockContactsToggled(isEnabled)) },
        didTapRefreshButton: { viewModel.handleAction(.synchronizeContactsButtonTapped) }
      )
    case .ask:
      SettingsAskSectionView(
        title: section.title,
        askTitle: "문의하기",
        didTapAskView: {
          router.push(to: .settingsWebView(title: "문의하기", uri: viewModel.inquiriesUri))
        }
      )
    case .information:
      SettingsInformationSectionView(
        title: "안내",
        termsItems: $viewModel.termsItems,
        version: viewModel.version,
        didTapNoticeItem: {
          router.push(to: .settingsWebView(title: "공지사항", uri: viewModel.noticeUri))
        },
        didTapTermsItem: {
          viewModel.handleAction(.termsItemTapped(id: $0))
          if let tappedTermItem = viewModel.tappedTermItem {
            router.push(to: .settingsWebView(
              title: tappedTermItem.title,
              uri: tappedTermItem.content
            ))
          }
        }
      )
    case .etc:
      SettingsEtcSectionview(
        title: "기타",
        logoutTitle: "로그아웃",
        didTapLogoutItem: {
          viewModel.handleAction(.logoutItemTapped)
        }
      )
    }
  }
}
