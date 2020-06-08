//
//  SceneDelegate.swift
//  SceneDelegate
//
//  Created by Sungeun Park on 2020/06/07.
//  Copyright © 2020 Sungeun Park. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: UI LifeCycle
    // Enter Foreground
    // Become Active
    
    /*
     UISceneSession의 생명주기에서 가장 먼저 호출되는 방법입니다.
     기본 구현은 초기 컨텐츠뷰 (화면)을 작성하고, 새 UIWinow를 작성합니다.
     window의 rootViewController를 설정하고 이 window를 keywindow로 설정합니다.
     이 window를 사용자가 보는 화면으로 생각할 수 있지만, 아쉽게도 이것은 앱이 작동하는 viewport를 나타냅니다.
     따라서 UISceneSession은 사용자가 볼 수 있는 창을 제어합니다.
     사용자가 만든 UIWindow는 앱의 container view 입니다.
     초기 뷰 설정 이외에도, 과거에 scene의 연결이 끊어진 경우 위 method를 사용하여 UIScene를 복원할 수 있습니다.
     option 객체를 읽어서 handoff 요청으로 인해 Scene이 생성 되었는지, URL을 열 수 있는지 확인 할 수도 있습니다.
     */
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    /*
    Scene이 background로 전송될 때마다 iOS는 리소스를 확보하기 위해 연결을 끊고, Scene을 정리하기로 결정할 수 있다.
    앱이 종료되었거나 더 이상 실행되고 있지않다는 의미는 아님
    단순히 이 method로 전달된 Scene이 더이상 활성화되지 않아 세션에서 연결이 끊어진 것을 의미함
    세션 자체가 반드시 버려지는 것은 아니며, iOS는 사용자가 특정 Scene을 다시 fore ground로 가져올 때와 같이 언제든지 Scene을 UISceneSession에 다시 연결하기로 결정 할 수 있다.
    이 method에서 해야할 가장 중요한 것은 보관할 필요가 없는 자원을 버리는 것입니다.
    */
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
    }
}

