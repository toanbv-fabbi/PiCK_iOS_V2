import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class WeekendMealApplyViewController: BaseViewController<WeekendMealApplyViewModel> {
    private let weekendMealStatusRelay = PublishRelay<WeekendMealType>()

    private let titleLabel = PiCKLabel(
        text: "주말 급식",
        textColor: .modeBlack,
        font: .heading4
    )
    private let explainLabel = PiCKLabel(
        text: "신청 여부는 담임 선생님이 확인 후 영양사 선생님에게 전달돼요.",
        textColor: .gray500,
        font: .caption2
    )
    private lazy var weekendMealApplyView = WeekendMealApplyView(clickWeekendMealStatus: { data in
        self.weekendMealStatusRelay.accept(data)
    })
    private let saveButton = PiCKButton(buttonText: "저장하기")

    public override func attribute() {
        super.attribute()

        navigationTitleText = "주말 급식 신청"
    }

    public override func bind() {
        let input = WeekendMealApplyViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            applyStatus: weekendMealStatusRelay.asObservable(),
            clickApplyButton: saveButton.buttonTap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.weekendMealStatus.asObservable()
            .bind {
                self.weekendMealApplyView.setup(status: $0 == .ok)
            }
            .disposed(by: disposeBag)
    }

    public override func bindAction() { }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            weekendMealApplyView,
            saveButton
        ].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        weekendMealApplyView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

}
