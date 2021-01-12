//
//  Concat.swift
//  ReAnimation
//

import RxSwift

final class Concat<Target: UIView>: ReactiveAnimation<Target> {

    private let lAnimation: ReactiveAnimation<Target>
    private let rAnimation: ReactiveAnimation<Target>

    init(_ lAnimation: ReactiveAnimation<Target>, _ rAnimation: ReactiveAnimation<Target>) {
        self.lAnimation = lAnimation
        self.rAnimation = rAnimation
    }

    override func animate(target: Target) -> Observable<Target> {
        return lAnimation.animate(target: target).flatMap { [unowned self] animatedView in
            return self.rAnimation.animate(target: animatedView)
        }
    }
}
