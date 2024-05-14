//
//  APIResponseProtcol.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 2/4/23.
//

import Fluent
import Vapor

public protocol APIResponseProtcol {
    
    associatedtype M : Model, Content
    
    var data: [M]? {get set}
    var statusCode: HTTPStatus {get set}
    var errorMessage: String? {get set}
    var dateOrigin: Date {get set}
}
