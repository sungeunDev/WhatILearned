- RxSwift를 공부하며 pilgwon님이 번역하신 예제를 따라해 보고 제가 알아보기 쉽도록 정리해둔 글입니다.
- 키워드: `bindings`, `subject`

## 키워드 스터디
- bingding: 말 그대로 `묶는것`. Observables를 Subjects로 연결.
  > **복습!!**
  > - Observable: Event를 방출(emitting)함. Observer가 관찰할 수 있음.
  > - Observer: Observable가 방출하는 event를 subscribe해서 Observable을 관찰함.
  > 예제) 스마트폰은 관찰이 가능하고 유저에게 페이스북 알림 등 신호를 방출함. 유저는 스마트폰을 구독하고 있고, 알림을 홈 스크린에서 확인해서 그 신호로 뭘 할지 정할 수 있는 관찰자임.
- Subject: Observable과 Observer를 한꺼번에 부르는 용어. Subject 종류는 3가지로 기본적으로 모두 구독하면 구독 이후에 반환하는 값을 얻게 된다. 차이점은 `구독 이전의 값`도 가져오는지, 가져온다면 `얼마나 가져오는지`이다.
  - Behavior Subject: 구독 이전에 반환한 가장 최근값을 추가로 가져옴.
    - Variable: BehaviorSubject를 wrap한 클래스로 에러를 발생시키지 않음.
    - `Variable`은 deprecated 예정이고 `BehaviorRelay`로 대체된다고 한다. 
    - ** 참고: 
      > [DEPRECATED] `Variable` is planned for future deprecation. Please consider `BehaviorRelay` as a replacement. Read more at: https://git.io/vNqvx
  - Publish Subject: 구독 이전 반환 값은 가져오지 않고 오직 이후의 값만 가져옴.
  - Replay Subject: 구독 이전에 반환한 값을 Replay Subject의 버퍼 사이즈만큼 가져옴.

- Subject 구분에 대해 필권님 블로그에 있는 예제가 정말 찰떡이므로 헷갈린다면 다시 두번 세번 읽어볼 것!!!


## ㅁ 예제 2
- 원형(🔴)의 뷰를 드래그 할 때마다 위치에 따라 뷰의 색상이 변경됩니다.
- 원의 위치와 원의 색을 binding 합니다. 색깔들을 연결하기 쉽게 `Chameleon`을 사용합니다.

### ㅇ UI
- 드래그하는대로 움직이는 원 만들기
  
``` swift
var circleView: UIView!

override func viewDidLoad() {
  super.viewDidLoad()
  setup()
}

func setup() {
  // 원 모양의 뷰를 그립니다
  circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
  circleView.layer.cornerRadius = circleView.frame.width / 2.0
  circleView.center = view.center
  circleView.backgroundColor = .green
  view.addSubview(circleView)

  // gesture recognizer를 추가합니다
  let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
  circleView.addGestureRecognizer(gestureRecognizer)
}

func circleMoved(_ recognizer: UIPanGestureRecognizer) {
  let location = recognizer.location(in: view)
  UIView.animateWithDuration(0.1) {
    self.circleView.center = location
  }
}
```

### ㅇ ViewModel
- 새로운 위치를 받을 때마다 원의 배경색을 계산하는 ViewModel

``` swift
class CircleViewModel {
  var centerVariable = Variable<CGPoint?>(.zero) // Create one variable that will be changed and observed
  var backgroundColorObservable: Observable<UIColor>! // Create observable that will change backgroundColor based on center

  init() {
      setup()
  }

  setup() {
    // 새로운 중앙 값을 받으면, 새로운 UIColor를 반환
    backgroundColorObservable = centerVariable.asObservable() // #1
      .map { center in // #2
        guard let center = center else { return UIColor.flatten(.black)() }
        
        let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0
        let green: CGFloat = 0.0
        let blue: CGFloat = 0.0
        
        return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1))()
      }
  }
}
```

- 왜 `centerVariable`은 `Variable`이고, `backgroundColorObservable`은 `Observable`일까?
  - centerVariable은 `ViewController의 cirvleView를 관찰하는 Observer`이자 `ViewModel에서는 관찰당하는 Observable`
  - 즉, Observer와 Observable 둘 다로 사용하기 때문에 Subject 이다.

- #1 Variable은 Observer와 Observable 둘 다 될 수 있기 때문에 하나를 결정해 줘야 함. ViewModel에서는 Observable로 사용
- #2 center: CGPoint 값을 UIColor로 반환


### ㅇ Add ViewModel to View

``` swift
func setup() {
  // 원 모양의 뷰를 추가합니다 ~ (생략)

  circleViewModel = CircleViewModel()
  // CircleView의 중앙 지점을 centerObservable에 묶습니다(Bind).
  circleView
    .rx.observe(CGPoint.self, "center") // circleView의 center CGPoint를 observe
    .bindTo(circleViewModel.centerVariable) // centerVariable에 bind
    .addDisposableTo(disposeBag)

  // ViewModel의 새로운 색을 얻기 위해 backgroundObservable을 구독(Subscribe)
  circleViewModel.backgroundColorObservable
    .subscribe(onNext: { [weak self] backgroundColor in // weak self, unowned self - 캡쳐한 인스턴스가 nil이 가능성이 있으면 weak
      UIView.animateWithDuration(0.1) {
        self?.circleView.backgroundColor = backgroundColor
        // 주어진 배경색의 상호 보완적인 색을 구합니다
        let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
        // 새로운 배경색과 기존의 배경색이 다른지 검사합니다
        if viewBackgroundColor != backgroundColor {
          // 원의 배경색으로 새로운 배경색을 할당합니다
          // 우린 그저 뷰에서의 원이 보일 수 있는 다른 색을 원합니다
          self?.view.backgroundColor = viewBackgroundColor
        }
      }
    })
    .addDisposableTo(disposeBag)

  // gesture recognizer를 추가합니다 ~ (생략)
}
```

<br>

-------
## ㅁ Link
- [pilgwon님 블로그](https://pilgwon.github.io/blog/2017/10/09/RxSwift-By-Examples-2-Observable-And-The-Bind.html)
