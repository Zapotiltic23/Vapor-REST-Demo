//
//  AthleteController.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Fluent
import Vapor

struct AthleteController: RouteCollection, RoutesProtocol {
    
    typealias N = AthletePayload
    typealias X = UserPayload
    typealias C = CoachPayload
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        
        let tokenAuthorizationAPI = MiddlewareHelper.shaerd.getTokenAuthorizationRoute(routes: routes)

        //http://127.0.0.1:8080/api-v1/athlete
        tokenAuthorizationAPI.get("\(Constants.Routes.athlete_route)", use: self.returnAllModels)
        tokenAuthorizationAPI.post("\(Constants.Routes.athlete_route)", use: self.createModel)
        
        //http://127.0.0.1:8080/api-v1/athlete/search?term=
        tokenAuthorizationAPI.get("\(Constants.Routes.athlete_route)", "\(Constants.Routes.search_route)", use: self.searchModels)
        
        //http://127.0.0.1:8080/api-v1/athlete/ATHLETE_ID
        tokenAuthorizationAPI.delete("\(Constants.Routes.athlete_route)", ":id", use: self.deleteByID)
        tokenAuthorizationAPI.put("\(Constants.Routes.athlete_route)", ":id", use: self.updateModel)
        tokenAuthorizationAPI.get("\(Constants.Routes.user_route)", ":id", use: self.getAthleteWithID)
        
        //http://127.0.0.1:8080/api-v1/athlete/ATHLETE_ID/user
        tokenAuthorizationAPI.get("\(Constants.Routes.athlete_route)", ":id", "\(Constants.Routes.user_route)", use: self.getUser)
        
        //http://127.0.0.1:8080/api-v1/athlete/ATHLETE_ID/coach
        tokenAuthorizationAPI.get("\(Constants.Routes.athlete_route)", ":id", "\(Constants.Routes.coach_route)", use: self.getCoaches)
    }
    
    
    
    //MARK: Coaches....
    
    @Sendable func getCoaches(req: Request) async throws -> AnalyticsResponse<C> {
        
        var response : AnalyticsResponse<C> = AnalyticsResponse<C>(statusCode: .notFound, data: nil, errorMessage: "Model not found!")
        guard let requestModel : AthleteModel = try await AthleteModel.find(req.parameters.get("id"), on: req.db) else { return response }
        let payload: [C] = await self.buildCoachPayload(model: requestModel, req: req)
        response = AnalyticsResponse<C>(statusCode: .ok, data: payload)
        return response
    }
    
    
    
    //MARK: User....
    
    @Sendable func getUser(req: Request) async throws -> AnalyticsResponse<X> {
        
        var response : AnalyticsResponse<X> = AnalyticsResponse<X>(statusCode: .notFound, data: nil, errorMessage: "Model not found!")
        guard let requestModel : AthleteModel = try await AthleteModel.find(req.parameters.get("id"), on: req.db) else { return response }
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
        guard let allModels : [AthleteModel] = try? await AthleteModel.query(on: req.db).all() else {return response}
        var payloads: [N] = []
        for athlete in allModels {
            guard let payload: N = await self.createModelPayloads(athlete: athlete, req: req) else {return response}
            payloads.append(payload)
        }
        response = AnalyticsResponse<N>(statusCode: .ok, data: payloads)
        return response
    }
    
    @Sendable fileprivate func createModelPayloads(athlete: AthleteModel, req: Request) async -> N? {
        guard let drills : [DrillModel] = try? await athlete.$drills.get(on: req.db) else { return nil }
        let drillIDs: [UUID] = drills.map({$0.id}).compactMap({$0})
        let payload: N = AthletePayload(id: athlete.id,
                                        userID: athlete.$user.id,
                                        name: athlete.name,
                                        lastName: athlete.lastName,
                                        coachIDs: athlete.coachIDs ?? [],
                                        drillIDs: drillIDs,
                                        athleteNumber: athlete.athleteNumber,
                                        position: athlete.position,
                                        paceScore: athlete.paceScore,
                                        enduranceScore: athlete.enduranceScore,
                                        passingScore: athlete.passingScore,
                                        dribblingScore: athlete.dribblingScore,
                                        defenseScore: athlete.defenseScore,
                                        physicalScore: athlete.physicalScore,
                                        institutionScore: athlete.institutionScore,
                                        rating: athlete.rating,
                                        institutionName: athlete.institutionName,
                                        clubName: athlete.clubName,
                                        nationality: athlete.nationality,
                                        age: athlete.age,
                                        nickname: athlete.nickname,
                                        profileImageName: athlete.profileImageName,
                                        grade: athlete.grade,
                                        gpa: athlete.gpa,
                                        email: athlete.email,
                                        phoneNumber: athlete.phoneNumber,
                                        sport: athlete.sport,
                                        strenghtScore: athlete.strenghtScore, 
                                        attendanceScore: athlete.attendanceScore,
                                        leagueName: athlete.leagueName,
                                        leagueDivision: athlete.leagueDivision,
                                        isInjured: athlete.isInjured,
                                        leagueImageName: athlete.leagueImageName,
                                        isAvailable: athlete.isAvailable,
                                        isCaptain: athlete.isCaptain,
                                        reasonWhy: athlete.reasonWhy,
                                        season: athlete.season,
                                        teamName: athlete.teamName,
                                        teamGender: athlete.teamGender,
                                        badgeStyle: athlete.badgeStyle,
                                        badgeSize: athlete.badgeSize,
                                        createdAt: athlete.createdAt,
                                        updatedAt: athlete.updatedAt)
        return payload
    }
    
    @Sendable func createModel(req: Request) async throws -> AnalyticsResponse<N> {
        
        let response : AnalyticsResponse<N> = AnalyticsResponse<N>(statusCode: .badRequest, data: nil, errorMessage: "Unable to create record!")
        
        do {
            let requestPayload : AthletePayload = try req.content.decode(AthletePayload.self)
            let lookup : [AthleteModel]? = try? await AthleteModel.query(on: req.db).group(.or, { relation in
                relation.filter(\.$email == requestPayload.email)
            }).all()
            
            if lookup?.count ?? 0 <= 0 {
                let modelID: UUID = UUID()
                let modelToSave: AthleteModel = AthleteModel(id: modelID,
                                                             userID: requestPayload.userID,
                                                             name: requestPayload.name,
                                                             lastName: requestPayload.lastName,
                                                             coachIDs: requestPayload.coachIDs, 
                                                             drillIDs: requestPayload.drillIDs,
                                                             athleteNumber: requestPayload.athleteNumber,
                                                             position: requestPayload.position,
                                                             paceScore: requestPayload.paceScore,
                                                             enduranceScore: requestPayload.enduranceScore,
                                                             passingScore: requestPayload.passingScore,
                                                             dribblingScore: requestPayload.dribblingScore,
                                                             defenseScore: requestPayload.defenseScore,
                                                             physicalScore: requestPayload.physicalScore,
                                                             institutionScore: requestPayload.institutionScore,
                                                             rating: requestPayload.rating,
                                                             institutionName: requestPayload.institutionName,
                                                             clubName: requestPayload.clubName,
                                                             nationality: requestPayload.nationality,
                                                             age: requestPayload.age,
                                                             nickname: requestPayload.nickname,
                                                             profileImageName: requestPayload.profileImageName,
                                                             grade: requestPayload.grade,
                                                             gpa: requestPayload.gpa,
                                                             email: requestPayload.email,
                                                             phoneNumber: requestPayload.phoneNumber,
                                                             sport: requestPayload.sport,
                                                             strenghtScore: requestPayload.strenghtScore,
                                                             attendanceScore: requestPayload.attendanceScore,
                                                             leagueName: requestPayload.leagueName,
                                                             leagueDivision: requestPayload.leagueDivision,
                                                             isInjured: requestPayload.isInjured,
                                                             leagueImageName: requestPayload.leagueImageName,
                                                             isAvailable: requestPayload.isAvailable,
                                                             isCaptain: requestPayload.isCaptain,
                                                             reasonWhy: requestPayload.reasonWhy,
                                                             season: requestPayload.season,
                                                             teamName: requestPayload.teamName,
                                                             teamGender: requestPayload.teamGender,
                                                             badgeStyle: requestPayload.badgeStyle,
                                                             badgeSize: requestPayload.badgeSize,
                                                             createdAt: requestPayload.createdAt,
                                                             updatedAt: requestPayload.updatedAt)
                try await modelToSave.save(on: req.db)
                
                
                guard let savedModel : AthleteModel = try await AthleteModel.find(modelID, on: req.db) else {
                    return AnalyticsResponse<N>(statusCode: .notFound, data: nil, errorMessage: "Unabled to find user record!")
                }
                guard let responsePayload: N = await self.createModelPayloads(athlete: savedModel, req: req) else {return response}
                return AnalyticsResponse<N>(statusCode: .ok, data: [responsePayload])
            } else {
                return AnalyticsResponse<N>(statusCode: .notAcceptable, data: nil, errorMessage: "Model already exists in DB!!")
            }
        } catch {
            return AnalyticsResponse<N>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to create model for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    
    @Sendable func deleteByID(req: Vapor.Request) async throws -> AnalyticsResponse<N> {
        
        guard let modelFromRequest : AthleteModel = try await AthleteModel.find(req.parameters.get("id"), on: req.db) else {
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
        guard let modelFromDB : AthleteModel = try await AthleteModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<N>(statusCode: .notFound, data: nil, errorMessage: "Unabled to find user record!")
        }
        
        modelFromDB.id = requestPayload.id
        modelFromDB.$user.id = requestPayload.userID
        modelFromDB.name = requestPayload.name
        modelFromDB.lastName = requestPayload.lastName
        modelFromDB.coachIDs = requestPayload.coachIDs
        modelFromDB.drillIDs = requestPayload.drillIDs
        modelFromDB.athleteNumber = requestPayload.athleteNumber
        modelFromDB.position = requestPayload.position
        modelFromDB.paceScore = requestPayload.paceScore
        modelFromDB.enduranceScore = requestPayload.enduranceScore
        modelFromDB.passingScore = requestPayload.passingScore
        modelFromDB.dribblingScore = requestPayload.dribblingScore
        modelFromDB.defenseScore = requestPayload.defenseScore
        modelFromDB.physicalScore = requestPayload.physicalScore
        modelFromDB.rating = requestPayload.rating
        modelFromDB.institutionName = requestPayload.institutionName
        modelFromDB.clubName = requestPayload.clubName
        modelFromDB.nationality = requestPayload.nationality
        modelFromDB.age = requestPayload.age
        modelFromDB.nickname = requestPayload.nickname
        modelFromDB.profileImageName = requestPayload.profileImageName
        modelFromDB.institutionScore = requestPayload.institutionScore
        modelFromDB.grade = requestPayload.grade
        modelFromDB.gpa = requestPayload.gpa
        modelFromDB.email = requestPayload.email
        modelFromDB.phoneNumber = requestPayload.phoneNumber
        modelFromDB.sport = requestPayload.sport
        modelFromDB.strenghtScore = requestPayload.strenghtScore
        modelFromDB.attendanceScore = requestPayload.attendanceScore
        modelFromDB.leagueName = requestPayload.leagueName
        modelFromDB.leagueDivision = requestPayload.leagueDivision
        modelFromDB.isInjured = requestPayload.isInjured
        modelFromDB.isAvailable = requestPayload.isAvailable
        modelFromDB.isCaptain = requestPayload.isCaptain
        modelFromDB.reasonWhy = requestPayload.reasonWhy
        modelFromDB.leagueImageName = requestPayload.leagueImageName
        modelFromDB.season = requestPayload.season
        modelFromDB.teamName = requestPayload.teamName
        modelFromDB.teamGender = requestPayload.teamGender
        modelFromDB.badgeSize = requestPayload.badgeSize
        modelFromDB.badgeStyle = requestPayload.badgeStyle
        modelFromDB.createdAt = requestPayload.createdAt
        modelFromDB.updatedAt = .now
        
        do {
            try await modelFromDB.update(on: req.db)
            return AnalyticsResponse<N>(statusCode: .ok, data: nil)
        } catch {
            return AnalyticsResponse<N>(statusCode: .expectationFailed, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
    
    @Sendable func getAthleteWithID(req: Request) async throws -> AnalyticsResponse<N> {
        
        guard let modelFromDB : AthleteModel = try await AthleteModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<N>(statusCode: .notFound, data: nil, errorMessage: "Unable to find model on DB!")
        }
        let payload: N = AthletePayload(id: modelFromDB.id,
                                        userID: modelFromDB.$user.id,
                                        name: modelFromDB.name,
                                        lastName: modelFromDB.lastName,
                                        coachIDs: modelFromDB.coachIDs ?? [],
                                        drillIDs: modelFromDB.drillIDs ?? [],
                                        athleteNumber: modelFromDB.athleteNumber,
                                        position: modelFromDB.position,
                                        paceScore: modelFromDB.paceScore,
                                        enduranceScore: modelFromDB.enduranceScore,
                                        passingScore: modelFromDB.passingScore,
                                        dribblingScore: modelFromDB.dribblingScore,
                                        defenseScore: modelFromDB.defenseScore,
                                        physicalScore: modelFromDB.physicalScore,
                                        institutionScore: modelFromDB.institutionScore,
                                        rating: modelFromDB.rating,
                                        institutionName: modelFromDB.institutionName,
                                        clubName: modelFromDB.clubName,
                                        nationality: modelFromDB.nationality,
                                        age: modelFromDB.age,
                                        nickname: modelFromDB.nickname,
                                        profileImageName: modelFromDB.profileImageName,
                                        grade: modelFromDB.grade,
                                        gpa: modelFromDB.gpa,
                                        email: modelFromDB.email,
                                        phoneNumber: modelFromDB.phoneNumber,
                                        sport: modelFromDB.sport,
                                        strenghtScore: modelFromDB.strenghtScore,
                                        attendanceScore: modelFromDB.attendanceScore,
                                        leagueName: modelFromDB.leagueName,
                                        leagueDivision: modelFromDB.leagueDivision,
                                        isInjured: modelFromDB.isInjured,
                                        leagueImageName: modelFromDB.leagueImageName,
                                        isAvailable: modelFromDB.isAvailable,
                                        isCaptain: modelFromDB.isCaptain,
                                        reasonWhy: modelFromDB.reasonWhy,
                                        season: modelFromDB.season,
                                        teamName: modelFromDB.teamName,
                                        teamGender: modelFromDB.teamGender,
                                        badgeStyle: modelFromDB.badgeStyle,
                                        badgeSize: modelFromDB.badgeSize,
                                        createdAt: modelFromDB.createdAt,
                                        updatedAt: modelFromDB.updatedAt)
        
        return AnalyticsResponse<N>(statusCode: .ok, data: [payload])
    }
    
    
    @Sendable func searchModels(req: Vapor.Request) async throws -> AnalyticsResponse<N> {
        
        let response : AnalyticsResponse<N> = AnalyticsResponse<N>(statusCode: .badRequest, data: nil, errorMessage: "Unable to find model in DB!")
        
        do {
            let searchTerm = try req.query.get(String.self ,at: "term")
            guard let filteredItems : [AthleteModel] = try? await AthleteModel.query(on: req.db).group(.or, { relation in
                relation.filter(\.$email == searchTerm)
                relation.filter(\.$name == searchTerm)
                relation.filter(\.$lastName == searchTerm)
                relation.filter(\.$position == searchTerm)
                relation.filter(\.$sport == searchTerm)
                relation.filter(\.$institutionName == searchTerm)
            }).all() else { return response }
            
            if filteredItems.count > 0 {
                let payloads : [N] = filteredItems.map({AthletePayload(id: $0.id,
                                                                       userID: $0.$user.id,
                                                                       name: $0.name,
                                                                       lastName: $0.lastName,
                                                                       coachIDs: $0.coachIDs ?? [],
                                                                       drillIDs: $0.drillIDs ?? [],
                                                                       athleteNumber: $0.athleteNumber,
                                                                       position: $0.position,
                                                                       paceScore: $0.paceScore,
                                                                       enduranceScore: $0.enduranceScore,
                                                                       passingScore: $0.passingScore,
                                                                       dribblingScore: $0.dribblingScore,
                                                                       defenseScore: $0.defenseScore,
                                                                       physicalScore: $0.physicalScore,
                                                                       institutionScore: $0.institutionScore,
                                                                       rating: $0.rating,
                                                                       institutionName: $0.institutionName,
                                                                       clubName: $0.clubName,
                                                                       nationality: $0.nationality,
                                                                       age: $0.age,
                                                                       nickname: $0.nickname,
                                                                       profileImageName: $0.profileImageName,
                                                                       grade: $0.grade,
                                                                       gpa: $0.gpa,
                                                                       email: $0.email,
                                                                       phoneNumber: $0.phoneNumber,
                                                                       sport: $0.sport,
                                                                       strenghtScore: $0.strenghtScore,
                                                                       attendanceScore: $0.attendanceScore,
                                                                       leagueName: $0.leagueName,
                                                                       leagueDivision: $0.leagueDivision,
                                                                       isInjured: $0.isInjured,
                                                                       leagueImageName: $0.leagueImageName,
                                                                       isAvailable: $0.isAvailable,
                                                                       isCaptain: $0.isCaptain,
                                                                       reasonWhy: $0.reasonWhy,
                                                                       season: $0.season,
                                                                       teamName: $0.teamName,
                                                                       teamGender: $0.teamGender,
                                                                       badgeStyle: $0.badgeStyle,
                                                                       badgeSize: $0.badgeSize,
                                                                       createdAt: $0.createdAt,
                                                                       updatedAt: $0.updatedAt)})
                return AnalyticsResponse<N>(statusCode: .ok, data: payloads)
            }else{
                return response
            }
        } catch {
            return AnalyticsResponse<N>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to delete model for the following reasons: Error: " + String(reflecting: error))
        }
    }
}
