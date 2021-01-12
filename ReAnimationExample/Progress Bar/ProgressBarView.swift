//
//  ProgressBarView.swift
//  ReAnimationExample
//

import UIKit
import RxSwift
import ReAnimation
import RxRelay

final class ProgressBarView: UIView {

    private let progressBar = with(ProgressBar()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    static let offset = CGFloat(80)

    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(progressBar)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
