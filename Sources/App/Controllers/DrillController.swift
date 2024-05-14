//
//  DrillController.swift
//
//
//  Created by Horacio Alexandro Sanchez on 9/7/23.
//

import Foundation
import Fluent
import Vapor

struct DrillController: RouteCollection, RoutesProtocol {
    
    typealias N = DrillPayload
    typealias X = UserPayload
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        
        let tokenAuthorizationAPI = MiddlewareHelper.shaerd.getTokenAuthorizationRoute(routes: routes)
        
        //http://127.0.0.1:8080/api-v1/drill
        tokenAuthorizationAPI.get("\(Constants.Routes.drill_route)", use: self.returnAllModels)
        tokenAuthorizationAPI.post("\(Constants.Routes.drill_route)", use: self.createModel)
        
        //http://127.0.0.1:8080/api-v1/drill/search?term=
        tokenAuthorizationAPI.get("\(Constants.Routes.drill_route)", "\(Constants.Routes.search_route)", use: self.searchModels)
        
        //http://127.0.0.1:8080/api-v1/drill/DRILL_ID
        tokenAuthorizationAPI.delete("\(Constants.Routes.drill_route)", ":id", use: self.deleteByID)
        tokenAuthorizationAPI.put("\(Constants.Routes.drill_route)", ":id", use: self.updateModel)
        
        //http://127.0.0.1:8080/api-v1/drill/DRILL_ID/user
//        tokenAuthorizationAPI.get("\(Constants.Routes.drill_route)", ":id", "\(Constants.Routes.athlete_route)", use: self.getUser)
    }
    
    //MARK: User....
    
//    func getUser(req: Request) async throws -> AnalyticsResponse<X> {
//        
//        var response : AnalyticsResponse<X> = AnalyticsResponse<X>(statusCode: .notFound, data: nil, errorMessage: "User not found!")
//        guard let requestModel : CoachModel = try await CoachModel.find(req.parameters.get("id"), on: req.db) else { return response }
//        guard let modelFromDB : UserModel = try? await requestModel.$user.get(on: req.db) else { return response }
//        let userPayload: UserPayload = UserPayload(id: modelFromDB.id,
//                                                   name: modelFromDB.name,
//                                                   lastName: modelFromDB.lastName,
//                                                   email: modelFromDB.email,
//                                                   password: nil,
//                                                   confirmPassword: nil,
//                                                   userRole: modelFromDB.userRole,
//                                                   createdAt: modelFromDB.createdAt,
//                                                   updatedAt: modelFromDB.updatedAt)
//        response = AnalyticsResponse<X>(statusCode: .ok, data: [userPayload])
//        return response
//    }
    
    
    //MARK: Protocol Requirements....
    
    @Sendable func returnAllModels(req: Vapor.Request) async throws -> AnalyticsResponse<N> {
        
        var response : AnalyticsResponse<N> = AnalyticsResponse(statusCode: .notFound, data: nil, errorMessage: "Your request is invalid!")
        do {
            let allModels : [DrillModel] = try await DrillModel.query(on: req.db).all()
            var payloads: [N] = []
            for model in allModels {
                let payload: N = DrillPayload(id: model.id,
                                              athleteID: model.$athlete.id,
                                              name: model.name,
                                              recordedMeasure: model.recordedMeasure,
                                              unitOfMeasure: model.unitOfMeasure,
                                              drillType: model.drillType,
                                              createdAt: model.createdAt,
                                              updatedAt: model.updatedAt)
                payloads.append(payload)
            }
            response = AnalyticsResponse<N>(statusCode: .ok, data: payloads)
            return response
        } catch {
            return AnalyticsResponse<N>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to create model for the following reasons: Error: " + String(reflecting: error))

        }
        
    }
    
    @Sendable fileprivate func createModelPayloads(model: DrillModel, req: Vapor.Request) async -> N? {
        let payload: N = DrillPayload(id: model.id,
                                      athleteID: model.$athlete.id,
                                      name: model.name,
                                      recordedMeasure: model.recordedMeasure,
                                      unitOfMeasure: model.unitOfMeasure,
                                      drillType: model.drillType,
                                      createdAt: model.createdAt,
                                      updatedAt: model.updatedAt)
        return payload
    }
    
    @Sendable func createModel(req: Request) async throws -> AnalyticsResponse<N> {
        
        let response : AnalyticsResponse<N> = AnalyticsResponse<N>(statusCode: .badRequest, data: nil, errorMessage: "Unable to create record!")
        
        do {
            let requestPayload : DrillPayload = try req.content.decode(DrillPayload.self)
            let modelID: UUID = UUID()
            let modelToSave: DrillModel = DrillModel(id: modelID,
                                                     athleteID: requestPayload.athleteID,
                                                     name: requestPayload.name,
                                                     recordedMeasure: requestPayload.recordedMeasure,
                                                     unitOfMeasure: requestPayload.unitOfMeasure,
                                                     drillType: requestPayload.drillType,
                                                     createdAt: requestPayload.createdAt,
                                                     updatedAt: requestPayload.updatedAt)
            
            try await modelToSave.save(on: req.db)
            guard let savedModel : DrillModel = try? await DrillModel.query(on: req.db).group(.or, { relation in
                relation.filter(\.$id == modelID)
            }).all().first else { return response }
            guard let responsePayload: N = await self.createModelPayloads(model: savedModel, req: req) else {return response}
            return AnalyticsResponse<N>(statusCode: .ok, data: [responsePayload])
        } catch {
            return AnalyticsResponse<N>(statusCode: .internalServerError, data: nil, errorMessage: "Unabled to create model for the following reasons: Error: " + String(reflecting: error))
        }
    }
    
    
    @Sendable func deleteByID(req: Vapor.Request) async throws -> AnalyticsResponse<N> {
        
        guard let modelFromRequest : DrillModel = try await DrillModel.find(req.parameters.get("id"), on: req.db) else {
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
        guard let modelFromDB : DrillModel = try await DrillModel.find(req.parameters.get("id"), on: req.db) else {
            return AnalyticsResponse<N>(statusCode: .notFound, data: nil, errorMessage: "Unabled to find user record!")
        }
        
        modelFromDB.$athlete.id = requestPayload.athleteID
        modelFromDB.name = requestPayload.name
        modelFromDB.recordedMeasure = requestPayload.recordedMeasure
        modelFromDB.unitOfMeasure = requestPayload.unitOfMeasure
        modelFromDB.drillType = requestPayload.drillType
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
