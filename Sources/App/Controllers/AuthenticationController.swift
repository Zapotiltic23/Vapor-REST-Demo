//
//  AuthenticationController.swift
//
//
//  Created by Horacio Alexandro Sanchez on 9/3/23.
//

import Foundation
import Fluent
import Vapor


/*
 
 */

struct AuthenticationController: RouteCollection {
    
    typealias T = TokenPayload

    func boot(routes: RoutesBuilder) throws {
                
        let guardMiddleware = UserModel.authenticator()
        let basicMididlewareGroup = routes.grouped(guardMiddleware)
        let basicAthenticationAPI = basicMididlewareGroup.grouped("\(Constants.Routes.api_route)")
        
        //http://127.0.0.1:8080/api-v1/login
        basicAthenticationAPI.post("\(Constants.Routes.login_route)", use: self.handleUserLogin)
    }
    
    @Sendable func handleUserLogin(req: Request) async throws -> AnalyticsResponse<T> {
        let response : AnalyticsResponse<T> = AnalyticsResponse<T>(statusCode: .notFound, data: nil, errorMessage: "No records found!")
        do {
            try UserPayload.validate(content: req)
            let user: UserModel = try req.auth.require(UserModel.self)
            let token: TokenModel = try user.generateToken()
            try await token.save(on: req.db)
            guard let filteredModels : [TokenModel] = try? await TokenModel.query(on: req.db).group(.or, { relation in
                relation.filter(\.$user.$id == user.id ?? UUID())
            }).all() else { return response }
            guard let dbToken: TokenModel = filteredModels.first else {return response}
            let payload: TokenPayload = TokenPayload(id: dbToken.id, value: dbToken.value, userID: user.id?.uuidString ?? "")
            return AnalyticsResponse<T>(statusCode: .ok, data: [payload])
        } catch {
            return AnalyticsResponse<T>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to authenticate for the following reasons: Error: " + String(reflecting: error))
        }
    }
}



