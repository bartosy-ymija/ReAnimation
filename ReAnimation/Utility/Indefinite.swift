//
//  Indefinite.swift
//  ReAnimation
//

import Foundation
import RxSwift
import RxRelay

final class Indefinite<Target: UIView>: ReactiveAnimation<Target> {

    private let animation: ReactiveAnimation<Target>
    private let animationTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    init(_ animation: ReactiveAnimation<Target>) {
        self.animation = animation
    }

    override func animate(target: Target) -> Observable<Target> {
        let animation = animationTrigger.startWith(())
            .flatMapLatest { [unowned self] _ -> Observable<Target> in
                return self.animation.animate(target: target)
            }
            .share()
        animation.map { _ in () }
            .bind(to: animationTrigger)
            .disposed(by: disposeBag)
        return animation
    }
}
