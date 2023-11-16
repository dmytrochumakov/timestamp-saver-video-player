//
//  ContentView.swift
//  TimestampSaverVideoPlayer
//
//  Created by Dmytro Chumakov on 16.11.2023.
//

import SwiftUI

struct ContentView: View {

    @State private var isTargeted: Bool = false

    let appStore: AppStore

    var body: some View {
        NavigationSplitView {
            VideoListView(store: appStore.videoListStore,
                          didSelectURL: { appStore.playerStore.send(.onSelect($0)) })
        } detail: {
            PlayerView(store: appStore.playerStore)
        }
        .onDrop(of: [.fileURL],
                isTargeted: $isTargeted,
                perform: { providers in
            guard let provider = providers.first else { return false }
            _ = provider.loadDataRepresentation(for: .fileURL) { data, _ in
                guard
                    let url = dataToURL(data)
                else {
                    return
                }
                DispatchQueue.main.async {
                    appStore.videoListStore.send(.onDrop(url))
                    appStore.playerStore.send(.onDrop(url))
                }
            }
            return true
        })
        .overlay {
            if isTargeted {
                dropVideoView
            }
        }
        .animation(.default, value: isTargeted)
    }

}

// MARK: - Views
private extension ContentView {

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

private extension ContentView {

    func dataToURL(_ data: Data?) -> URL? {
        guard
            let data,
            let encodedString = String(data: data, encoding: .utf8),
            let url = URL(string: encodedString)
        else {
            return .none
        }
        return url
    }

}

#Preview {
    ContentView(appStore: .mock)
}
