//
//  MyWordViewReaction.swift
//  Counter
//
//  Created by Ari on 21/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import Foundation

import RxSwift
import ReactorKit

class MyWordViewReactor: Reactor {
    enum Action {
        case sample
    }
    
    enum Mutation {
        case test
    }
    
    struct State {
        
    }
    
    let initialState = State()
    
    func mutation(action: Action) -> Observable<Mutation> {
        return .just(Mutation.test)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return State()
    }
}
