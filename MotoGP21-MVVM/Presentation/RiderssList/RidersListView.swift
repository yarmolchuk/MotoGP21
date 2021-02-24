//
//  RidersListView.swift
//  MotoGP21-MVVM
//
//  Created by Dima Yarmolchuk on 24.02.2021.
//

import Combine
import SwiftUI

struct RidersListView: View {
    @ObservedObject var viewModel: RidersListViewModel
        
    var body: some View {
        NavigationView {
            content.navigationBarTitle("MotoGP 2021")
        }
        .onAppear {
            viewModel.send(event: .onAppear)
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let riders):
            return list(of: riders).eraseToAnyView()
        }
    }
    
    private func list(of riders: [RidersListViewModel.ListItem]) -> some View {
        return List(riders) { rider in
            NavigationLink(
                destination: details(rider: rider.name),
                label: { RiderListItemView(rider: rider) }
            )
        }
    }
    
    func details(rider: String) -> some View {
        return Text(rider)
    }
}

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
