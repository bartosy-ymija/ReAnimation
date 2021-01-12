//
//  Delay.swift
//  ReAnimation
//

import RxSwift

final class Delay<Target: UIView>: ReactiveAnimation<Target> {

    private let animation: ReactiveAnimation<Target>
    private let delayInterval: RxTimeInterval

    init(_ animation: ReactiveAnimation<Target>, by delayInterval: RxTimeInterval) {
        self.animation = animation
        self.delayInterval = delayInterval
    }

    override func animate(target: Target) -> Observable<Target> {
        return Observable.just(target)
            .delay(delayInterval, scheduler: MainScheduler.asyncInstance)
            .flatMap { [unowned self] animatedView in
                return self.animation.animate(target: animatedView)
            }
    }
}
