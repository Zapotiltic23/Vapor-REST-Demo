//
//  File.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 9/3/23.
//

import Foundation
import Vapor

public struct CheckForRoleMiddleware: AsyncMiddleware {
    
    let role: UserRole
    
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let user: UserModel = request.auth.get(UserModel.self) else {
            throw Abort(.forbidden, reason: "You are not authenticated 🤷🏽‍♂️")
        }
        guard user.userRole == role.rawValue else {
            throw Abort(.forbidden, reason: "You need \(role.rawValue) rights to continue 🤷🏽‍♂️")
        }
        return try await next.respond(to: request)
    }
}
