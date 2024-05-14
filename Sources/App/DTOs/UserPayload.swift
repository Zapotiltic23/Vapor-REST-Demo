//
//  UserPayload.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 7/23/23.
//

import Foundation
import Vapor

struct UserPayload: Content, Validatable {
    var id: UUID?
    var name: String
    var lastName: String
    var email: String
    var password: String?
    var confirmPassword: String?
    var userRole: String
    var dateOfBirth: String
    var createdAt: Date?
    var updatedAt: Date?
    
    init(id: UUID?, name: String, lastName: String, email: String, password: String?, confirmPassword: String?, userRole: String, dateOfBirth: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.userRole = userRole
        self.dateOfBirth = dateOfBirth
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
