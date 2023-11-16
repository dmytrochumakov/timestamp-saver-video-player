//
//  PlayerFeature.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import ComposableArchitecture
import AVKit

@Reducer
struct PlayerFeature {

    private let key: String = "currentTimeKey"
    private let userDefaults: UserDefaults = .standard

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .buttonTapped:
                if state.isPlaying {
                    state.player?.pause()
                    state.isPlaying = false
                    let value = try? JSONEncoder().encode(state.player?.currentTime())
                    userDefaults.setValue(value, forKey: key)
                } else {
                    state.player?.play()
                    state.isPlaying = true
                }
                return .none

            case .onAppear:
                guard
                    let data = userDefaults.data(forKey: key),
                    let time = try? JSONDecoder().decode(CMTime.self, from: data)
                else {
                    return .none
                }
                state.player?.seek(to: time)
                return .none

            }
        }
    }

    struct State: Equatable {
        var player: AVPlayer? = nil
        var isPlaying: Bool = false
    }

    enum Action: Equatable {
        case buttonTapped
        case onAppear
    }

}

extension CMTime: Codable {

    enum CodingKeys: CodingKey {
        case value
        case timescale
        case flags
        case epoch
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        self.value = try container.decode(CMTimeValue.self, forKey: .value)
        self.timescale = try container.decode(CMTimeScale.self, forKey: .timescale)
        self.flags = try container.decode(CMTimeFlags.self, forKey: .flags)
        self.epoch = try container.decode(CMTimeEpoch.self, forKey: .epoch)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(timescale, forKey: .timescale)
        try container.encode(flags, forKey: .flags)
        try container.encode(epoch, forKey: .epoch)
    }
}

extension CMTimeFlags: Codable {

}
