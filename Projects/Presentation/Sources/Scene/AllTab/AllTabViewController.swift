import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class AllTabViewController: BaseViewController<AllTabViewModel> {
    private let logoutRelay = PublishRelay<Void>()

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
    }

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private let profileView = PiCKProfileView()
    private let helpSectionView = HelpSectionView()
    private let settingSectionView = SettingSectionView()
    private let accountSectionView = AccountSectionView()
    private lazy var sectionStackView = UIStackView(arrangedSubviews: [
        helpSectionView,
        settingSectionView,
        accountSectionView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.isLayoutMarginsRelativeArrangement = true
    }
    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = AllTabViewModel.Input(
            clickNoticeTab: helpSectionView.getSelectedItem(type: .notice).asObservable(),
            clickSelfStudyTab: helpSectionView.getSelectedItem(type: .selfStudy).asObservable(),
            clickBugReportTab: helpSectionView.getSelectedItem(type: .bugReport).asObservable(),
            clickCutomTab: settingSectionView.getSelectedItem(type: .custom),
            clickNotificationSettingTab: settingSectionView.getSelectedItem(type: .notificationSetting),
            clickMyPageTab: accountSectionView.getSelectedItem(type: .myPage),
            clickLogOutTab: logoutRelay.asObservable()
        )

        _ = viewModel.transform(input: input)

        self.accountSectionView.getSelectedItem(type: .logOut)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                let vc = LogOutAlert(clickLogout: {
                    self?.logoutRelay.accept(())
                })
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self?.present(vc, animated: true)
            }).disposed(by: disposeBag)
    }

    public override func addView() {
        [
            navigationBar,
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)

        [
            profileView,
            sectionStackView
        ].forEach { mainView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }

    public override func setLayoutData() {
        let userInfoData = UserDefaultStorage.shared.get(forKey: .userInfoData) as? String
        self.profileView.setup(image: .profile, info: userInfoData ?? "")
    }

}
