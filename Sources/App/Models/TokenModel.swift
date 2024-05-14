//
//  TokenModel.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 8/6/23.
//

import Foundation
import Fluent
import Vapor

final class TokenModel: Model, Content, ModelTokenAuthenticatable {
    
    /*
     ModelTokenAuthenticatable: This will allow for tokens to authenticate your User model
     */
    static let schema = Constants.ModelSchema.token_schema
    static let valueKey = \TokenModel.$value
    static let userKey = \TokenModel.$user
    
    var isValid: Bool {
        /*
         If this is false, the token will be deleted from the database and the user will not be authenticated.
         For simplicity, we'll make the tokens eternal by hard-coding this to true
         */
        
        //Invalidate token here on logout...
        true
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .value)
    var value: String
    
    @Parent(key: .userID)
    var user: UserModel
    
    @Timestamp(key: .createdAt, on: .create, format: .iso8601)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, value: String, userID: UserModel.IDValue, createdAt: Date? = nil) {
        self.id = id
        self.value = value
        self.$user.id = userID
        self.createdAt = createdAt
    }
}
