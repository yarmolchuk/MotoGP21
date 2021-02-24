//
//  MotoGPRidersAPI.swift
//  MotoGP21-MVVM
//
//  Created by Dima Yarmolchuk on 24.02.2021.
//

import Foundation
import Combine

enum MotoGPRidersAPI {
    private static let agent = Agent()
    
    static func riders() -> AnyPublisher<Riders<Rider>, Error> {
        let request = URLComponents(url: GC.baseUrl, resolvingAgainstBaseURL: true)?.request
        return agent.run(request!)
    }
}

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}
