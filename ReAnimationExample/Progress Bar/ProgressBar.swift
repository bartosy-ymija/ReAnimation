//
//  ProgressBar.swift
//  ReAnimationExample
//

import UIKit
import RxSwift
import RxCocoa
import ReAnimation

final class ProgressBar: UIView {

    private let progressView = with(UIView()) {
        $0.backgroundColor = .systemGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let disposeBag = DisposeBag()
    private var isSetup: Bool = false

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemGray3
        setupHierarchy()
        setupConstraints()
    }

    private func setupHierarchy() {
        addSubview(progressView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.widthAnchor.constraint(equalToConstant: 20),
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupBindings()
    }

    private func setupBindings() {
        guard !isSetup else {
            return
        }
        isSetup = true
        let offset: CGFloat = bounds.width - progressView.bounds.width
        progressView.rx.animate(
            AnimateProgress(direction: .right, offset: offset)
                .followed(by: AnimateProgress(direction: .left, offset: offset))
                .indefinite()
        )
        .subscribe()
        .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class AnimateProgress: ReactiveAnimation<UIView> {
    enum Direction {
        case right
        case left
    }

    private let direction: Direction
    private let offset: CGFloat
    private let duration: Double

    init(direction: Direction, offset: CGFloat, duration: Double = 2) {
        self.direction = direction
        self.offset = offset
        self.duration = duration
        super.init()
    }

    override func animate(target: UIView) -> Observable<UIView> {
        return target.rx.animate(
            ReactiveAnimations.Move(
                offsetX: direction == .right ? offset : -offset,
                duration: duration
            ).simultaneously(with:
                ReactiveAnimations.Scale(factorX: 3, duration: duration / 2)
                    .followed(by: ReactiveAnimations.Scale(duration: duration / 2))
            )
        )
    }
}
