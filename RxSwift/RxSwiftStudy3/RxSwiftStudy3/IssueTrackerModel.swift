//
//  IssueTrackerModel.swift
//  RxSwiftStudy3
//
//  Created by Ari on 19/02/2019.
//  Copyright © 2019 ssungnni. All rights reserved.
//

import Foundation

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
    
    let provider: RxMoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                print("Name: \(name)")
                return self
                    .findRepository(name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository)
            }
            .replaceNilWith([])
    }
    
    internal func findIssues(_ repository: Repository) -> Observable<[Issue]?> {
        return self.provider
            .request(GitHub.issues(repositoryFullName: repository.fullName))
            .debug()
            .mapArrayOptional(type: Issue.self)
    }
    
    internal func findRepository(_ name: String) -> Observable<Repository?> {
        return self.provider
            .request(GitHub.repo(fullName: name))
            .debug()
            .mapObjectOptional(type: Repository.self)
    }
}
