//
//  SnapshotView.swift
//  ReAnimationTests
//

import UIKit

final class SnapshotView: UIView {

    private(set) var tagSnapshots = [Int]()
    private(set) var centerSnapshots = [CGPoint]()
    private(set) var transformSnapshots = [CGAffineTransform]()
    private(set) var alphaSnapshots = [Double]()

    override var tag: Int {
        didSet {
            tagSnapshots.append(tag)
        }
    }

    override var center: CGPoint {
        didSet {
            centerSnapshots.append(center)
        }
    }

    override var transform: CGAffineTransform {
        didSet {
            transformSnapshots.append(transform)
        }
    }

    override var alpha: CGFloat {
        didSet {
            alphaSnapshots.append(Double(alpha))
        }
    }
}
