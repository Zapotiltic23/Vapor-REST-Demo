//
//  CoachController.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Fluent
import Vapor

struct CoachController: RouteCollection, RoutesProtocol {
    
    typealias N = CoachPayload
    typealias X = UserPayload
    typealias S = AthletePayload
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        
        let publicAPI = routes.grouped("\(Constants.Routes.api_route)")
        let tokenAuthorizationAPI = MiddlewareHelper.shaerd.getTokenAuthorizationRoute(routes: routes)
//        let adminAuthorizationAPI = MiddlewareHelper.shaerd.getAdminAuthorizationRoute(routes: routes)
//        let coachAuthorizationAPI = MiddlewareHelper.shaerd.getCoachAuthorizationRoute(routes: routes)
        
        //http://127.0.0.1:8080/api-v1/coach
        publicAPI.get("\(Constants.Routes.coach_route)", use: self.returnAllModels)
        tokenAuthorizationAPI.post("\(Constants.Routes.coach_route)", use: self.createModel)
//        adminAuthorizationAPI.post("\(Constants.Routes.coach_route)", use: self.createModel)
        
        //http://127.0.0.1:8080/api-v1/coach/search?term=
        tokenAuthorizationAPI.get("\(Constants.Routes.coach_route)", "\(Constants.Routes.search_route)", use: self.searchModels)
        
        //http://127.0.0.1:8080/api-v1/coach/RESTAURANT_ID
        tokenAuthorizationAPI.delete("\(Constants.Routes.coach_route)", ":id", use: self.deleteByID)
//        adminAuthorizationAPI.delete("\(Constants.Routes.coach_route)", ":id", use: self.deleteByID)
        
        tokenAuthorizationAPI.put("\(Constants.Routes.coach_route)", ":id", use: self.updateModel)
//        adminAuthorizationAPI.put("\(Constants.Routes.coach_route)", ":id", use: self.updateModel)
        
        //http://127.0.0.1:8080/api-v1/coach/COACH_ID/user
        tokenAuthorizationAPI.get("\(Constants.Routes.coach_route)", ":id", "\(Constants.Routes.user_route)", use: self.getUser)
//        adminAuthorizationAPI.get("\(Constants.Routes.coach_route)", ":id", "\(Constants.Routes.user_route)", use: self.getUser)
        
        //http://127.0.0.1:8080/api-v1/coach/COACH_ID/athlete/ATHLETE_ID
        tokenAuthorizationAPI.post("\(Constants.Routes.coach_route)", ":id", "athlete", ":athleteID", use: self.linkAthletes)
        tokenAuthorizationAPI.delete("\(Constants.Routes.coach_route)", ":id", "athlete", ":athleteID", use: self.detachAthletes)
        
        //http://127.0.0.1:8080/api-v1/coach/COACH_ID/athlete
        tokenAuthorizationAPI.get("\(Constants.Routes.coach_route)", ":id", "\(Constants.Routes.athlete_route)", use: self.getAthletes)
//        adminAuthorizationAPI.get("\(Constants.Routes.coach_route)", ":id", "\(Constants.Routes.athlete_route)", use: self.getAthletes)
    }
    
    
    //MARK: Relationships
        
    @Sendable func linkAthletes(req: Request) -> EventLoopFuture<AnalyticsResponse<N>> {
        
        let coachModel = CoachModel.find(req.parameters.get("id"), on: req.db).unwrap(or: Abort(.notFound))
        let athleteModel = AthleteModel.find(req.parameters.get("athleteID"), on: req.db).unwrap(or: Abort(.notFound))
        let response : AnalyticsResponse<N> = AnalyticsResponse(statusCode: .created, data: [], errorMessage: nil)
        
        return coachModel.and(athleteModel)
            .flatMap { coach, athlete in
                coach
                    .$athletes
                    .attach(athlete, on: req.db)
                    .transform(to: response)
            }
    }
    
    @Sendable func detachAthletes(req: Request) -> EventLoopFuture<AnalyticsResponse<N>> {
        
        let coachModel = CoachModel.find(req.parameters.get("id"), on: req.db).unwrap(or: Abort(.notFound))
        let athleteModel = AthleteModel.find(req.parameters.get("athleteID"), on: req.db).unwrap(or: Abort(.notFound))
        let response : AnalyticsResponse<N> = AnalyticsResponse(statusCode: .created, data: [], errorMessage: nil)
        
        return coachModel.and(athleteModel)
            .flatMap { coach, athlete in
                coach
                    .$athletes
                    .detach(athlete, on: req.db)
                    .transform(to: response)
            }
    }
    
    
    //MARK: Athletes....
    
    @Sendable func getAthletes(req: Request) async throws -> AnalyticsResponse<S> {
        
        var response : AnalyticsResponse<S> = AnalyticsResponse<S>(statusCode: .notFound, data: nil, errorMessage: "User not found!")
        guard let dbModel : CoachModel = try await CoachModel.find(req.parameters.get("id"), on: req.db) else { return response }
        let payload: [S] = await self.buildAthletePayload(model: dbModel, req: req)
        response = AnalyticsResponse<S>(statusCode: .ok, data: payload)
        return response
    }
    
    
    
    //MARK: User....
    
    @Sendable func getUser(req: Request) async throws -> AnalyticsResponse<X> {
        
        var response : AnalyticsResponse<X> = AnalyticsResponse<X>(statusCode: .notFound, data: nil, errorMessage: "User not found!")
        guard let requestModel : CoachModel = try await CoachModel.find(req.parameters.get("id"), on: req.db) else { return response }
        guard let modelFromDB : UserModel = try? await requestModel.$user.get(on: req.db) else { return response }
        let userPayload: UserPayload = UserPayload(id: modelFromDB.id,
                                                    name: modelFromDB.name,
                                                    lastName: modelFromDB.lastName,
                                                    email: modelFromDB.email,
                                                   password: nil,
                                                   confirmPassword: nil,
                                                   userRole: modelFromDB.userRole, 
                                                   dateOfBirth: modelFromDB.dateOfBirth,
                                                   createdAt: modelFromDB.createdAt,
                                                   updatedAt: modelFromDB.updatedAt)
        response = AnalyticsResponse<X>(statusCode: .ok, data: [userPayload])
        return response
    }
    
    
    
    //MARK: Protocol Requirements....
    
    @Sendable func returnAllModels(req: Vapor.Request) async throws -> AnalyticsResponse<N> {
        
        var response : AnalyticsResponse<N> = AnalyticsResponse(statusCode: .notFound, data: nil, errorMessage: "Your request is invalid!")
        guard let allModels : [CoachModel] = try? await CoachModel.query(on: req.db).all() else {return response}
        var payloads: [N] = []
        for coach in allModels {
            guard let payload : N = await self.createModelPayloads(coach: coach, req: req) else {continue}
            payloads.append(payload)
        }
        response = AnalyticsResponse<N>(statusCode: .ok, data: payloads)
        return response
    }
    
    @Sendable fileprivate func createModelPayloads(coach: CoachModel, req: Vapor.Request) async -> N? {
                
        guard let athletes : [AthleteModel] = try? await coach.$athletes.get(on: req.db) else {return nil}
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
                                                 leagueImageName: coach.leagueImageName,
                                                 isAvailable: coach.isAvailable,
                                                 reasonWhy: coach.reasonWhy,
                                                 season: coach.season,
                                                 teamName: coach.teamName,
                                                 teamGender: coach.teamGender,
                                                 badgeStyle: coach.badgeStyle,
                                                 badgeSize: coach.badgeSize,
                                                 createdAt: coach.createdAt,
                                                 updatedAt: coach.updatedAt)
        return payload
    }
    
    @Sendable func createModel(req: Request) async throws -> AnalyticsResponse<N> {
        
        let response : AnalyticsResponse<N> = AnalyticsResponse<N>(statusCode: .badRequest, data: nil, errorMessage: "Unable to create record!")
        
        do {
            let requestPayload : CoachPayload = try req.content.decode(CoachPayload.self)
            let lookup : [CoachModel]? = try? await CoachModel.query(on: req.db).group(.or, { relation in
                relation.filter(\.$email == requestPayload.email)
            }).all()
            
            if lookup?.count ?? 0 <= 0 {
                let coachID: UUID = UUID()
                let modelToSave: CoachModel = CoachModel(id: coachID,
                                                         userID: requestPayload.userID,
                                                         name: requestPayload.name,
                                                         lastName: requestPayload.lastName,
                                                         email: requestPayload.email,
                                                         institutionName: requestPayload.institutionName,
                                                         phoneNumber: requestPayload.phoneNumber,
                                                         sport: requestPayload.sport,
                                                         athleteIDs: requestPayload.athleteIDs,
                                                         age: requestPayload.age,
                                                         profileImageName: requestPayload.profileImageName,
                                                         nationality: requestPayload.nationality,
                                                         institutionImageName: requestPayload.institutionName,
                                                         leagueName: requestPayload.leagueName,
                                                         leagueDivision: requestPayload.leagueDivision,
                                                         coachTitle: requestPayload.coachTitle,
                                                         leagueImageName: requestPayload.leagueImageName,
                                                         isAvailable: requestPayload.isAvailable,
                                                         reasonWhy: requestPayload.reasonWhy,
                                                         season: requestPayload.season,
                                                         teamName: requestPayload.teamName,
                                                         teamGender: requestPayload.teamGender,
                                                         badgeStyle: requestPayload.badgeStyle,
                                                         badgeSize: requestPayload.badgeSize)
                try await modelToSave.save(on: req.db)
                guard let savedModel : CoachModel = try? await CoachModel.query(on: req.db).group(.or, { relation in
                    relation.filter(\.$id == coachID)
                }).all().first else { return response }
                guard let responsePayload: CoachPayload = await self.createModelPayloads(coach: savedModel, req: req) else {return response}
                return AnalyticsResponse<N>(statusCode: .ok, data: [responsePayload])
            } else {
                return AnalyticsResponse<N>(statusCode: .notAcceptable, data: nil, errorMessage: "Model already exists in DB!!")
            }
        } catch {
            return AnalyticsResponse<N>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to create model for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    
    @Sendable func deleteByID(req: Vapor.Request) async throws -> AnalyticsResponse<N> {
        
        guard let modelFromRequest : CoachModel = try await CoachModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<N>(statusCode: .notFound, data: nil, errorMessage: "Unabled to find user record!")
        }
        do {
            try await modelFromRequest.delete(on: req.db)
            return AnalyticsResponse<N>(statusCode: .noContent, data: nil)
        } catch {
            return AnalyticsResponse<N>(statusCode: .expectationFailed, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
    @Sendable func updateModel(req: Vapor.Request) async throws -> AnalyticsResponse<N> {
        let response : AnalyticsResponse<N> = AnalyticsResponse<N>(statusCode: .badRequest, data: nil, errorMessage: "Unabled to update user record!")
        guard let requestPayload : N = try? req.content.decode(N.self) else {return response}
        guard let modelFromDB : CoachModel = try await CoachModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<N>(statusCode: .notFound, data: nil, errorMessage: "Unabled to find user record!")
        }
        
        modelFromDB.$user.id = requestPayload.userID
        modelFromDB.name = requestPayload.name
        modelFromDB.lastName = requestPayload.lastName
        modelFromDB.phoneNumber = requestPayload.phoneNumber
        modelFromDB.institutionName = requestPayload.institutionName
        modelFromDB.institutionImageName = requestPayload.institutionImageName
        modelFromDB.leagueName = requestPayload.leagueName
        modelFromDB.leagueDivision = requestPayload.leagueDivision
        modelFromDB.leagueImageName = requestPayload.leagueImageName
        modelFromDB.season = requestPayload.season
        modelFromDB.teamName = requestPayload.teamName
        modelFromDB.teamGender = requestPayload.teamGender
        modelFromDB.isAvailable = requestPayload.isAvailable
        modelFromDB.age = requestPayload.age
        modelFromDB.nationality = requestPayload.nationality
        modelFromDB.profileImageName = requestPayload.profileImageName
        modelFromDB.badgeSize = requestPayload.badgeSize
        modelFromDB.badgeStyle = requestPayload.badgeStyle
        modelFromDB.reasonWhy = requestPayload.reasonWhy
        modelFromDB.coachTitle = requestPayload.coachTitle
        modelFromDB.athleteIDs = requestPayload.athleteIDs
        modelFromDB.createdAt = requestPayload.createdAt
        modelFromDB.updatedAt = .now

        do {
            try await modelFromDB.update(on: req.db)
            return AnalyticsResponse<N>(statusCode: .ok, data: nil)
        } catch {
            return AnalyticsResponse<N>(statusCode: .expectationFailed, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
    @Sendable func searchModels(req: Vapor.Request) async throws -> AnalyticsResponse<N> {

        do {
//            let searchTerm : String = try req.query.get(String.self ,at: "term")
            return try await self.returnAllModels(req: req)
        } catch {
            return AnalyticsResponse<N>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to delete model for the following reasons: Error: " + String(reflecting: error))
        }
    }
}
