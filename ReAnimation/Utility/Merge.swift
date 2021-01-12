//
//  Merge.swift
//  ReAnimation
//

import RxSwift

final class Merge<Target: UIView>: ReactiveAnimation<Target> {

    private let lAnimation: ReactiveAnimation<Target>
    private let rAnimation: ReactiveAnimation<Target>

    init(_ lAnimation: ReactiveAnimation<Target>, _ rAnimation: ReactiveAnimation<Target>) {
        self.lAnimation = lAnimation
        self.rAnimation = rAnimation
    }

    override func animate(target: Target) -> Observable<Target> {
        return Observable.merge(lAnimation.animate(target: target), rAnimation.animate(target: target))
            .skip(1)
    }
}
