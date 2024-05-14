//
//  MiddlewareHelper.swift
//
//
//  Created by Horacio Alexandro Sanchez on 9/4/23.
//

import Foundation
import Fluent
import Vapor

public struct MiddlewareHelper: Sendable {
    
    //MARK: Basic Auth Middleware
        
    static let shaerd: MiddlewareHelper = MiddlewareHelper()
    
    public func getBasicAuthenticationRoute(routes: RoutesBuilder) -> RoutesBuilder {
        let route = routes.grouped(UserModel.authenticator())
        return route.grouped("\(Constants.Routes.api_route)")
    }
    
    public func getTokenAuthorizationRoute(routes: RoutesBuilder) -> RoutesBuilder {
        let route = routes.grouped(TokenModel.authenticator(), UserModel.guardMiddleware())
        return route.grouped("\(Constants.Routes.api_route)")
    }
    
    public func getAdminAuthorizationRoute(routes: RoutesBuilder) -> RoutesBuilder {
        let route = routes.grouped(TokenModel.authenticator(), CheckForRoleMiddleware(role: .admin))
        return route.grouped("\(Constants.Routes.api_route)")
    }
    
    public func getCoachAuthorizationRoute(routes: RoutesBuilder) -> RoutesBuilder {
        let route = routes.grouped(CheckForRoleMiddleware(role: .coach), TokenModel.authenticator())
        return route.grouped("\(Constants.Routes.api_route)")
    }
}
