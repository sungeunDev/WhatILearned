//
//  WordViewReactor.swift
//  Counter
//
//  Created by Ari on 19/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class WordViewReactor: Reactor {
    enum Action {
        case updateQuery(String?)
        case save(CourseWord)
        case delete(CourseWord)
    }
    
    enum Mutation {
        case save(CourseWord)
        case delete(CourseWord)
        case setLoading(Bool)
        case setQuery(String?)
        case setCourseWords([CourseWord])
    }
    
    struct State {
        var query: String?
        var words: [CourseWord] = []
        var myWords: [CourseWord] = []
        var isLoading: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .save(word):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.save(word)),
                Observable.just(Mutation.setLoading(false))
            ])
        case let .delete(word):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.delete(word)),
                Observable.just(Mutation.setLoading(false))
                ])
        case let .updateQuery(query):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.setQuery(query)),
                self.search(query)
                    .map { Mutation.setCourseWords($0) },
                Observable.just(Mutation.setLoading(false))
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .delete(word):
            state.myWords = state.myWords.filter { $0.wd != word.wd }
        case let .save(word):
            state.myWords.append(word)
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setQuery(query):
            state.query = query
        case let .setCourseWords(words):
            state.words = words
        }
        return state
    }
    
    private func search(_ query: String?) -> Observable<[CourseWord]> {
        var courseWords: [CourseWord] = []
        DataService.getCourseWords { courseWords = $0.value ?? []; }
        
        guard let query = query, !query.isEmpty else { return .just(courseWords) }
        return .just(courseWords.filter { $0.wd.hasPrefix(query.lowercased()) })
    }
}

