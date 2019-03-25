//
//  Word.swift
//  Counter
//
//  Created by Ari on 19/03/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import Foundation

struct CourseWord: Codable {
    var id: Int
    var mn: [String] // meaning
    var pr: String // pronounce
    var stg: Int
    var wd: String // word
}
