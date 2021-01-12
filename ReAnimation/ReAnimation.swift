//
//  ReAnimation.swift
//  ReAnimation
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    func animate(duration: TimeInterval, options: UIView.AnimationOptions? = nil, block: @escaping ((Base) -> Void)) -> Observable<Base> {
        return Observable.create { observer in
            UIView.animate(withDuration: duration, delay: 0, options: options ?? [], animations: {
                block(self.base)
            }, completion: { _ in
                observer.onNext(self.base)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }

    /// Transforms an array of animations into a single observable encapsulating them all.
    public func animate(_ animations: ReactiveAnimation<Base>...) -> Observable<Base> {
        return animate(animations: Array(animations))
    }

    /// Transforms an array of animations into a single observable encapsulating them all.
    public func animate(animations: [ReactiveAnimation<Base>]) -> Observable<Base> {
        return animations.reduce(Observable<Base>.just(base)) { (acc, animation) -> Observable<Base> in
                return acc.flatMap { view in animation.animate(target: view) }
            }
    }
}
