//
//  RockingHorseView.swift
//  ReAnimationExample
//

import UIKit
import RxSwift
import ReAnimation
import RxRelay

final class RockingHorseView: UIView {

    let rockingHorseTap = PublishRelay<Void>()

    lazy var rockingHorseImageView = with(UIImageView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = #imageLiteral(resourceName: "rocking-horse")
        $0.center = $0.center.applying(CGAffineTransform(translationX: -RockingHorseView.rockingHorseSize / 2, y: 0))
        $0.addGestureRecognizer(rockingHorseTapRecognizer)
        $0.isUserInteractionEnabled = true
    }

    private lazy var rockingHorseTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapRockingHorse))

    private static let rockingHorseSize = CGFloat(60)

    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(rockingHorseImageView)
        NSLayoutConstraint.activate([
            rockingHorseImageView.widthAnchor.constraint(equalToConstant: RockingHorseView.rockingHorseSize),
            rockingHorseImageView.heightAnchor.constraint(equalToConstant: RockingHorseView.rockingHorseSize),
            rockingHorseImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rockingHorseImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func didTapRockingHorse() {
        rockingHorseTap.accept(())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
