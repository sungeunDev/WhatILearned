//
//  ViewController.swift
//  Rx_Observable
//
//  Created by Ari on 04/03/2019.
//  Copyright © 2019 ssungnni. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let searchText = searchBar
            .rx.text
            .map { "\($0!)A" }
            .subscribe(onNext: { print($0!) })
            .disposed(by: bag)
        
        
        getRequestObservable(query: "test")
            .subscribe(onNext: { print($0) })
            .disposed(by: bag)
        
    }
    
    func getRequestObservable(query: String) -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            let url = URL(string: "https://api.github.com/search/users?q=\(query)")!
            let task = URLSession.shared.dataTask(with: url) { data, response, err in
                guard let data = data else { return }
                guard let json = String(data: data, encoding: .utf8) else {
                    observer.onError(err!)
                    return
                }
                observer.onNext(json)
            }
            task.resume()
            return Disposables.create()
        }
    }
    
    func test() {
        let numbers = Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            return Disposables.create()
        }.debug()
        
        numbers.subscribe { (event) in
            print(event)
        }.disposed(by: bag)
    }
    
    


}

