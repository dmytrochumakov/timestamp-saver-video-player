//
//  AppStore.swift
//  TimestampSaverVideoPlayer
//
//  Created by Dmytro Chumakov on 16.11.2023.
//

import ComposableArchitecture

struct AppStore {

    let videoListStore: StoreOf<VideoListFeature>
    let playerStore: StoreOf<PlayerFeature>

    init(
        videoListStore: StoreOf<VideoListFeature>,
        playerStore: StoreOf<PlayerFeature>
    )
    {
        self.videoListStore = videoListStore
        self.playerStore = playerStore
    }

    init() {
        self.videoListStore = Store(initialState: VideoListFeature.State()) {
            VideoListFeature()._printChanges()
        }
        self.playerStore = Store(initialState: PlayerFeature.State()) {
            PlayerFeature()._printChanges()
        }
    }

}

extension AppStore {

    static var mock: Self {
        .init(videoListStore: Store(initialState: VideoListFeature.State.mock) {
            VideoListFeature()._printChanges()
        },
              playerStore: Store(initialState: PlayerFeature.State.mock) {
            PlayerFeature()._printChanges()
        })
    }

}
