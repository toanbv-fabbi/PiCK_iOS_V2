import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core

public class PiCKProfileView: BaseView {
    private let profileImageView = UIImageView(image: .profile)
    private let userInfoLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1,
        numberOfLines: 0
    )

    public func setup(
        image: UIImage,
        info: String
    ) {
        self.profileImageView.image = image
        self.userInfoLabel.text = "대덕소프트웨어마이스터고\n\(info)"
    }

    public override func attribute() {
        self.backgroundColor = .background
    }
    public override func layout() {
        [
            profileImageView,
            userInfoLabel
        ].forEach { self.addSubview($0) }
        
        self.snp.makeConstraints {
            $0.height.equalTo(84)
        }

        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
            $0.size.equalTo(60)
        }
        userInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(24)
        }

    }

}
