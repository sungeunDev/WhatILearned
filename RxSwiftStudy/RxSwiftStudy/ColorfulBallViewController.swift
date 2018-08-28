//
//  ColourfulBallViewController.swift
//  
//
//  Created by sungnni on 2018. 8. 28..
//
import ChameleonFramework
import RxSwift
import RxCocoa
import UIKit

class ColorfulBallViewController: UIViewController {
  var circleView: UIView!
  var circleViewModel: CircleViewModel!
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  func setup() {
    // 원 모양의 뷰
    circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)))
    circleView.center = view.center
    circleView.layer.cornerRadius = circleView.frame.width / 2
    circleView.backgroundColor = .green
    self.view.addSubview(circleView)
    
    circleViewModel = CircleViewModel()
    // circleView의 중앙 지점을 centerObservable에 bind
    circleView
      .rx.observe(CGPoint.self, "center") // keyPath는 어디에 쓰임?
      .bind(to: circleViewModel.centerVariable)
      .disposed(by: disposeBag)
    
    // ViewModel의 새로운 색을 얻기 위해 backgroundObservable을 구독(Subscribe)
    circleViewModel.backgroundColorObservable
      .subscribe(onNext: { [weak self] backgroundColor in // weak self, unowned self - 캡쳐한 인스턴스가 nil이 가능성이 있으면 weak
        UIView.animate(withDuration: 0.1, animations: {
          self?.circleView.backgroundColor = backgroundColor
          
          let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
          if viewBackgroundColor != backgroundColor {
            self?.view.backgroundColor = viewBackgroundColor
          }
        })
      })
      .disposed(by: disposeBag)
    
    
    // pan gesture 추가
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
    circleView.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
    let location = recognizer.location(in: view)
    UIView.animate(withDuration: 0.1) {
      self.circleView.center = location
    }
  }
}
