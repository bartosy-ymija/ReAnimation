//
//  PulsingCirclesView.swift
//  ReAnimationExample
//

import UIKit
import RxSwift
import ReAnimation
import RxRelay

final class PulsingCirclesView: UIView {

    private let disposeBag = DisposeBag()

    private let circles = (0...2).map { _ in
        with(UIView()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .systemGreen
            $0.layer.cornerRadius = 20
            $0.alpha = 0.75
        }
    }

    private let solidCircle = with(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 20
    }

    private let circleSize = CGFloat(40)

    private static let animationDelay = 700

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        animateCircles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        circles.forEach {
            addSubview($0)
        }
        addSubview(solidCircle)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            solidCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            solidCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            solidCircle.heightAnchor.constraint(equalToConstant: circleSize),
            solidCircle.widthAnchor.constraint(equalToConstant: circleSize)
        ])
        NSLayoutConstraint.activate(
            circles.flatMap { circle in
                [
                    circle.centerXAnchor.constraint(equalTo: centerXAnchor),
                    circle.centerYAnchor.constraint(equalTo: centerYAnchor),
                    circle.heightAnchor.constraint(equalToConstant: circleSize),
                    circle.widthAnchor.constraint(equalToConstant: circleSize)
                ]
            }
        )
    }

    private func animateCircles() {
        circles.indices.map { index -> Disposable in
            let circle = circles[index]
            return circle.rx.animate(PulseAnimation().delayed(by: .milliseconds(PulsingCirclesView.animationDelay * index)))
                .subscribe()
        }
        .forEach { disposable in
            disposable.disposed(by: disposeBag)
        }
    }
}

private final class PulseAnimation: ReactiveAnimation<UIView> {

    private let duration: Double

    init(duration: Double = 3) {
        self.duration = duration
    }

    override func animate(target: UIView) -> Observable<UIView> {
        target.rx.animate(
            ReactiveAnimations.Scale(factorX: 3, factorY: 3, duration: duration)
                .simultaneously(with: ReactiveAnimations.Alpha(0, duration: duration))
                .followed(by: ReactiveAnimations.Mutate {
                    $0.alpha = 0.75
                    $0.transform = .identity
                 })
                .indefinite()
        )
    }
}
