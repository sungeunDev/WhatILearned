- RxSwift를 공부하며 [pilgwon님](https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html)이 번역하신 예제를 따라해 보고 제가 알아보기 쉽도록 정리해둔 글입니다.

## ㅁ 예제 1
- City Searcher 만들기
- 도시 이름을 입력하면 동적으로 도시 목록을 보여줌.

## ㅁ Code

### ㅇ UI
``` swift
@IBOutlet weak var tableView: UITableView!
@IBOutlet weak var searchBar: UISearchBar!

let allCities = ["NewYork", "London", "Paris", "Osaka", "Osagu", "Seoul"]
var shownCities = [String]()

override func viewDidLoad() {
  super.viewDidLoad()
  tableView.dataSource = self
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return shownCities.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
  cell.textLabel?.text = shownCities[indexPath.row]

  return cell
}
```

### ㅇ Observable
``` swift

let disposeBag = DisposeBag()

override func viewDidLoad() {
  super.viewDidLoad()
  tableView.dataSource = self

  searchBar
    .rx.text // RxCocoa의 Observable 속성(ControlProperty<String?>). 검색 바의 텍스트가 변경될 때 신호 발생
    .orEmpty // 옵셔널이 아니게 만듦 (Transforms control property of type String? into control property of type String.)
    .subscribe(onNext: { [unowned self] query in // subscribe
      print("query: \(query)")
      self.shownCities = self.allCities.filter({ $0.hasPrefix(query) })
      self.tableView.reloadData()
    })
    .disposed(by: disposeBag)
}
```

> - input: 
>   - Paris
> - output: 
>     - query: P
>     - query: Pa
>     - query: Par
>     - query: Pari
>     - query: Paris


#### - 위 코드대로 실행시 발생할 수 있는 문제

1. issue #1: API 요청이 과도하게 발생할 수 있음
   - solve: 타이핑 후 delay 추가 -> 검색 키워드가 변했는지 체크 -> 변한 경우에만 subscribe
2. issue #2: 빈 값이 들어올 수 있음
   - solve: filter로 빈 값이 아닌 경우만 subscribe

### ㅇ Issue solved
``` swift
searchBar
  .rx.text
  .orEmpty
  .debounce(0.5, scheduler: MainScheduler.instance) // 0.5초 기다림. 안 줄 경우, 모든 입력을 받음. (API의 과도한 호출을 방지)
  .distinctUntilChanged() // 새로운 값이 이전과 같은지 체크 (O -> Oc -> O 값이 이전과 같으므로 다음으로 안넘어감)
  .filter({ !$0.isEmpty })
  .subscribe(onNext: { [unowned self] query in
    self.shownCities = self.allCities.filter({ $0.hasPrefix(query) })
    self.tableView.reloadData()
  })
  .disposed(by: disposeBag)
```

> - input: 
>   - Paris
> - output: 
>     - query: Paris

- 이전에는 P, Pa, Par, Pari, Paris 총 5번 API를 콜했다면, subscribe 전 딜레이를 줌으로써 `Paris` 1번만 콜하는 방식으로 변경됐다.

<br>

-------

## ㅁ Comment
- 예전에 처음 이 예제를 접했을 때는 무슨 뜻인지도 모르고 따라 치기 바빴는데, `Vue`를 접하면서 함수형 프로그래밍을 조금 맛보고, [RxJS 퀵스타트 책](http://book.interpark.com/product/BookDisplay.do?_method=detail&sc.saNo=001&sc.prdNo=289053468&gclid=Cj0KCQiAzKnjBRDPARIsAKxfTRA5FQvCMyvODJdQhYinBlZlnb2UszjFKkB-CMKbRz2ZXNekxDgElv4aAhSYEALw_wcB&product2017=true)을 보면서 기존에 있었던 어떤 문제를 해결하고자 Rx가 태동했는지 그 백그라운드를 자세하게 알고 난 후 보니 훨씬 이해가 잘 된다. (책 정말 강추합니다. 😂)
- Rx의 기능을 하나 하나 공부하기 전에 맛보기 예제를 통해 위와 같은 방식 혹은 상황에서 Rx를 이용할 수 있고, 기존 대비 코드가 매우 깔끔 + 간단해진다는 걸 알게 됐다. 

## ㅁ Link
- [pilgwon님 블로그](https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html)
