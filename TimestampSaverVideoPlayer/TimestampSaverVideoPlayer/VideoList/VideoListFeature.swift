//
//  VideoListFeature.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct VideoListFeature {

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onDrop(data):
                guard
                    let data,
                    let encodedString = String(data: data, encoding: .utf8),
                    let url = URL(string: encodedString)
                else {
                    return .none
                }
                state.list.append(url)
                return .none

            case let .isTargetedChanged(newValue):
                state.isTargeted = newValue
                return .none
            }
        }
    }

    struct State: Equatable {
        var isTargeted = false
        var list: [URL] = []
    }

    enum Action: Equatable {
        case onDrop(_ data: Data?)
        case isTargetedChanged(_ newValue: Bool)
    }

}
