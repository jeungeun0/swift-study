//
//  AppDelegate.swift
//  StudyLogin
//
//  Created by app on 2022/05/16.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        settingNaverSNSLogin()
        settingKakaoSNSLogin()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var result: Bool = true
        openUrlHandlerOfNaver(app, open: url, options: options)
        result = openUrlHandlerOfKakao(result: result, open: url)
        
        return result
    }

}


//MARK: - SNS Login
extension AppDelegate {
    /// 네이버 로그인 셋팅
    func settingNaverSNSLogin() {
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        //네이버 앱으로 인증하는 방식 활성화
        instance?.isNaverAppOauthEnable = true
        //SafariViewController에서 인증하는 방식 활성화
        instance?.isInAppOauthEnable = true
        //인증 화면을 아이폰의 세로모드에서만 적용
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
    }
    
    /// 카카오 로그인 셋팅
    func settingKakaoSNSLogin() {
        //카카오 SDK 초기화 코드
        KakaoSDK.initSDK(appKey: "5d15b24375a895bb31c4e7950ef1ea92")
    }
    
    func openUrlHandlerOfNaver(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }
    
    func openUrlHandlerOfKakao(result: Bool, open url: URL) -> Bool {
        
        if AuthApi.isKakaoTalkLoginUrl(url) {
            if AuthController.handleOpenUrl(url: url) {
                return true
            }
        }
        
        return result
    }
}
