//
//  TokenPayload.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 8/6/23.
//

import Foundation
import Vapor

struct TokenPayload: Content {
    
    var id: UUID?
    var value: String
    var userID: String
    var createdAt: Date?
    
    public init(id: UUID?, value: String, userID: String, createdAt: Date? = nil) {
        self.value = value
        self.userID = userID
        self.id = id
        self.createdAt = createdAt
    }
}
