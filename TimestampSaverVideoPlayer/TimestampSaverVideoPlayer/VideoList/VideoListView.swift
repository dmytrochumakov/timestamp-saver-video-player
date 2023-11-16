//
//  VideoListView.swift
//  TimestampSaverVideoPlayer
//
//  Created Dmytro Chumakov on 16.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct VideoListView: View {
    
    let store: StoreOf<VideoListFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(viewStore.list, id: \.self) { number in
                Text("some, \(number)")
            }
            .onDrop(of: [.fileURL],
                    isTargeted: viewStore.binding(get: \.isTargeted,
                                                  send: { .isTargetedChanged($0) }),
                    perform: { providers in
                guard let provider = providers.first else { return false }
                _ = provider.loadDataRepresentation(for: .fileURL) { data, error in
                    DispatchQueue.main.async {
                        viewStore.send(.onDrop(data))
                    }
                }
                return true
            })
            .overlay {
                if viewStore.isTargeted {
                    dropVideoView
                }
            }
            .animation(.default, value: viewStore.isTargeted)
        }
    }

}

// MARK: - Views
private extension VideoListView {

    var dropVideoView: some View {
        ZStack {
            Color.black.opacity(0.7)
            VStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                Text("Drop your video here...")
            }
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(maxWidth: 250)
            .multilineTextAlignment(.center)
        }
    }

}

#Preview {
    VideoListView.mock
}
