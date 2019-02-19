//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by sungnni on 2018. 8. 28..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class CitySearcherViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  let allCities = ["NewYork", "London", "Paris", "Osaka", "Osagu", "Seoul"]
  var shownCities = [String]()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar
      .rx.text // RxCocoa의 Observable 속성(ControlProperty<String?>). 검색 바의 텍스트가 변경될 때 신호 발생
      .orEmpty // 옵셔널이 아니게 만듦 (Transforms control property of type String? into control property of type String.)
      .debounce(0.5, scheduler: MainScheduler.instance) // 0.5초 기다림. 안 줄 경우, 모든 입력을 받음. (API의 과도한 호출을 방지)
      .distinctUntilChanged() // 새로운 값이 이전과 같은지 체크 (O -> Oc -> O 값이 이전과 같으므로 다음으로 안넘어감)
      .filter({ !$0.isEmpty })
      .subscribe(onNext: { [unowned self] query in
        print(query)
        self.shownCities = self.allCities.filter({ $0.hasPrefix(query) })
        self.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
}

extension CitySearcherViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shownCities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath) as UITableViewCell
    cell.textLabel?.text = shownCities[indexPath.row]
    return cell
  }
  
}

