//
//  Reactor.swift
//  Counter
//
//  Created by Ari on 15/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

class TestReactor: Reactor {
    var initialState: State
    
    enum Action {
        case plus
        case minus
    }
    
    enum Mutation {
        case plusDate
        case minusDate
        case setLoading(Bool)
    }
    
    struct State {
        var value: Date
        var isLoading: Bool
    }
    
    init() {
        self.initialState = State(value: Date(), isLoading: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .plus:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.plusDate).delay(0.3, scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
                ])
        case .minus:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.minusDate).delay(0.3, scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        let timeInterval: Double = 60 * 60 * 24
        switch mutation {
        case .plusDate:
            state.value = state.value.addingTimeInterval(timeInterval)
        case .minusDate:
            state.value = state.value.addingTimeInterval(-timeInterval)
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
