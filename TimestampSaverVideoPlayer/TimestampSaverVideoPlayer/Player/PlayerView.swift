//
//  PlayerView.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import SwiftUI
import ComposableArchitecture
import AVKit

struct PlayerView: View {

    let store: StoreOf<PlayerFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                if viewStore.player != nil {
                    VideoPlayer(player: viewStore.player)
                }
                Button {
                    viewStore.send(.buttonTapped)
                } label: {
                    Image(systemName: viewStore.isPlaying ? "stop" : "play")
                        .padding()
                }
            }
        }
    }

}

#Preview {
    PlayerView.mock
}
