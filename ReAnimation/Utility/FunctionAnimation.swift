//
//  FunctionAnimation.swift
//  ReAnimation
//

import RxSwift

final class FunctionAnimation<Target: UIView>: ReactiveAnimation<Target> {
    private let duration: TimeInterval
    private let interval: TimeInterval
    private let isLinear: Bool
    private let function: (TimeInterval) -> ([CGFloat])
    private let animationFunction: ([CGFloat]) -> ReactiveAnimation<Target>

    init(
        duration: TimeInterval,
        interval: TimeInterval,
        isLinear: Bool = true,
        function: @escaping (TimeInterval) -> ([CGFloat]),
        animationFunction: @escaping ([CGFloat]) -> ReactiveAnimation<Target>
    ) {
        self.duration = duration
        self.interval = interval
        self.isLinear = isLinear
        self.function = function
        self.animationFunction = animationFunction
    }

    override func animate(target: Target) -> Observable<Target> {
        let animationsCount = Int(duration / interval)
        let shouldAppendStep = duration.remainder(dividingBy: interval) != 0
        return animate(
            target: target,
            step: 0,
            stepMax: animationsCount,
            appendedInterval: shouldAppendStep ? duration : nil
        )
    }

    private func animate(target: Target, step: Int, stepMax: Int, appendedInterval: TimeInterval?) -> Observable<Target> {
        guard step <= stepMax else {
            return appendedInterval.flatMap {
                let results = function($0)
                return target.rx.animate(
                    animationFunction(results)
                    .with(options: isLinear ? (options?.update(with: .curveLinear) ?? .curveLinear) : options)
                )
            } ?? Observable.empty()
        }
        let argument = Double(step) * interval
        let results = function(argument)
        return target.rx.animate(
            animationFunction(results)
            .with(options: isLinear ? (options?.update(with: .curveLinear) ?? .curveLinear) : options)
        ).concatMap { [unowned self] _ in
            self.animate(target: target, step: step + 1, stepMax: stepMax, appendedInterval: appendedInterval)
        }
    }
}
