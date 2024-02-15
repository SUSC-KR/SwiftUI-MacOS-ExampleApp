//
//  ToDo.swift
//  LifeAgile
//
//  Created by Keith on 2/12/24.
//

import Foundation

struct ToDo: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    let createdAt: String
    var duration: Int
}
