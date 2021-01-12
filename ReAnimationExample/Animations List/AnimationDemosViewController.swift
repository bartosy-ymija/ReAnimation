//
//  AnimationDemosViewController.swift
//  ReAnimationExample
//

import UIKit
import RxSwift
import RxCocoa

class AnimationDemosViewController: UIViewController {

    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private let demos: [AnimationDemo]
    private let cellIdentifier = "AnimationDemo"

    init(demos: [AnimationDemo]) {
        self.demos = demos
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        Observable.just(demos)
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: cellIdentifier,
                    cellType: UITableViewCell.self
                )
            ) {  row, element, cell in
                cell.textLabel?.text = element.title
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(AnimationDemo.self)
            .bind(onNext: show)
            .disposed(by: disposeBag)
    }

    private func show(demo: AnimationDemo) {
        let vc = demo.viewControllerFactory()
        vc.title = demo.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
