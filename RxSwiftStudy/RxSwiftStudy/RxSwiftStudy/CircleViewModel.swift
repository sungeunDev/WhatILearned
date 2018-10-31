//
//  CircleViewModel.swift
//  RxSwiftStudy
//
//  Created by sungnni on 2018. 8. 28..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ChameleonFramework

class CircleViewModel {
  
  var centerVariable = Variable<CGPoint?>(.zero)
  var backgroundColorObservable: Observable<UIColor>!
  
  init() {
    setup()
  }
  
  func setup() {
    // 새로운 중앙 값을 받으면, 새로운 UIColor를 반환
    backgroundColorObservable = centerVariable.asObservable()
      .map{ center in
        guard let center = center else { return UIColor.flatten(.black)() }
        
        let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0
        let green: CGFloat = 0.0
        let blue: CGFloat = 0.0
        return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1))()
      }
    
    
  }
  
}
