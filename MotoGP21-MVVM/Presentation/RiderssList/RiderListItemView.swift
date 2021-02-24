//
//  RiderListItemView.swift
//  MotoGP21-MVVM
//
//  Created by Dima Yarmolchuk on 24.02.2021.
//

import Combine
import SwiftUI

struct RiderListItemView: View {
    @Environment(\.imageCache) var cache: ImageCache

    let rider: RidersListViewModel.ListItem
    var body: some View {
        VStack {
            name
            poster
        }
    }
    
    private var name: some View {
        Text(rider.name)
            .font(.title)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
    
    private var poster: some View {
        rider.photo.map { url in
            AsyncImage(
                url: url,
                cache: cache,
                placeholder: spinner,
                configuration: { $0.resizable().renderingMode(.original) }
            )
        }
        .aspectRatio(contentMode: .fit)
        .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3)
    }
    
    private var spinner: some View {
        Spinner(isAnimating: true, style: .medium)
    }
}
