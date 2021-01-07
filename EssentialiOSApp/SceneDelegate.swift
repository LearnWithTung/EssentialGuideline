//
//  SceneDelegate.swift
//  EssentialiOSApp
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import UIKit
import EssentialFeature
import MVC
import EssentialGuidelineiOS
import SDWebImage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let url = URL(string: "https://reqres.in/api/users")!
    let client = URLSessionHTTPClient(session: .shared)
    lazy var feedLoader = RemoteFeedLoader(url: url, client: client)
    let feedImageLoader = FeedImageDataLoaderWithSDWebImage()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = makeRootViewController()
    }
    
    private func makeRootViewController() -> UIViewController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [massive(), mvc()]
        return tabBar
    }
    
    private func massive() -> UIViewController {
        let view = EssentialGuidelineiOS.FeedUIComposer.composeWith(feedLoader: feedLoader, imageLoader: feedImageLoader)
        view.tabBarItem.title = "Massive"
        return view
    }
    
    private func mvc() -> UIViewController {
        let view = MVC.FeedUIComposer.composeWith(feedLoader: feedLoader, imageLoader: feedImageLoader)
        view.tabBarItem.title = "MVC"
        return view
    }

}

class FeedImageDataLoaderWithSDWebImage : FeedImageDataLoader{
    private let manager = SDWebImageManager()

    public init() {}

    public func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let manger = SDWebImageManager()
        manger.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, error, _, _, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(image?.pngData() ?? Data()))
            }
        }
    }
}
