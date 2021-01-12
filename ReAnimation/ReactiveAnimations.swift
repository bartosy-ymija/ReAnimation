//
//  ReactiveAnimations.swift
//  ReAnimation
//

import RxSwift

/// A namespace for common reactive animations definitions.
public enum ReactiveAnimations {

    // MARK: Core

    /// A core class which describes an animation with given duration and animation block.
    public final class Animate<Target: UIView>: ReactiveAnimation<Target> {
        /// The duration of the animation.
        let duration: TimeInterval
        /// A block with animations to be performed in UIView.animate
        let block: (Target) -> Void

        /// Initializes the Animate object.
        /// - Parameters:
        ///   - duration: The duration of the animation.
        ///   - block: A block with animations to be performed in UIView.animate
        public init(duration: TimeInterval, block: @escaping (Target) -> Void) {
            self.duration = duration
            self.block = block
        }

        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(duration: duration, options: options, block: block)
        }
    }

    /// A core class which describes a transformation defined by block.
    /// By default the transformation is performed without any delay.
    public final class Mutate<Target: UIView>: ReactiveAnimation<Target> {
        /// A block with the transformation to be performed.
        let block: (Target) -> Void

        /// Initializes the Mutate object.
        /// - Parameters:
        ///   - block: A block with the transformation to be performed.
        public init(_ block: @escaping (Target) -> Void) {
            self.block = block
        }

        override public func animate(target: Target) -> Observable<Target> {
            block(target)
            return Observable.just(target)
        }
    }

    // MARK: Basic animations

    /// A convenience class which describes an animation of the alpha property in the given duration.
    public final class Alpha<Target: UIView>: ReactiveAnimation<Target> {
        /// The expected value of the alpha property.
        let alpha: CGFloat
        /// The duration of the animation.
        let duration: TimeInterval

        /// Initializes the Alpha object.
        /// - Parameters:
        ///   - alpha: The expected value of the alpha property.
        ///   - duration: The duration of the animation.
        public init(_ alpha: CGFloat, duration: TimeInterval) {
            self.alpha = alpha
            self.duration = duration
        }

        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(
                ReactiveAnimations.Animate(duration: duration) { [unowned self] animatedView in
                    animatedView.alpha = self.alpha
                }
                .with(options: options)
            )
        }
    }

    /// A convenience class which describes a rotation animation by a given angle in the given duration.
    public final class Rotate<Target: UIView>: ReactiveAnimation<Target> {
        /// An angle by which rotation should be performed.
        let angle: CGFloat
        /// The duration of the animation.
        let duration: TimeInterval

        /// Initializes the Rotate object.
        /// - Parameters:
        ///   - angle: An angle by which rotation should be performed.
        ///   - duration: The duration of the animation.
        public init(angle: CGFloat, duration: TimeInterval) {
            self.angle = angle
            self.duration = duration
        }

        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(
                ReactiveAnimations.Animate(duration: duration) { [unowned self] animatedView in
                    animatedView.transform = CGAffineTransform(rotationAngle: self.angle)
                }
                .with(options: options)
            )
        }
    }

    /// A convenience class which describes a scale animation by a given factor in the given duration.
    public final class Scale<Target: UIView>: ReactiveAnimation<Target> {
        /// A factor by which view should be scaled in the x axis.
        let factorX: CGFloat
        /// A factor by which view should be scaled in the y axis.
        let factorY: CGFloat
        /// The duration of the animation.
        let duration: TimeInterval

        /// Initializes the Rotate object.
        /// - Parameters:
        ///   - xFactor: A factor by which view should be scaled in the x axis.
        ///   - yFactor: A factor by which view should be scaled in the y axis.
        ///   - duration: The duration of the animation.
        public init(factorX: CGFloat = 1.0, factorY: CGFloat = 1.0, duration: TimeInterval) {
            self.factorX = factorX
            self.factorY = factorY
            self.duration = duration
        }

        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(
                ReactiveAnimations.Animate(duration: duration) { [unowned self] animatedView in
                    animatedView.transform = CGAffineTransform(scaleX: self.factorX, y: self.factorY)
                }
                .with(options: options)
            )
        }
    }

    /// A convenience class which describes a translation animation by a given factor in the given duration.
    /// This  class animates the affine transform translation; If you want to move the view, please use Move.
    public final class Translate<Target: UIView>: ReactiveAnimation<Target> {
        /// A factor by which view should be translated in the x axis.
        let translationX: CGFloat
        /// A factor by which view should be translated in the y axis.
        let translationY: CGFloat
        /// The duration of the animation.
        let duration: TimeInterval

        /// Initializes the Rotate object.
        /// - Parameters:
        ///   - translationX: A factor by which view should be translated in the x axis.
        ///   - yTranslation: A factor by which view should be translated in the y axis.
        ///   - duration: The duration of the animation.
        public init(translationX: CGFloat = 0, translationY: CGFloat = 0, duration: TimeInterval) {
            self.translationX = translationX
            self.translationY = translationY
            self.duration = duration
        }

        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(
                ReactiveAnimations.Animate(duration: duration) { [unowned self] animatedView in
                    animatedView.transform = CGAffineTransform(translationX: self.translationX, y: self.translationY)
                }
                .with(options: options)
            )
        }
    }

    /// A convenience class which describes a move animation by a given offset in the given duration.
    public final class Move<Target: UIView>: ReactiveAnimation<Target> {
        /// A factor by which view should be translated in the x axis.
        let offsetX: CGFloat
        /// A factor by which view should be translated in the y axis.
        let offsetY: CGFloat
        /// The duration of the animation.
        let duration: TimeInterval

        /// Initializes the Rotate object.
        /// - Parameters:
        ///   - xOffset: A factor by which view should be translated in the x axis.
        ///   - yOffset: A factor by which view should be translated in the y axis.
        ///   - duration: The duration of the animation.
        public init(offsetX: CGFloat = 0, offsetY: CGFloat = 0, duration: TimeInterval) {
            self.offsetX = offsetX
            self.offsetY = offsetY
            self.duration = duration
        }

        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(
                ReactiveAnimations.Animate(duration: duration) { [unowned self] animatedView in
                    let currentCenter = animatedView.center
                    let newCenter = CGPoint(x: currentCenter.x + self.offsetX, y: currentCenter.y + self.offsetY)
                    animatedView.center = newCenter
                }
                .with(options: options)
            )
        }
    }

    // MARK: Function based animations

    /// A convenience class which describes an alpha animation with the alpha value change described by the given function in the given duration.
    /// The function is sampled every time the given interval passes with the total time as a parameter.
    /// For example, the duration with a value of 0.5 and the interval with a value of 0.1 yields [0.0, 0.1, 0.2, 0.3, 0.4, 0.5] as parameters which are passed to the sampling function.
    public final class AlphaFunction<Target: UIView>: ReactiveAnimation<Target> {
        private let duration: TimeInterval
        private let interval: TimeInterval
        private let isLinear: Bool
        private let function: (TimeInterval) -> (CGFloat)

        /// Initializes the AlphaFunction object.
        /// - Parameters:
        ///   - duration: The duration of the animation.
        ///   - interval: An interval describing how often the new value should be sampled.
        ///   - isLinear: Describes whether animations should be played with curveLinear option. Defaults to true.
        ///   - function: Function which describes how the properties of this animation change.
        public init(duration: TimeInterval, interval: TimeInterval, isLinear: Bool = true, function: @escaping (TimeInterval) -> (CGFloat)) {
            self.duration = duration
            self.interval = interval
            self.isLinear = isLinear
            self.function = function
        }

        override public func animate(target: Target) -> Observable<Target> {
            target.rx.animate(
                FunctionAnimation(
                    duration: duration,
                    interval: interval,
                    isLinear: isLinear,
                    function: Functions.packToArray(function),
                    animationFunction: { [unowned self] results in
                        Alpha(results[0], duration: self.interval)
                    }
                )
            )
        }
    }

    /// A convenience class which describes a rotation animation with the angle value change described by the given function in the given duration.
    /// The function is sampled every time the given interval passes with the total time as a parameter.
    /// For example, the duration with a value of 0.5 and the interval with a value of 0.1 yields [0.0, 0.1, 0.2, 0.3, 0.4, 0.5] as parameters which are passed to the sampling function.
    public final class RotateFunction<Target: UIView>: ReactiveAnimation<Target> {
        private let duration: TimeInterval
        private let interval: TimeInterval
        private let isLinear: Bool
        private let function: (TimeInterval) -> (CGFloat)

        /// Initializes the RotateFunction object.
        /// - Parameters:
        ///   - duration: The duration of the animation.
        ///   - interval: An interval describing how often the new value should be sampled.
        ///   - isLinear: Describes whether animations should be played with curveLinear option. Defaults to true.
        ///   - function: Function which describes how the properties of this animation change.
        public init(duration: TimeInterval, interval: TimeInterval, isLinear: Bool = true, function: @escaping (TimeInterval) -> (CGFloat)) {
            self.duration = duration
            self.interval = interval
            self.isLinear = isLinear
            self.function = function
        }

        override public func animate(target: Target) -> Observable<Target> {
            target.rx.animate(
                FunctionAnimation(
                    duration: duration,
                    interval: interval,
                    isLinear: isLinear,
                    function: Functions.packToArray(function),
                    animationFunction: { [unowned self] results in
                        Rotate(angle: results[0], duration: self.interval)
                    }
                )
            )
        }
    }

    /// A convenience class which describes a scale animation with the x factor and y factor values change described by the given function in the given duration.
    /// The function is sampled every time the given interval passes with the total time as a parameter.
    /// For example, the duration with a value of 0.5 and the interval with a value of 0.1 yields [0.0, 0.1, 0.2, 0.3, 0.4, 0.5] as parameters which are passed to the sampling function.
    public final class ScaleFunction<Target: UIView>: ReactiveAnimation<Target> {
        private let duration: TimeInterval
        private let interval: TimeInterval
        private let isLinear: Bool
        private let function: (TimeInterval) -> (CGFloat, CGFloat)

        /// Initializes the ScaleFunction object.
        /// - Parameters:
        ///   - duration: The duration of the animation.
        ///   - interval: An interval describing how often the new value should be sampled.
        ///   - isLinear: Describes whether animations should be played with curveLinear option. Defaults to true.
        ///   - function: Function which describes how the properties of this animation change.
        public init(duration: TimeInterval, interval: TimeInterval, isLinear: Bool = true, function: @escaping (TimeInterval) -> (CGFloat, CGFloat)) {
            self.duration = duration
            self.interval = interval
            self.isLinear = isLinear
            self.function = function
        }

        override public func animate(target: Target) -> Observable<Target> {
            target.rx.animate(
                FunctionAnimation(
                    duration: duration,
                    interval: interval,
                    isLinear: isLinear,
                    function: Functions.packToArray(function)
                ) { [unowned self] results in
                    Scale(
                        factorX: results[0],
                        factorY: results[1],
                        duration: self.interval
                    )
                }
            )
        }
    }

    /// A convenience class which describes a translation animation with the x offset and y offset values change described by the given function in the given duration.
    /// The function is sampled every time the given interval passes with the total time as a parameter.
    /// For example, the duration with a value of 0.5 and the interval with a value of 0.1 yields [0.0, 0.1, 0.2, 0.3, 0.4, 0.5] as parameters which are passed to the sampling function.
    public final class TranslateFunction<Target: UIView>: ReactiveAnimation<Target> {
        private let duration: TimeInterval
        private let interval: TimeInterval
        private let isLinear: Bool
        private let function: (TimeInterval) -> (CGFloat, CGFloat)

        /// Initializes the TranslateFunction object.
        /// - Parameters:
        ///   - duration: The duration of the animation.
        ///   - interval: An interval describing how often the new value should be sampled.
        ///   - isLinear: Describes whether animations should be played with curveLinear option. Defaults to true.
        ///   - function: Function which describes how the properties of this animation change.
        public init(duration: TimeInterval, interval: TimeInterval, isLinear: Bool = true, function: @escaping (TimeInterval) -> (CGFloat, CGFloat)) {
            self.duration = duration
            self.interval = interval
            self.isLinear = isLinear
            self.function = function
        }

        override public func animate(target: Target) -> Observable<Target> {
            target.rx.animate(
                FunctionAnimation(
                    duration: duration,
                    interval: interval,
                    isLinear: isLinear,
                    function: Functions.packToArray(function)
                ) { [unowned self] results in
                    Translate(
                        translationX: results[0],
                        translationY: results[1],
                        duration: self.interval
                    )
                }
            )
        }
    }

    /// A convenience class which describes a move animation with the x offset and y offset values change described by the given function in the given duration.
    /// The function is sampled every time the given interval passes with the total time as a parameter.
    /// For example, the duration with a value of 0.5 and the interval with a value of 0.1 yields [0.0, 0.1, 0.2, 0.3, 0.4, 0.5] as parameters which are passed to the sampling function.
    public final class MoveFunction<Target: UIView>: ReactiveAnimation<Target> {
        private let duration: TimeInterval
        private let interval: TimeInterval
        private let isLinear: Bool
        private let function: (TimeInterval) -> (CGFloat, CGFloat)

        /// Initializes the MoveFunction object.
        /// - Parameters:
        ///   - duration: The duration of the animation.
        ///   - interval: An interval describing how often the new value should be sampled.
        ///   - isLinear: Describes whether animations should be played with curveLinear option. Defaults to true.
        ///   - function: Function which describes how the properties of this animation change.
        public init(duration: TimeInterval, interval: TimeInterval, isLinear: Bool = true, function: @escaping (TimeInterval) -> (CGFloat, CGFloat)) {
            self.duration = duration
            self.interval = interval
            self.isLinear = isLinear
            self.function = function
        }

        override public func animate(target: Target) -> Observable<Target> {
            target.rx.animate(
                FunctionAnimation(
                    duration: duration,
                    interval: interval,
                    isLinear: isLinear,
                    function: Functions.packToArray(function)
                ) { [unowned self] results in
                    Move(
                        offsetX: results[0],
                        offsetY: results[1],
                        duration: self.interval
                    )
                }
            )
        }
    }

    // MARK: Property mutators

    /// A convenience class which describes a transformation of the view which sets isHidden property
    /// to the given value.
    public final class SetIsHidden<Target: UIView>: ReactiveAnimation<Target> {
        /// The expected value of the isHidden property.
        private let isHidden: Bool

        /// Initializes the SetIsHidden object.
        /// - Parameters:
        ///   - isHidden: The expected value of the isHidden property.
        public init(to isHidden: Bool) {
            self.isHidden = isHidden
        }

        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(
                ReactiveAnimations.Mutate { [unowned self] animatedView in
                    animatedView.isHidden = self.isHidden
                }
            )
        }
    }

    // MARK: Utility

    /// A convenience class which removes all currently performed animations on the given view.
    public final class RemoveAllAnimations<Target: UIView>: ReactiveAnimation<Target> {
        override public func animate(target: Target) -> Observable<Target> {
            return target.rx.animate(
                ReactiveAnimations.Mutate { animatedView in
                    animatedView.layer.removeAllAnimations()
                }
            )
        }
    }
}
