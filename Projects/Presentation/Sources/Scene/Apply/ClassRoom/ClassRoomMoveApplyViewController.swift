import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassRoomMoveApplyViewController: BaseViewController<ClassRoomMoveApplyViewModel> {
    
    private let classRoomMoveApplyRelay = PublishRelay<Void>()
    private var classRoomText = BehaviorRelay<String>(value: "")
    private var startPeriod = BehaviorRelay<Int>(value: 1)
    private var endPeriod = BehaviorRelay<Int>(value: 1)
    private lazy var selectedSegemetedControlIndex = BehaviorRelay<Int>(value: 1)
    private lazy var currentFloorClassroomArray = BehaviorRelay<[String]>(value: classRoomData.firstFloor)

    private let classRoomData = ClassRoomData.shared

    private let titleLabel = PiCKLabel(text: "교실 이동", textColor: .modeBlack, font: .heading4)
    private let explainLabel = PiCKLabel(text: "자습 감독 선생님께서 수락 후 이동할 수 있습니다.", textColor: .gray600, font: .body2)
    private let floorSegmentedControl = ClassRoomSegmentedControl(items: [
        "1층",
        "2층",
        "3층",
        "4층",
        "5층"
    ]).then {
        $0.selectedSegmentIndex = 0
    }
    private lazy var collectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumLineSpacing = 15
        $0.minimumInteritemSpacing = 16
    }
    private lazy var classRoomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.register(
            ClassRoomCollectionViewCell.self,
            forCellWithReuseIdentifier: ClassRoomCollectionViewCell.identifier
        )
        $0.contentInsetAdjustmentBehavior = .always
        $0.bounces = false
    }
    private let nextButton = PiCKButton(type: .system, buttonText: "다음", isEnabled: false)

    public override func attribute() {
        super.attribute()

        navigationTitleText = "교실 이동 신청"
    }
    public override func bind() {
        let input = ClassRoomMoveApplyViewModel.Input(
            floorText: selectedSegemetedControlIndex.asObservable(),
            classRoomText: classRoomText.asObservable(),
            startPeriod: startPeriod.asObservable(),
            endPeriod: endPeriod.asObservable(),
            clickClassRoomMoveApply: classRoomMoveApplyRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isApplyButtonEnable.asObservable()
            .bind(onNext: { [weak self] isEnabled in
                self?.nextButton.isEnabled = isEnabled
            }).disposed(by: disposeBag)

        floorSegmentedControl.rx.selectedSegmentIndex
            .map { [weak self] index -> [String] in
                self?.selectedSegemetedControlIndex.accept(index + 1)
                self?.classRoomText.accept("")
                switch index {
                case 0: 
                    return self?.classRoomData.firstFloor ?? []
                case 1:
                    return self?.classRoomData.secondFloor ?? []
                case 2:
                    return self?.classRoomData.thirdFloor ?? []
                case 3: 
                    return self?.classRoomData.fourthFloor ?? []
                case 4:
                    return self?.classRoomData.fifthFloor ?? []
                default: 
                    return self?.classRoomData.firstFloor ?? []
                }
            }
            .bind(to: currentFloorClassroomArray)
            .disposed(by: disposeBag)
        
        currentFloorClassroomArray
            .bind(to: classRoomCollectionView.rx.items(
                cellIdentifier: ClassRoomCollectionViewCell.identifier,
                cellType: ClassRoomCollectionViewCell.self
            )) { row, item, cell in
//                cell.adapt(model: .init(classRoom: [item]))
                cell.setup(classRoom: item)
            }.disposed(by: disposeBag)
        
        classRoomCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.classRoomText.accept(
                    self?.currentFloorClassroomArray.value[index.row] ?? ""
                )
            }).disposed(by: disposeBag)
        
        nextButton.buttonTap
            .bind {
                let vc = PiCKApplyTimePickerAlert()
                vc.selectedPeriod = { [weak self] startPeriod, endPeriod in
                    self?.startPeriod.accept(startPeriod)
                    self?.endPeriod.accept(endPeriod)
                }
                vc.clickApplyButton = { [weak self] in
                    self?.classRoomMoveApplyRelay.accept(())
                }
                self.presentAsCustomDents(view: vc, height: 406)
            }.disposed(by: disposeBag)
        
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            floorSegmentedControl,
            classRoomCollectionView,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        floorSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        classRoomCollectionView.snp.makeConstraints {
            $0.top.equalTo(floorSegmentedControl.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}