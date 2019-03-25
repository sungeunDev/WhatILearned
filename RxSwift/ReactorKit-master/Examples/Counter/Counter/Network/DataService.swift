//
//  DataService.swift
//  Counter
//
//  Created by Ari on 21/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import Foundation

class DataService {
    static func getCourseWords(completion: (Result<[CourseWord]>) -> Void) {
        let url = Bundle.main.url(forResource: "data", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: url)
            let courseWords = try JSONDecoder().decode([CourseWord].self, from: data)
            let result = Result<[CourseWord]>.success(courseWords)
            completion(result)
        } catch {
            let result = Result<[CourseWord]>.failure(error)
            print("error: \(error.localizedDescription)")
            completion(result)
        }
    }
}
