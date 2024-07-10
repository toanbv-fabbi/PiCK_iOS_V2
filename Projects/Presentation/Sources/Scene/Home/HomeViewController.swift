import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainView = UIView()
    
    private let navigationBar = PiCKMainNavigationBar()
    private let profileImageView = UIImageView(image: .profile)
    private let userInfoLabel = UILabel().then {
        //TODO: 행간 조절
        $0.text = "대덕소프트웨어마이스터고등학교\n2학년 4반 조영준"
        $0.textColor = .modeBlack
        $0.font = .label1
        $0.numberOfLines = 0
    }
    private let todayTimeTableLabel = UILabel().then {
        $0.text = "오늘의 시간표"
        $0.textColor = .gray700
        $0.font = .label1
    }
    private let topCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    //TODO: 시간표가 바뀌었다는 알림을 headerView로 표현?
    private lazy var topCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: topCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .red
    }
    private let selfStudyBannerView = PiCKMainBannerView()
    private let recentNoticeLabel = UILabel().then {
        $0.text = "최신 공지"
        $0.textColor = .gray700
        $0.font = .label1
    }
    private let viewMoreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.gray800, for: .normal)
        $0.titleLabel?.font = .label1
    }
    private lazy var noticeStackView = UIStackView(arrangedSubviews: [
        recentNoticeLabel,
        viewMoreButton
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private let bottomCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    private lazy var bottomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bottomCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .blue
    }

    public override func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    public override func bindAction() {
        navigationBar.viewSettingButtonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKBottomSheetAlert(type: .viewType)
//                let vc = PiCKBottomSheetAlert(
//                    explainText: "픽은 라이트 모드 또는 다크 모드로 변경할 수 있어요",
//                    questionText: "픽을 다크 모드로 설정 하시겠어요?",
//                    buttonText: "다크 모드로 설정하기"
//                )
                let customDetents = UISheetPresentationController.Detent.custom(
                    identifier: .init("sheetHeight")
                ) { _ in
                    return 252
                }

                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [customDetents]
                }
                self?.present(vc, animated: true)
            }).disposed(by: disposeBag)
        navigationBar.displayModeButtonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKBottomSheetAlert(type: .displayMode)
//                let vc = PiCKBottomSheetAlert(
//                    explainText: "픽은 메인 페이지를 커스텀 할 수 있어요!",
//                    questionText: "메인에서 오늘의 급식 보기 ",
//                    buttonText: "급식으로 설정하기",
//                    typeLabel: "지금은 시간표로 설정되어 있어요"
//                )
                let customDetents = UISheetPresentationController.Detent.custom(
                    identifier: .init("sheetHeight")
                ) { _ in
                    return 228
                }

                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [customDetents]
                }
                self?.present(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    public override func addView() {
        [
            navigationBar,
            profileImageView,
            userInfoLabel,
            scrollView
        ].forEach { view.addSubview($0) }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)
        
       [
            todayTimeTableLabel,
            topCollectionView,
            selfStudyBannerView,
            noticeStackView,
            bottomCollectionView,
       ].forEach { mainView.addSubview($0) }
    }
    
    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.view.frame.height * 1.8)
        }

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(60)
        }
        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(46)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(24)
        }

        todayTimeTableLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        topCollectionView.snp.makeConstraints {
            $0.top.equalTo(todayTimeTableLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)//TODO: 높이 조절 필요
        }
        selfStudyBannerView.snp.makeConstraints {
            $0.top.equalTo(topCollectionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(160)
        }
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(selfStudyBannerView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        bottomCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentNoticeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)//TODO: 높이 조절 필요
        }
    }

}
