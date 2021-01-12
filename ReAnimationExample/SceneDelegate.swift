//
//  SceneDelegate.swift
//  ReAnimationExample
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = scene
        window?.rootViewController = UINavigationController(
            rootViewController: AnimationDemosViewController(demos: [
                AnimationDemo(title: "Progress Bar", viewControllerFactory: { ProgressBarViewController() }),
                                                                AnimationDemo(title: "Pulsing Circles", viewControllerFactory: { PulsingCirclesViewController() }),
                AnimationDemo(title: "Rocking Horse", viewControllerFactory: { RockingHorseViewController() })
            ])
        )
        window?.makeKeyAndVisible()
    }
}

