//
//  RidersListViewModel.swift
//  MotoGP21-MVVM
//
//  Created by Dima Yarmolchuk on 24.02.2021.
//

import Foundation
import Combine

final class RidersListViewModel: ObservableObject, Hashable {
    @Published private(set) var state = State.idle
    
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
    
    static func == (lhs: RidersListViewModel, rhs: RidersListViewModel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}

// MARK: - Inner Types

extension RidersListViewModel {
    enum State {
        case idle
        case loading
        case loaded([ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectRider(String)
        case onRidersLoaded([ListItem])
        case onFailedToLoadRiders(Error)
    }
    
    struct ListItem: Identifiable {
        let id: Int
        let name: String
        let photo: URL?
        
        init(rider: Rider) {
            id = rider.name.hashValue
            name = rider.name
            photo = rider.poster
        }
    }
}

// MARK: - State Machine

extension RidersListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadRiders(let error):
                return .error(error)
            case .onRidersLoaded(let riders):
                return .loaded(riders)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return MotoGPRidersAPI.riders()
                .map { $0.riders.map(ListItem.init) }
                .map(Event.onRidersLoaded)
                .catch { Just(Event.onFailedToLoadRiders($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

