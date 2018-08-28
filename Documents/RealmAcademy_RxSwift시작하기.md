# RxSwift 시작하기
- Realm Academy의 RxSwift 시작하기(by 최완복) 강의를 보고 간략하게 내용 정리.
- Reactive란 무엇인지, RxSwift의 기초 개념을 설명
- link: https://academy.realm.io/kr/posts/letswift-rxswift/


## RxSwift
- **Reactive** Extension + Functional Programming
- Reactive: Programming Paradigm
    + Data flows
    + propagation of change
    

## FRP (functional reactive programming)
1. Functional Programming
    - 절차적 방법
>
``` 
var sum = 0
for i in 1...0 {
    sum += 1
}
print(sum)
```
- 결과값을 만드는 sum 변수를 만들어서 sum 변화시키며 값을 저장.

    + 함수적 방법
    >
    ```
print((1...10).reduce(0) { $0 + $1 }
    ```
    - 상태가 저장되지 않기 대문에 변화되는 값도 없음.

2. Data flow
    - 함수를 연결해가며 데이터를 함수에 흘려보낼 수 있음.
    >
    ```
    (1...10)
    .filter { $0 % 2 == 0 }
    .map { $0 * 10 }
    .reduce(0) { $0 + $1 }
    ```

3. Propagation of Change
    - 데이터 값이 변경되더라도 변화는 유지됨.
    - ex. 엑셀 스프레드 시트.

## Reactive X
- FRP의 구현체: Reactive X
- An API for asynchrouous programming with **observable** streams.
- observable: 다수의 이벤트를 비동기적으로 다루는 방법. 옵저버 패턴의 확장.

>| 구분 | 단일 | 다수 |
|:--------:|:--------:|:--------:|
| 동기 | `Try<T>` | `Iterable<T>` |
| 비동기 | `Future<T>` | `Observable<T>` |


- Observable Stream
    - Observable 이벤트 발생 -> Operate 조작 -> Subscribe 구독
    - 스트림 상에 나타나는 이벤트 종류
        + OnNext
        + OnError
        + OnCompleted

>| 구분 | Iterable(pull) | Observable(push) |
|:--------:|:--------:|:--------:|
| 데이터 받기 | T next() | onNext(T) |
| 에러 발견 | throws Exception | onError(Exception) |
| 완료 | !hasNext() | onCompleted() |
| 방식 | PULL | PUSH |
| 설명 | 객체가 데이터를 끌어내서 쓰는 것 | 옵저버블이 구독하는 객체한테 보내주는 것 |


- 예시
``` swift
Observable.create<String> { observer in 
    observer.onNext("A")
    observer.onNext("B")
    observer.onNext("C")
    observer.onCompleted()
}
.subscribe {
    pirnt($0) 
}

// A
// B
// C
```
    