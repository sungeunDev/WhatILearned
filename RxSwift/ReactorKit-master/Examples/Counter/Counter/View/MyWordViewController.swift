//
//  MyWordViewController.swift
//  Counter
//
//  Created by Ari on 21/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

class MyWordViewController: UIViewController, StoryboardView {
    @IBOutlet weak var myWordsLabel: UILabel!
    var myWords: Observable<[CourseWord]>?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let myWords = myWords else { return }
        myWords.subscribe({ (word) in
            self.myWordsLabel.text = """
            총 단어 수: \(word.element!.count)개
            단어 리스트: \(word)
"""
        }).disposed(by: disposeBag)
    }
    
    func bind(reactor: MyWordViewReactor) {
    }
    
    @IBAction func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }

}
