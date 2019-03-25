//
//  GitLabSearchViewReactor.swift
//  GitHubSearch
//
//  Created by Ari on 20/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

final class GitLabSearchViewReactor: Reactor {
    enum Action {
        case updateQuery(String?)
    }
    
    enum Mutation {
        case setQuery(String?)
        case setFiles([String])
        case setLoading(Bool)
    }
    
    struct State {
        var query: String?
        var files: [String] = []
        var isLoading: Bool = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.setQuery(query)),                
                self.search(query: query)
                    .map { Mutation.setFiles($0) }
                    .delay(0.5, scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        print("----------------< reduce: \(state), mutation: \(mutation) >----------------")
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
            
        case let .setFiles(files):
            var newState = state
            newState.files = files
            return newState
            
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            return newState
        }
    }
    
    private func request(for query: String?) -> URLRequest? {
        guard let query = query, !query.isEmpty,
            let url = URL(string: "https://gitlab.com/api/v4/projects/\(query)/repository/tree") else { return nil }
        var request = URLRequest(url: url)
        request.addValue("vQGoqT2vTmTHDuxY8PmX", forHTTPHeaderField: "PRIVATE-TOKEN")
        return request
    }
    
    private func search(query: String?) -> Observable<[String]> {
        let emptyResult: [String] = []
        guard let request = self.request(for: query) else { return .just(emptyResult) }
        return URLSession.shared.rx.json(request: request)
            .map { json -> [String] in
                guard let dictList = json as? [[String: Any]] else { return emptyResult }
                let files = dictList.compactMap { $0["name"] as? String }
                return files
        }
            .do(onError: { error in
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError,
                    response.statusCode == 403 { print("error") }
            })
            .catchErrorJustReturn(emptyResult)
    }
}
