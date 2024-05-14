//
//  TokenController.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 8/6/23.
//

import Foundation
import Fluent
import Vapor

struct TokenController: RouteCollection {
    
    typealias U = UserPayload
    typealias T = TokenPayload

    func boot(routes: RoutesBuilder) throws {
        
        let tokenAuthorizationAPI = MiddlewareHelper.shaerd.getTokenAuthorizationRoute(routes: routes)
        
        //http://127.0.0.1:8080/api-v1/token
        tokenAuthorizationAPI.get("\(Constants.Routes.token_route)", use: self.returnAllModels)

        //http://127.0.0.1:8080/api-v1/authentication
        tokenAuthorizationAPI.get("\(Constants.Routes.authentication_route)", use: self.getAuthenticatedUser)
        
        //http://127.0.0.1:8080/api-v1/token/TOKEN_ID
        tokenAuthorizationAPI.delete("\(Constants.Routes.token_route)", ":id", use: self.deleteByID)
    }
        
    @Sendable func getAuthenticatedUser(req: Request) async throws -> AnalyticsResponse<U> {
        do {
            let user: UserModel = try req.auth.require(UserModel.self)
            let payload: UserPayload = UserPayload(id: user.id,
                                                   name: user.name,
                                                   lastName: user.lastName,
                                                   email: user.email,
                                                   password: nil,
                                                   confirmPassword: nil,
                                                   userRole: user.userRole, 
                                                   dateOfBirth: user.dateOfBirth)
            return AnalyticsResponse<U>(statusCode: .ok, data: [payload])
        } catch {
            return AnalyticsResponse<U>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to return models for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    
    @Sendable func returnAllModels(req: Request) async throws -> AnalyticsResponse<T> {
        do {
            let dbModels : [TokenModel] = try await TokenModel.query(on: req.db).all()
            let paylaod : [T] = dbModels.map({TokenPayload(id: $0.id,
                                                           value: $0.value,
                                                           userID: $0.$user.id.uuidString,
                                                           createdAt: $0.createdAt)})
            return AnalyticsResponse<T>(statusCode: .ok, data: paylaod)
        } catch {
            return AnalyticsResponse<T>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to return models for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    @Sendable func deleteByID(req: Request) async throws -> AnalyticsResponse<U> {
        
        guard let modelFromDB : TokenModel = try await TokenModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<U>(statusCode: .notFound, data: nil, errorMessage: "Unable to find model on DB!")
        }
        
        do {
            try await modelFromDB.delete(on: req.db)
            return AnalyticsResponse<U>(statusCode: .ok, data: nil)
        } catch {
            return AnalyticsResponse<U>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to delete model for the following reasons: Error: " + String(reflecting: error))
        }
    }
}

