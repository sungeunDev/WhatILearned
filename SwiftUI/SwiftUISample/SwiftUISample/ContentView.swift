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
        
        Text("Hello, World! wow!")
        .font(.largeTitle)
        .foregroundColor(.blue)
        //기존 프로퍼티를 변경하는 거라면, 새로운 텍스트 구조체를 반환하는것!!!!!
        //--> 사이드 이펙트를 줄일 수 있다.
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
