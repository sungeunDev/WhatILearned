//
//  ContentView.swift
//  SwiftUISample
//
//  Created by Sungeun Park on 2020/05/24.
//  Copyright © 2020 Sungeun Park. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //Chapter02
        VStack(spacing: 30) {
            
            Text("1. NSAttributedString을 사용하지 않아도\n 간단하게 구현할 수 있어요ㅠㅠㅠㅠㅠㅠㅠㅠㅠ")
                .font(.system(size: 20))
                .fontWeight(.black)
                .frame(height: 60.0)
            
            Text("Bold")
                .bold()
                .italic()
                .underline()
                .strikethrough()
                .padding(10)
            
            (Text("자간 조정하기 ").kerning(8)
                + Text("텍스트 묶기").baselineOffset(8))
                .font(.system(size: 16))
                .background(Color.yellow)
            
            Text("2. 수식어를 적용할때는 순서가 중요합니다!")
                .font(.system(size: 20))
                .fontWeight(.black)
                .frame(height: 60.0)
            
            //1) 어떤 수식어는 Text 프로토콜에만, 어떤건 View 프로토콜에 있기 때문이에요!
            //예를 들어 bold(), italic()은 Text에만 있겠쥬?? View에는 padding()이 있습니다. 이때,
            //            Text("순서가 매우 중요해요")
            //            .padding(10)
            //            .bold()
            //의 순서로 하면 `Value of type 'some View' has no member 'bold'` 에러가 납니다. 때문에 공용 수식어를 적용하기 전에 각 뷰가 가진 전용 수식어를 우선 적용해야 합니다.
            
            Text("1) 어떤 수식어는 Text 프로토콜에만, 어떤건 View 프로토콜에 있기 때문이에요!")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.red)
                .frame(height: 80.0)
            
            Text("2) 순서에 따라 적용 여부가 달라지기 때문이에요!")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .background(Color.blue)
                .padding(10) //패딩이 적용 안됐다구욧!
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
