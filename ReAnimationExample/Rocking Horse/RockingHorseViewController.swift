//
//  RockingHorseViewController.swift
//  ReAnimationExample
//

import UIKit
import RxSwift
import ReAnimation

final class RockingHorseViewController: UIViewController {

    private let rockingHorseView = RockingHorseView()
    private var disposeBag = DisposeBag()

    override func loadView() {
        self.view = rockingHorseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let duration = 2.0
        rockingHorseView.rx.animate(
            ReactiveAnimations.Move(offsetX: 40, duration: duration)
                .simultaneously(
                    with: ReactiveAnimations.Scale(factorX: 0.5, duration: duration / 2)
                        .followed(by: ReactiveAnimations.Scale(factorX: 1.0, duration: duration))
                )
        )
        .subscribe()
        .disposed(by: disposeBag)
        rockingHorseView.rockingHorseTap
            .withLatestFrom(Observable.just(rockingHorseView.rockingHorseImageView))
            .flatMapLatest {
                $0.rx.animate(
                        ReactiveAnimations.RotateFunction(duration: .pi, interval: 0.1) { interval in
                            CGFloat(sin(interval * 4) / 2)
                        }.indefinite()
                )
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

