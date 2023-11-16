//
//  TimestampSaverVideoPlayerApp.swift
//  TimestampSaverVideoPlayer
//
//  Created by Dmytro Chumakov on 16.11.2023.
//

import SwiftUI

@main
struct TimestampSaverVideoPlayerApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(appStore: .init())
        }
    }

}
