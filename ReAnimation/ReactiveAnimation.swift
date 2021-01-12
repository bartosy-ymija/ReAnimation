//
//  ReactiveAnimation.swift
//  ReAnimation
//

import RxSwift

/// Base class for reactive animations.
open class ReactiveAnimation<Target: UIView> {

    /// Options which will be passed to the UIView.animate call.
    /// If nil, empty set of options will be passed to the method.
    var options: UIView.AnimationOptions?

    public init() {}

    /// An overridable method which transforms the target and returns it with applied transformation
    /// in the context of an Observable. Defaults to identity.
    /// - Parameters:
    ///   - target: A target to the transformation.
    open func animate(target: Target) -> Observable<Target> {
        return Observable.just(target)
    }

    /// Returns an animation which performs this animation and animation passed as a parameter at the same time.
    /// - Parameters:
    ///   - animation: The animation to be performed alongside this animation.
    public func simultaneously(with animation: ReactiveAnimation<Target>) -> ReactiveAnimation<Target> {
        return Merge(self, animation)
    }

    /// Operator which is a shorthand for simultaneously method.
    public static func &(lhs: ReactiveAnimation<Target>, rhs: ReactiveAnimation<Target>) -> ReactiveAnimation<Target> {
        return lhs.simultaneously(with: rhs)
    }

    /// Returns an animation which performs the animation passed as a parameter after this animation.
    /// - Parameters:
    ///   - animation: The animation to be performed after this animation.
    public func followed(by animation: ReactiveAnimation<Target>) -> ReactiveAnimation<Target> {
        return Concat(self, animation)
    }

    /// Operator which is a shorthand for followed method.
    public static func +(lhs: ReactiveAnimation<Target>, rhs: ReactiveAnimation<Target>) -> ReactiveAnimation<Target> {
        return lhs.followed(by: rhs)
    }

    /// Returns this animation delayed by the specified interval.
    /// - Parameters:
    ///   - delayInterval: Interval after which the animation should be performed.
    public func delayed(by delayInterval: RxTimeInterval) -> ReactiveAnimation<Target> {
        return Delay(self, by: delayInterval)
    }

    /// Returns this animation repeated indefinitely.
    public func indefinite() -> ReactiveAnimation<Target> {
        return Indefinite(self)
    }

    /// Returns this animation with given options.
    /// - Parameters:
    ///   - options: The options which will replace current ones.
    public func with<T: ReactiveAnimation<Target>>(options: UIView.AnimationOptions?) -> T {
        self.options = options
        return self as! T
    }
}
