//
//  VideoListFeature.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import Foundation
import ComposableArchitecture

struct VideoListModel: Hashable, Identifiable, Codable {
    var id: URL {
        url
    }
    let url: URL
}

@Reducer
struct VideoListFeature {

    private let userDefaults: UserDefaults = .standard
    private let key = "VideoListFeatureKey"

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onDrop(url):
                state.models.append(.init(url: url))
                userDefaults.set(try? JSONEncoder().encode(state.models),
                                 forKey: key)
                return .none

            case let .isTargetedChanged(newValue):
                state.isTargeted = newValue
                return .none

            case .onAppear:
                guard
                    let data = userDefaults.data(forKey: key),
                    let models = try? JSONDecoder().decode([VideoListModel].self, from: data)
                else {
                    return .none
                }
                state.models = models
                return .none
            }
        }
    }

    struct State: Equatable {
        var isTargeted = false
        var models: [VideoListModel] = []
    }

    enum Action: Equatable {
        case onDrop(_ url: URL)
        case isTargetedChanged(_ newValue: Bool)
        case onAppear
    }

}
