//
//  PlayerFeature.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import ComposableArchitecture
import AVKit

struct PlayerModel: Codable, Hashable {
    let url: URL
    let time: CMTime
}

@Reducer
struct PlayerFeature {

    private let key: String = "PlayerFeatureKey"
    private let userDefaults: UserDefaults = .standard

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .buttonTapped:
                if state.isPlaying {
                    state.player?.pause()
                    state.isPlaying = false
                    if
                        let url = state.url,
                        let currentTime = state.player?.currentTime()
                    {
                        var models = retrievePlayerModels()
                        models.append(.init(url: url, time: currentTime))
                        userDefaults.setValue(try? JSONEncoder().encode(models), forKey: key)
                    }
                } else {
                    state.player?.play()
                    state.isPlaying = true
                }
                return .none

            case .onDrop(let url):
                setURLAndPlayer(url, &state)
                return .none

            case .onSelect(let url):
                let playerModel = retrievePlayerModels().first(where: { $0.url == url })
                setURLAndPlayer(url, &state)
                if playerModel?.url == url {
                    state.player?.seek(to: playerModel!.time)
                }
                return .none
            }
        }
    }

    struct State: Equatable {
        var player: AVPlayer? = nil
        var isPlaying: Bool = false
        var url: URL? = nil
    }

    enum Action: Equatable {
        case buttonTapped
        case onDrop(_ url: URL)
        case onSelect(_ url: URL)
    }

    private func setURL(_ url: URL, _ state: inout State) {
        state.url = url
    }

    private func setPlayer(_ player: AVPlayer, _ state: inout State) {
        state.player = player
    }

    private func setURLAndPlayer(_ url: URL, _ state: inout State) {
        setURL(url, &state)
        setPlayer(AVPlayer(url: url), &state)
    }

    private func retrievePlayerModels() -> [PlayerModel] {
        guard
            let data = userDefaults.data(forKey: key),
            let playerModels = try? JSONDecoder().decode([PlayerModel].self, from: data)
        else {
            return []
        }
        return playerModels
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
