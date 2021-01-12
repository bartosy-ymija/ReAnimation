//
//  PulsingCirclesViewController.swift
//  ReAnimationExample
//

import UIKit

final class PulsingCirclesViewController: UIViewController {

    private let circlesView = PulsingCirclesView()

    override func loadView() {
        self.view = circlesView
    }
}

