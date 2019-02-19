//
//  MapperModel.swift
//  RxSwiftStudy3
//
//  Created by Ari on 19/02/2019.
//  Copyright © 2019 ssungnni. All rights reserved.
//

import Foundation

import Mapper

struct Repository: Mappable {
    let identifier: Int
    let language: String
    let name: String
    let fullName: String

    init(map: Mapper) throws {
        try identifier = map.from("id")
        try language = map.from("language")
        try name = map.from("name")
        try fullName = map.from("full_name")
    }
}


struct Issue: Mappable {
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}
