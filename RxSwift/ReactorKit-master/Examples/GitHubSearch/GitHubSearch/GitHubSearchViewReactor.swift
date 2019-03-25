//
//  GitHubSearchViewReactor.swift
//  GitHubSearch
//
//  Created by Suyeol Jeon on 13/05/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class GitHubSearchViewReactor: Reactor {
  enum Action {
    case updateQuery(String?)
    case loadNextPage
  }

  enum Mutation {
    case setQuery(String?)
    case setRepos([String], nextPage: Int?)
    case appendRepos([String], nextPage: Int?)
    case setLoadingNextPage(Bool)
  }

  struct State {
    var query: String?
    var repos: [String] = []
    var nextPage: Int?
    var isLoadingNextPage: Bool = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
//    print("----------------< action: \(action) >----------------")
    switch action {
    case let .updateQuery(query):
      return Observable.concat([
        // 1) set current state's query (.setQuery)
        Observable.just(Mutation.setQuery(query)),

        // 2) call API and set repos (.setRepos)
        self.search(query: query, page: 1)
          // cancel previous request when the new `.updateQuery` action is fired
          .takeUntil(self.action.filter(isUpdateQueryAction))
          .map { Mutation.setRepos($0, nextPage: $1) },
      ])

    case .loadNextPage:
      guard !self.currentState.isLoadingNextPage else { return Observable.empty() } // prevent from multiple requests
      guard let page = self.currentState.nextPage else { return Observable.empty() }
      return Observable.concat([
        // 1) set loading status to true
        Observable.just(Mutation.setLoadingNextPage(true)),

        // 2) call API and append repos
        self.search(query: self.currentState.query, page: page)
          .takeUntil(self.action.filter(isUpdateQueryAction))
          .map { Mutation.appendRepos($0, nextPage: $1) },

        // 3) set loading status to false
        Observable.just(Mutation.setLoadingNextPage(false)),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
//    print("----------------< reduce: \(state), \(mutation) >----------------")
    switch mutation {
    case let .setQuery(query):
      var newState = state
      newState.query = query
      return newState

    case let .setRepos(repos, nextPage):
      var newState = state
      newState.repos = repos
      newState.nextPage = nextPage
      return newState

    case let .appendRepos(repos, nextPage):
      var newState = state
      newState.repos.append(contentsOf: repos)
      newState.nextPage = nextPage
      return newState

    case let .setLoadingNextPage(isLoadingNextPage):
      var newState = state
      newState.isLoadingNextPage = isLoadingNextPage
      return newState
    }
  }

  private func url(for query: String?, page: Int) -> URL? {
    guard let query = query, !query.isEmpty else { return nil }
    return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
  }
    
    private func request(for query: String?, page: Int) -> URLRequest? {
        guard let query = query, !query.isEmpty else { return nil }
//        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
        let url = URL(string: "https://gitlab.com/api/v4/projects/8452367/repository/tree")
        
        
        var request = URLRequest(url: url!)
        let mytoken = "vQGoqT2vTmTHDuxY8PmX"
        request.addValue("\(mytoken)", forHTTPHeaderField: "PRIVATE-TOKEN")
        return request
    }

  private func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
    let emptyResult: ([String], Int?) = ([], nil)
    guard let request = self.request(for: query, page: page) else { return .just(emptyResult) }
    return URLSession.shared.rx.json(request: request)
      .map { json -> ([String], Int?) in
//        print(json)
        guard let dict = json as? [[String: Any]] else { return emptyResult }
        print(dict)
//        guard let items = dict["items"] as? [[String: Any]] else { return emptyResult }
        let repos = dict.compactMap { $0["name"] as? String }
        let nextPage = repos.isEmpty ? nil : page + 1
        return (repos, nextPage)
      }
      .do(onError: { error in
        if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
          print("⚠️ GitHub API rate limit exceeded. Wait for 60 seconds and try again.")
        }
      })
      .catchErrorJustReturn(emptyResult)
  }

  private func isUpdateQueryAction(_ action: Action) -> Bool {
    if case .updateQuery = action {
      return true
    } else {
      return false
    }
  }
}
