//
//  PlayerViewMock.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import Foundation

extension PlayerView {

    static var mock: Self {
        .init(store: .init(initialState: .mock) {
            PlayerFeature()._printChanges()
        })
    }

}
