//
//  WordsViewController.swift
//  Counter
//
//  Created by Ari on 21/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class WordsViewController: UIViewController, StoryboardView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet weak var goToMyWordBtn: UIButton!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bind(reactor: WordViewReactor) {
        // Action
        searchbar.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { return Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected
            .map({ indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as! WordCell
                return Reactor.Action.save(cell.word!)
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.words }
            .bind(to: tableView.rx.items(cellIdentifier: "WordCell", cellType: WordCell.self)) { indexPath, words, cell in
                let mean = words.mn.reduce("", { $0 + $1 + ", " }).dropLast(2)
                cell.textLabel?.text = "\(words.wd) - \(mean)"
                cell.word = words
            }
            .disposed(by: disposeBag)        
        
        goToMyWordBtn.rx.tap
            .throttle(1, latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { (_) in
                if let myWordVC = self.storyboard?.instantiateViewController(withIdentifier: "MyWordViewController") as? MyWordViewController {
                    
                    myWordVC.reactor = MyWordViewReactor()
                    let myWords = reactor.state.map { $0.myWords }
                    myWordVC.myWords = myWords
                    self.present(myWordVC, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}


