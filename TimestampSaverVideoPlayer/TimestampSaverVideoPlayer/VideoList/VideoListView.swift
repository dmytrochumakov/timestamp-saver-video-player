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
    let onSelectURL: (URL) -> Void
    let onDeleteURL: (URL) -> Void

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(viewStore.models) { model in
                HStack {
                    Button("\(model.url.lastPathComponent)") {
                        onSelectURL(model.url)
                    }
                    Spacer()
                    Button("delete") {
                        viewStore.send(.onDelete(model.url))
                        onDeleteURL(model.url)
                    }
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

}

#Preview {
    VideoListView.mock
}
