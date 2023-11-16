//
//  VideoListViewMock.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import Foundation

extension VideoListView {

    static var mock: Self {
        .init(store: .init(initialState: .mock) {
            VideoListFeature()._printChanges()
        }, onSelectURL: { _ in }, onDeleteURL: { _ in })
    }

}
