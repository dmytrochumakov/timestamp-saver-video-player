//
//  ContentView.swift
//  TimestampSaverVideoPlayer
//
//  Created by Dmytro Chumakov on 16.11.2023.
//

import SwiftUI

struct ContentView: View {

    let appStore: AppStore

    var body: some View {
        NavigationSplitView {
            VideoListView(store: appStore.videoListStore)
        } detail: {
            PlayerView(store: appStore.playerStore)
        }
    }

}

#Preview {
    ContentView(appStore: .mock)
}
