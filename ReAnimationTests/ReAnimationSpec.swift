//
//  ReAnimationSpec.swift
//  ReAnimationTests
//

import Quick
import Nimble
import RxSwift
import RxRelay
@testable import ReAnimation

class ReAnimationSpec: QuickSpec {

    private let expectedView = BehaviorRelay<SnapshotView?>(value: nil)

    override func spec() {
        describe("animating view") {
            var view = SnapshotView()
            var disposeBag = DisposeBag()
            let expectedTag = 42
            beforeEach { [unowned self] in
                view = SnapshotView()
                self.expectedView.accept(view)
                disposeBag = DisposeBag()
            }
            context("using no animation") {
                it("should return the view unchanged") {
                    view.rx.animate()
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value).toEventually(equal(view))
                }
            }
            context("using base animation class") {
                it("should not change the view contents") {
                    view.rx.animate(ReactiveAnimation())
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value).toEventually(equal(view))
                }
            }
            context("using single animation") {
                it("should apply the animation to the view") {
                    view.rx.animate(SetTag(to: expectedTag))
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tag).toEventually(equal(expectedTag))
                }
            }
            context("using several animations") {
                it("should apply all of them") {
                    view.rx.animate(
                        SetTag(to: expectedTag),
                        ReactiveAnimations.SetIsHidden(to: true)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tag).toEventually(equal(expectedTag))
                    expect(self.expectedView.value?.isHidden).toEventually(equal(true))
                }
                it("should apply them in order") {
                    view.rx.animate(
                        SetTag(to: expectedTag - 1),
                        SetTag(to: expectedTag)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tagSnapshots).toEventually(equal([expectedTag - 1, expectedTag]))
                }
            }
            context("simultanouesly with other view") {
                it("should apply all of the animations using explicit function name") {
                    view.rx.animate(
                        SetTag(to: expectedTag)
                            .simultaneously(with: ReactiveAnimations.SetIsHidden(to: true))
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tag).toEventually(equal(expectedTag))
                    expect(self.expectedView.value?.isHidden).toEventually(equal(true))
                }
                it("should apply all of the animations using infix operator") {
                    view.rx.animate(
                        SetTag(to: expectedTag) & ReactiveAnimations.SetIsHidden(to: true)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tag).toEventually(equal(expectedTag))
                    expect(self.expectedView.value?.isHidden).toEventually(equal(true))
                }
            }
            context("followed by another animation") {
                it("should apply all of the animations using explicit method name") {
                    view.rx.animate(
                        SetTag(to: expectedTag)
                            .followed(by: ReactiveAnimations.SetIsHidden(to: true))
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tag).toEventually(equal(expectedTag))
                    expect(self.expectedView.value?.isHidden).toEventually(equal(true))
                }
                it("should apply all of the animations using infix operator") {
                    view.rx.animate(
                        SetTag(to: expectedTag) + ReactiveAnimations.SetIsHidden(to: true)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tag).toEventually(equal(expectedTag))
                    expect(self.expectedView.value?.isHidden).toEventually(equal(true))
                }
            }
            context("with a delay") {
                let delay: RxTimeInterval = .milliseconds(50)
                it("should perform animation after the delay") {
                    view.rx.animate(
                        SetTag(to: expectedTag).delayed(by: delay)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    expect(self.expectedView.value?.tag).toNotEventually(equal(expectedTag), timeout: 0.04, pollInterval: 0.02)
                    expect(self.expectedView.value?.tag).toEventually(equal(expectedTag), timeout: 0.06, pollInterval: 0.02)
                }
            }
            // MARK: Basic animations
            context("using move animation") {
                it("should change center of the view") {
                    view.rx.animate(
                        ReactiveAnimations.Move(offsetX: 0.2, offsetY: 0.2, duration: 0.01)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedValue: CGPoint = CGPoint(x: 0.2, y: 0.2)
                    expect(self.expectedView.value?.center).toEventually(equal(expectedValue))
                }
            }
            context("using scale animation") {
                it("should change scale transform of the view") {
                    view.rx.animate(
                        ReactiveAnimations.Scale(factorX: 0.2, factorY: 0.2, duration: 0.01)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedValue: CGAffineTransform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                    expect(self.expectedView.value?.transform).toEventually(equal(expectedValue))
                }
            }
            context("using alpha animation") {
                it("should change alpha of the view") {
                    view.rx.animate(
                        ReactiveAnimations.Alpha(0.2, duration: 0.01)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedValue = 0.2
                    expect(self.expectedView.value.flatMap { Double($0.alpha) }).toEventually(beCloseTo(expectedValue))
                }
            }
            context("using translate animation") {
                it("should change translation transform of the view") {
                    view.rx.animate(
                        ReactiveAnimations.Translate(translationX: 0.2, translationY: 0.2, duration: 0.01)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedValue: CGAffineTransform = CGAffineTransform(translationX: 0.2, y: 0.2)
                    expect(self.expectedView.value?.transform).toEventually(equal(expectedValue))
                }
            }
            context("using rotate animation") {
                it("should change rotation transform of the view") {
                    view.rx.animate(
                        ReactiveAnimations.Rotate(angle: 0.2, duration: 0.01)
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedValue: CGAffineTransform = CGAffineTransform(rotationAngle: 0.2)
                    expect(self.expectedView.value?.transform).toEventually(equal(expectedValue))
                }
            }
            // MARK: Function animations
            context("using move function animation") {
                it("should perform all animations in order") {
                    view.rx.animate(
                        ReactiveAnimations.MoveFunction(duration: 0.02, interval: 0.01, function: { (CGFloat($0), CGFloat($0)) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGPoint] = [0, 0.01, 0.03].map { CGPoint(x: $0, y: $0) }
                    expect(self.expectedView.value?.centerSnapshots).toEventually(equal(expectedSnapshots))
                }
                it("should add one animation at duration point in case of partial interval") {
                    view.rx.animate(
                        ReactiveAnimations.MoveFunction(duration: 0.1, interval: 0.03, function: { (CGFloat($0), CGFloat($0)) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGPoint] = [0, 0.03, 0.09, 0.18, 0.28].map { CGPoint(x: $0, y: $0) }
                    expect(self.expectedView.value?.centerSnapshots).toEventually(equal(expectedSnapshots))
                }
            }
            context("using scale function animation") {
                it("should perform all animations in order") {
                    view.rx.animate(
                        ReactiveAnimations.ScaleFunction(duration: 0.02, interval: 0.01, function: { (CGFloat($0), CGFloat($0)) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGAffineTransform] = [0, 0.01, 0.02].map { CGAffineTransform(scaleX: $0, y: $0) }
                    expect(self.expectedView.value?.transformSnapshots).toEventually(equal(expectedSnapshots))
                }
                it("should add one animation at duration point in case of partial interval") {
                    view.rx.animate(
                        ReactiveAnimations.ScaleFunction(duration: 0.1, interval: 0.03, function: { (CGFloat($0), CGFloat($0)) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGAffineTransform] = [0, 0.03, 0.06, 0.09, 0.1].map { CGAffineTransform(scaleX: $0, y: $0) }
                    expect(self.expectedView.value?.transformSnapshots).toEventually(equal(expectedSnapshots))
                }
            }
            context("using alpha function animation") {
                it("should perform all animations in order") {
                    view.rx.animate(
                        ReactiveAnimations.AlphaFunction(duration: 0.02, interval: 0.01, function: { CGFloat($0) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots = [0, 0.01, 0.02]
                    expect(self.expectedView.value?.alphaSnapshots).toEventually(beCloseTo(expectedSnapshots))
                }
                it("should add one animation at duration point in case of partial interval") {
                    view.rx.animate(
                        ReactiveAnimations.AlphaFunction(duration: 0.1, interval: 0.03, function: { CGFloat($0) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [Double] = [0, 0.03, 0.06, 0.09, 0.1]
                    expect(self.expectedView.value?.alphaSnapshots).toEventually(beCloseTo(expectedSnapshots))
                }
            }
            context("using translate function animation") {
                it("should perform all animations in order") {
                    view.rx.animate(
                        ReactiveAnimations.TranslateFunction(duration: 0.02, interval: 0.01, function: { (CGFloat($0), CGFloat($0)) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGAffineTransform] = [0, 0.01, 0.02].map { CGAffineTransform(translationX: $0, y: $0) }
                    expect(self.expectedView.value?.transformSnapshots).toEventually(equal(expectedSnapshots))
                }
                it("should add one animation at duration point in case of partial interval") {
                    view.rx.animate(
                        ReactiveAnimations.TranslateFunction(duration: 0.1, interval: 0.03, function: { (CGFloat($0), CGFloat($0)) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGAffineTransform] = [0, 0.03, 0.06, 0.09, 0.1].map { CGAffineTransform(translationX: $0, y: $0) }
                    expect(self.expectedView.value?.transformSnapshots).toEventually(equal(expectedSnapshots))
                }
            }
            context("using rotate function animation") {
                it("should perform all animations in order") {
                    view.rx.animate(
                        ReactiveAnimations.RotateFunction(duration: 0.02, interval: 0.01, function: { CGFloat($0) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGAffineTransform] = [0, 0.01, 0.02].map { CGAffineTransform(rotationAngle: $0) }
                    expect(self.expectedView.value?.transformSnapshots).toEventually(equal(expectedSnapshots))
                }
                it("should add one animation at duration point in case of partial interval") {
                    view.rx.animate(
                        ReactiveAnimations.RotateFunction(duration: 0.1, interval: 0.03, function: { CGFloat($0) })
                    )
                        .bind(to: self.expectedView)
                        .disposed(by: disposeBag)
                    let expectedSnapshots: [CGAffineTransform] = [0, 0.03, 0.06, 0.09, 0.1].map { CGAffineTransform(rotationAngle: $0) }
                    expect(self.expectedView.value?.transformSnapshots).toEventually(equal(expectedSnapshots))
                }
            }
        }
    }

}
