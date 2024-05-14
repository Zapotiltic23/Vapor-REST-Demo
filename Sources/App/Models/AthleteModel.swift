//
//  AthleteModel.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Fluent
import Vapor

final class AthleteModel: Model, Content {
    
    static let schema = Constants.ModelSchema.athlete_schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .userID)
    var user: UserModel
    
    @Siblings(
        through: CoachAthletePivot.self,
        from: \.$athlete,
        to: \.$coach)
    var coaches: [CoachModel]
    
    @Children(for: \.$athlete)
    var drills: [DrillModel]
    
    @Field(key: .name)
    var name: String
    
    @Field(key: .lastName)
    var lastName: String
        
    @Field(key: .athleteNumber)
    var athleteNumber: Int
    
    @Field(key: .position)
    var position: String
    
    @Field(key: .paceScore)
    var paceScore: Int
    
    @Field(key: .enduranceScore)
    var enduranceScore: Int
    
    @Field(key: .passingScore)
    var passingScore: Int
    
    @Field(key: .dribblingScore)
    var dribblingScore: Int
    
    @Field(key: .defenseScore)
    var defenseScore: Int
    
    @Field(key: .physicalScore)
    var physicalScore: Int
    
    @Field(key: .strenghtScore)
    var strenghtScore: Int
    
    @Field(key: .attendanceScore)
    var attendanceScore: Int
    
    @Field(key: .institutionScore)
    var institutionScore: Int
    
    @Field(key: .rating)
    var rating: Int
    
    @Field(key: .sport)
    var sport: String
    
    @Field(key: .leagueName)
    var leagueName: String
    
    @Field(key: .leagueDivision)
    var leagueDivision: String
    
    @Field(key: .isAvailable)
    var isAvailable: Bool
    
    @Field(key: .isCaptain)
    var isCaptain: Bool
    
    @Field(key: .isInjured)
    var isInjured: Bool
    
    @Field(key: .season)
    var season: String
    
    @Field(key: .teamName)
    var teamName: String
    
    @Field(key: .teamGender)
    var teamGender: String
    
    @Field(key: .badgeStyle)
    var badgeStyle: String
    
    @Field(key: .badgeSize)
    var badgeSize: String
    
    @OptionalField(key: .leagueImageName)
    var leagueImageName: String?
    
    @OptionalField(key: .reasonWhy)
    var reasonWhy: String?
    
    @OptionalField(key: .coachIDs)
    var coachIDs: [UUID]?
    
    @OptionalField(key: .drillIDs)
    var drillIDs: [UUID]?
    
    @OptionalField(key: .institutionName)
    var institutionName: String?
    
    @OptionalField(key: .clubName)
    var clubName: String?
    
    @OptionalField(key: .nationality)
    var nationality: String?
    
    @OptionalField(key: .age)
    var age: Int?
    
    @OptionalField(key: .nickname)
    var nickname: String?
    
    @OptionalField(key: .profileImageName)
    var profileImageName: String?
    
    @OptionalField(key: .grade)
    var grade: String?
    
    @OptionalField(key: .gpa)
    var gpa: Double?
    
    @OptionalField(key: .email)
    var email: String?
    
    @OptionalField(key: .phoneNumber)
    var phoneNumber: String?
    
    @Timestamp(key: .createdAt, on: .create, format: .iso8601)
    var createdAt: Date?
    
    @Timestamp(key: .updatedAt, on: .update, format: .iso8601)
    var updatedAt: Date?
    
    public init() {}
    
    public init(id: UUID?, userID: UserModel.IDValue, name: String, lastName: String, coachIDs: [UUID]?, drillIDs: [UUID]?, athleteNumber: Int, position: String, paceScore: Int, enduranceScore: Int, passingScore: Int, dribblingScore: Int, defenseScore: Int, physicalScore: Int, institutionScore: Int, rating: Int, institutionName: String?, clubName: String?, nationality: String?, age: Int?, nickname: String?, profileImageName: String?, grade: String?, gpa: Double?, email: String?, phoneNumber: String?, sport: String, strenghtScore: Int, attendanceScore: Int, leagueName: String, leagueDivision: String, isInjured: Bool, leagueImageName: String?, isAvailable: Bool, isCaptain: Bool, reasonWhy: String?, season: String, teamName: String, teamGender: String, badgeStyle: String, badgeSize: String, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.$user.id = userID
        self.coachIDs = coachIDs
        self.drillIDs = drillIDs
        self.name = name
        self.lastName = lastName
        self.athleteNumber = athleteNumber
        self.position = position
        self.paceScore = paceScore
        self.enduranceScore = enduranceScore
        self.passingScore = passingScore
        self.dribblingScore = dribblingScore
        self.defenseScore = defenseScore
        self.physicalScore = physicalScore
        self.attendanceScore = attendanceScore
        self.strenghtScore = strenghtScore
        self.institutionScore = institutionScore
        self.rating = rating
        self.institutionName = institutionName
        self.clubName = clubName
        self.nationality = nationality
        self.age = age
        self.nickname = nickname
        self.profileImageName = profileImageName
        self.grade = grade
        self.gpa = gpa
        self.email = email
        self.phoneNumber = phoneNumber
        self.sport = sport
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.leagueName = leagueName
        self.leagueDivision = leagueDivision
        self.isCaptain = isCaptain
        self.isInjured = isInjured
        self.leagueImageName = leagueImageName
        self.isAvailable = isAvailable
        self.reasonWhy = reasonWhy
        self.season = season
        self.teamName = teamName
        self.teamGender = teamGender
        self.badgeSize = badgeSize
        self.badgeStyle = badgeStyle
    }
}
