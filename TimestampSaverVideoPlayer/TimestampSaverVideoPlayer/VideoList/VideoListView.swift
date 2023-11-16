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
    let didSelectURL: (URL) -> Void

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(viewStore.models) { model in
                Button("\(model.url)") {
                    didSelectURL(model.url)
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
