//
//  MotoGP21_MVVMApp.swift
//  MotoGP21-MVVM
//
//  Created by Dima Yarmolchuk on 23.02.2021.
//

import SwiftUI

@main
struct MotoGP21: App {
    var body: some Scene {
        WindowGroup {
            RidersListView(viewModel: RidersListViewModel())
        }
    }
}
