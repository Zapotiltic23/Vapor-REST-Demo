//
//  RoutesProtocol.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 2/1/23.
//

import Fluent
import Vapor

protocol RoutesProtocol {
    
    associatedtype A: Content
    
    func createModel(req: Request) async throws -> AnalyticsResponse<A>
    func returnAllModels(req: Request) async throws -> AnalyticsResponse<A>
    func updateModel(req: Request) async throws -> AnalyticsResponse<A>
    func deleteByID(req: Request) async throws -> AnalyticsResponse<A>
    func searchModels(req: Request) async throws -> AnalyticsResponse<A>
}


extension RoutesProtocol {
    
    public func extractAthleteIDs(athletes: [AthleteModel], coachID: UUID) -> [UUID] {
        var athleteIDs: [UUID?] = []
        for athlete in athletes {
            if ((athlete.coachIDs?.contains(coachID)) != nil) {
                athleteIDs.append(athlete.id)
            }
        }
        return athleteIDs.compactMap({$0})
    }
    
    public func retrieveAthletes(models: [CoachModel], req: Request) async -> [AthleteModel] {
        var athletes: [AthleteModel] = []
        for coach in models {
            guard let athlete: [AthleteModel] = try? await coach.$athletes.get(on: req.db) else { return [] }
            athletes.append(contentsOf: athlete)
        }
        return athletes
    }
    
    public func retrieveUserCoaches(model: UserModel, req: Request) async -> [CoachModel] {
        guard let coaches : [CoachModel] = try? await model.$coaches.get(on: req.db) else { return [] }
        return coaches
    }
    
    public func buildAthletePayload(model: UserModel, req: Request) async -> [AthletePayload] {
        guard let athletes : [AthleteModel] = try? await model.$athlete.get(on: req.db) else {return []}
        var payloads : [AthletePayload] = []
        for athlete in athletes {
            guard let coaches : [CoachModel] = try? await athlete.$coaches.get(on: req.db) else {return []}
            guard let drills : [DrillModel] = try? await athlete.$drills.get(on: req.db) else {return []}
            let coachIDs: [UUID] = coaches.map({$0.id}).compactMap({$0})
            let drillIDs: [UUID] = drills.map({$0.id}).compactMap({$0})
            let payload: AthletePayload = AthletePayload(id: athlete.id,
                                                         userID: athlete.$user.id,
                                                         name: athlete.name,
                                                         lastName: athlete.lastName,
                                                         coachIDs: coachIDs,
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
            
            payloads.append(payload)
        }
        return payloads
    }
    
    public func buildAthletePayload(model: CoachModel, req: Request) async -> [AthletePayload] {
        guard let athletes : [AthleteModel] = try? await model.$athletes.get(on: req.db) else {return []}
        var payloads : [AthletePayload] = []
        for athlete in athletes {
            guard let coaches : [CoachModel] = try? await athlete.$coaches.get(on: req.db) else {return []}
            guard let drills : [DrillModel] = try? await athlete.$drills.get(on: req.db) else {return []}
            let drillIDs: [UUID] = drills.map({$0.id}).compactMap({$0})
            let coachIDs: [UUID] = coaches.map({$0.id}).compactMap({$0})
            let payload: AthletePayload = AthletePayload(id: athlete.id,
                                                         userID: athlete.$user.id,
                                                         name: athlete.name,
                                                         lastName: athlete.lastName,
                                                         coachIDs: coachIDs,
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
            
            payloads.append(payload)
        }
        return payloads
    }
    
    public func buildCoachPayload(model: AthleteModel, req: Request) async -> [CoachPayload] {
        guard let coaches : [CoachModel] = try? await model.$coaches.get(on: req.db) else {return []}
        var payloads : [CoachPayload] = []
        for coach in coaches {
            guard let athletes : [AthleteModel] = try? await coach.$athletes.get(on: req.db) else {return []}
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
        return payloads
    }
}
