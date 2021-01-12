//
//  ProgressBarViewController.swift
//  ReAnimationExample
//

import UIKit

final class ProgressBarViewController: UIViewController {

    private let progressBarView = ProgressBarView()

    override func loadView() {
        self.view = progressBarView
    }
}

