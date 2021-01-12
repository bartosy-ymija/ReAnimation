//
//  MutateTag.swift
//  ReAnimationTests
//

@testable import ReAnimation
import RxSwift

final class SetTag<Target: UIView>: ReactiveAnimation<Target> {
    private let tag: Int

    init(to tag: Int) {
        self.tag = tag
    }

    override func animate(target: Target) -> Observable<Target> {
        return target.rx.animate(
            ReactiveAnimations.Mutate { [unowned self] animatedView in
                animatedView.tag = self.tag
            }
        )
    }
}
