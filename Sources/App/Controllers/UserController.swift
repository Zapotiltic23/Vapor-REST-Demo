//
//  UserController.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 7/23/23.
//

import Foundation
import Fluent
import Vapor

struct UserController: RouteCollection, RoutesProtocol {
    
    typealias X = UserPayload
    typealias N = CoachPayload
    typealias T = TokenPayload
    typealias P = AthletePayload
   
    func boot(routes: RoutesBuilder) throws {
        
        let publicAPI = routes.grouped("\(Constants.Routes.api_route)")
        let tokenAuthorizationAPI = MiddlewareHelper.shaerd.getTokenAuthorizationRoute(routes: routes)
        let adminAuthorizationAPI = MiddlewareHelper.shaerd.getAdminAuthorizationRoute(routes: routes)
                
        //http://127.0.0.1:8080/api-v1/user/search?term=
        publicAPI.get("\(Constants.Routes.user_route)", "\(Constants.Routes.search_route)", use: self.searchModels)
        
        //http://127.0.0.1:8080/api-v1/user
        adminAuthorizationAPI.get("\(Constants.Routes.user_route)", use: self.returnAllModels)
        publicAPI.get("\(Constants.Routes.user_route)", use: self.returnAllModels)
        publicAPI.post("\(Constants.Routes.user_route)", use: self.createModel)
        
        //http://127.0.0.1:8080/api-v1/user/USER_ID
        adminAuthorizationAPI.delete("\(Constants.Routes.user_route)", ":id", use: self.deleteByID)
        tokenAuthorizationAPI.put("\(Constants.Routes.user_route)", ":id", use: self.updateModel)
        publicAPI.get("\(Constants.Routes.user_route)", ":id", use: self.getUserWithID)
        
        //http://127.0.0.1:8080/api-v1/user/USER_ID/coach
        tokenAuthorizationAPI.get("\(Constants.Routes.user_route)", ":id", "\(Constants.Routes.coach_route)", use: self.getAllCoaches)
        
        //http://127.0.0.1:8080/api-v1/user/USER_ID/athlete
        tokenAuthorizationAPI.get("\(Constants.Routes.user_route)", ":id", "\(Constants.Routes.athlete_route)", use: self.getAllAthletes)
    }
    
    
    //MARK: Coaches....
    
    @Sendable func getAllCoaches(req: Request) async throws -> AnalyticsResponse<N> {
        
        let response : AnalyticsResponse<N> = AnalyticsResponse<N>(statusCode: .notFound, data: nil, errorMessage: "No models found!")
        
        do {
            guard let dbModel : UserModel = try await UserModel.find(req.parameters.get("id"), on: req.db) else {return response}
            guard let coaches : [CoachModel] = try? await dbModel.$coaches.get(on: req.db) else {return response}
            var payloads : [N] = []
            for coach in coaches {
                guard let athletes : [AthleteModel] = try? await coach.$athletes.get(on: req.db) else {return response}
                let athleteIDs: [UUID] = athletes.map({$0.id}).compactMap({$0})
                let payload: CoachPayload = CoachPayload(id: coach.id,
                                                         userID: coach.$user.id,
                                                         athleteIDs: athleteIDs,
                                                         name: coach.name,
                                                         lastName: coach.lastName,
                                                         email: coach.email,
                                                         institutionName: coach.institutionName,
                                                         phoneNumber: coach.phoneNumber,
                                                         sport: coach.sport,
                                                         age: coach.age,
                                                         profileImageName: coach.profileImageName,
                                                         nationality: coach.nationality,
                                                         institutionImageName: coach.institutionImageName,
                                                         leagueName: coach.leagueName,
                                                         leagueDivision: coach.leagueDivision,
                                                         coachTitle: coach.coachTitle,
                                                         leagueImageName: coach.leagueName,
                                                         isAvailable: coach.isAvailable,
                                                         reasonWhy: coach.reasonWhy,
                                                         season: coach.season,
                                                         teamName: coach.teamName,
                                                         teamGender: coach.teamGender,
                                                         badgeStyle: coach.badgeStyle,
                                                         badgeSize: coach.badgeSize,
                                                         createdAt: coach.createdAt,
                                                         updatedAt: coach.updatedAt)
                
                payloads.append(payload)
            }
            return AnalyticsResponse<N>(statusCode: .ok, data: payloads)
        } catch {
            return AnalyticsResponse<N>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to return models for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    
    //MARK: Coaches....

    @Sendable func getAllAthletes(req: Request) async throws -> AnalyticsResponse<P> {
        
        let response : AnalyticsResponse<P> = AnalyticsResponse<P>(statusCode: .notFound, data: nil, errorMessage: "No models found!")
        
        do {
            guard let dbModel : UserModel = try await UserModel.find(req.parameters.get("id"), on: req.db) else {return response}
            let payload: [P] = await self.buildAthletePayload(model: dbModel, req: req)
            return AnalyticsResponse<P>(statusCode: .ok, data: payload)
        } catch {
            return AnalyticsResponse<P>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to return models for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    
    //MARK: Protocol requirements....
    
    @Sendable func returnAllModels(req: Request) async throws -> AnalyticsResponse<X> {
        do {
            let dbModels : [UserModel] = try await UserModel.query(on: req.db).all()
            let paylaod : [X] = dbModels.map({UserPayload(id: $0.id,
                                                          name: $0.name,
                                                          lastName: $0.lastName,
                                                          email: $0.email,
                                                          password: nil,
                                                          confirmPassword: nil,
                                                          userRole: $0.userRole,
                                                          dateOfBirth: $0.dateOfBirth,
                                                          createdAt: $0.createdAt,
                                                          updatedAt: $0.updatedAt)})
            return AnalyticsResponse<X>(statusCode: .ok, data: paylaod)
        } catch {
            return AnalyticsResponse<X>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to return models for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    @Sendable func createModel(req: Request) async throws -> AnalyticsResponse<X> {
        
        let response : AnalyticsResponse<X> = AnalyticsResponse<X>(statusCode: .badRequest, data: nil, errorMessage: "Unable to create user record!")
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let requestPayload : UserPayload = try req.content.decode(UserPayload.self, using: decoder)
            try UserPayload.validate(content: req)
            guard requestPayload.password == requestPayload.confirmPassword else {
                return response
            }
            guard let lookup : [UserModel] = try? await UserModel.query(on: req.db).group(.or, { relation in
                relation.filter(\.$email == requestPayload.email)
            }).all() else { return response }
            
            if lookup.count <= 0 {
                let userID: UUID = requestPayload.id ?? UUID()
                let userToSave: UserModel = UserModel(id: userID,
                                                      name: requestPayload.name,
                                                      lastName: requestPayload.lastName,
                                                      email: requestPayload.email,
                                                      passwordHash: try Bcrypt.hash(requestPayload.password ?? ""),
                                                      userRole: requestPayload.userRole,
                                                      dateOfBirth: requestPayload.dateOfBirth)
                try await userToSave.save(on: req.db)
                let savedUser: UserPayload = UserPayload(id: userID,
                                                         name: requestPayload.name,
                                                         lastName: requestPayload.lastName,
                                                         email: requestPayload.email,
                                                         password: nil,
                                                         confirmPassword: nil,
                                                         userRole: requestPayload.userRole, 
                                                         dateOfBirth: requestPayload.dateOfBirth,
                                                         createdAt: .now,
                                                         updatedAt: .now)
                return AnalyticsResponse<X>(statusCode: .ok, data: [savedUser])
            } else {
                return AnalyticsResponse<X>(statusCode: .notAcceptable, data: nil, errorMessage: "Model already exists in DB!!")
            }
        } catch {
            return AnalyticsResponse<X>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to create model for the following reasons: Error:\n\n " + String(reflecting: error))
        }
    }
    
    
    @Sendable func updateModel(req: Request) async throws -> AnalyticsResponse<X> {
        
        let response : AnalyticsResponse<X> = AnalyticsResponse<X>(statusCode: .notImplemented, data: nil, errorMessage: "Unable to update model!")
        
        do {
            let requestPayload : X = try req.content.decode(X.self)
            guard let modelFromDB : UserModel = try await UserModel.find(req.parameters.get("id"), on: req.db) else { return response }
            modelFromDB.name = requestPayload.name
            modelFromDB.lastName = requestPayload.lastName
            modelFromDB.email = requestPayload.email
            modelFromDB.userRole = requestPayload.userRole
            modelFromDB.dateOfBirth = requestPayload.dateOfBirth
            try await modelFromDB.update(on: req.db)
            return AnalyticsResponse<X>(statusCode: .accepted, data: nil)
        } catch {
            return AnalyticsResponse<X>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to update model for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    
    @Sendable func deleteByID(req: Request) async throws -> AnalyticsResponse<X> {
        
        guard let modelFromDB : UserModel = try await UserModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<X>(statusCode: .notFound, data: nil, errorMessage: "Unable to find model on DB!")
        }
        
        do {
            try await modelFromDB.delete(on: req.db)
            return AnalyticsResponse<X>(statusCode: .ok, data: nil)
        } catch {
            return AnalyticsResponse<X>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to delete model for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    @Sendable func getUserWithID(req: Request) async throws -> AnalyticsResponse<X> {
        
        guard let modelFromDB : UserModel = try await UserModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<X>(statusCode: .notFound, data: nil, errorMessage: "Unable to find model on DB!")
        }
        
        let userPaylod: UserPayload = UserPayload(id: modelFromDB.id,
                                                  name: modelFromDB.name,
                                                  lastName: modelFromDB.lastName,
                                                  email: modelFromDB.email,
                                                  password: nil,
                                                  confirmPassword: nil,
                                                  userRole: modelFromDB.userRole, 
                                                  dateOfBirth: modelFromDB.dateOfBirth,
                                                  createdAt: modelFromDB.createdAt,
                                                  updatedAt: modelFromDB.updatedAt)
        return AnalyticsResponse<X>(statusCode: .ok, data: [userPaylod])
    }
    
    
    @Sendable func searchModels(req: Vapor.Request) async throws -> AnalyticsResponse<X> {
        
        let response : AnalyticsResponse<X> = AnalyticsResponse<X>(statusCode: .badRequest, data: nil, errorMessage: "Unable to find model in DB!")
        
        do {
            let searchTerm = try req.query.get(String.self ,at: "term")
            guard let filteredItems : [UserModel] = try? await UserModel.query(on: req.db).group(.or, { relation in
                relation.filter(\.$email == searchTerm)
            }).all() else { return response }
            
            if filteredItems.count > 0 {
                let payloads : [X] = filteredItems.map({UserPayload(id: $0.id,
                                                                    name: $0.name,
                                                                    lastName: $0.lastName,
                                                                    email: $0.email,
                                                                    password: nil,
                                                                    confirmPassword: nil,
                                                                    userRole: $0.userRole, 
                                                                    dateOfBirth: $0.dateOfBirth,
                                                                    createdAt: $0.createdAt,
                                                                    updatedAt: $0.updatedAt)})
                return AnalyticsResponse<X>(statusCode: .ok, data: payloads)
            }else{
                return response
            }
        } catch {
            return AnalyticsResponse<X>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to delete model for the following reasons: Error: " + String(reflecting: error))
        }
    }
}

