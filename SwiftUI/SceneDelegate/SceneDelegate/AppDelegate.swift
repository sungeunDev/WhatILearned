//
//  AppDelegate.swift
//  SceneDelegate
//
//  Created by Sungeun Park on 2020/06/07.
//  Copyright © 2020 Sungeun Park. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Process LifeCycle
    // App Launched, Terminated
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    //SceneDelegate를 구현한 경우, 아래 메서드도 SceneDelegate에서 처리됨 (아래 메서드 호출되지 않음)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    // Sesstion Created, Discarded
    //scene sessions은 앱에서 생성한 모든 scene의 정보를 관리합니다.

    //scene을 만들 때 구성 객체를 반환해야 합니다.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    //사용자가 app switcher를 통해 scene을 닫을 때 호출됩니다.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

