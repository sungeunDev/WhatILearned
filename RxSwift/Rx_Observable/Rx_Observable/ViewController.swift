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
import Alamofire
import RxAlamofire

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar
            .rx.text.asObservable()
            .flatMap({ (query) -> Observable<[String:String]> in
                return self.getRequestObservable(query: query!)
            })
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, model, cell in
                cell.textLabel?.text = model.value
            }
            .disposed(by: bag)
    }
    
    func getRequestObservable(query: String) -> Observable<[String:String]> {
        return Observable<[String:String]>.create { (observer) -> Disposable in
            let url = URL(string: "https://api.github.com/search/users?q=\(query)")!
            let task = URLSession.shared.dataTask(with: url) { data, response, err in
                guard let data = data else { return }
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("url: \(url)")
                if let items = json?["items"] as? [String:String] {
                    observer.onNext(items)
                } else {
                    observer.onNext(["zero":"nothing"])
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
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

