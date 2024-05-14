//
//  Coach.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.

import Foundation
import Fluent
import Vapor

final class CoachModel: Model, Content {
    
    static let schema = Constants.ModelSchema.coach_schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .userID)
    var user: UserModel
    
    @Siblings(
        through: CoachAthletePivot.self,
        from: \.$coach,
        to: \.$athlete)
    var athletes: [AthleteModel]
    
    @Field(key: .name)
    var name: String
    
    @Field(key: .lastName)
    var lastName: String
    
    @Field(key: .email)
    var email: String
    
    @Field(key: .institutionName)
    var institutionName: String
    
    @Field(key: .phoneNumber)
    var phoneNumber: String
    
    @Field(key: .sport)
    var sport: String
    
    @Field(key: .leagueName)
    var leagueName: String
    
    @Field(key: .leagueDivision)
    var leagueDivision: String
    
    @Field(key: .coachTitle)
    var coachTitle: String
    
    @Field(key: .isAvailable)
    var isAvailable: Bool
    
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
    
    @OptionalField(key: .athleteIDs)
    var athleteIDs: [UUID]?
    
    @OptionalField(key: .age)
    var age: Int?
    
    @OptionalField(key: .profileImageName)
    var profileImageName: String?
    
    @OptionalField(key: .leagueImageName)
    var leagueImageName: String?
    
    @OptionalField(key: .reasonWhy)
    var reasonWhy: String?
    
    @OptionalField(key: .nationality)
    var nationality: String?
    
    @OptionalField(key: .institutionImageName)
    var institutionImageName: String?
    
    @Timestamp(key: .createdAt, on: .create, format: .iso8601)
    var createdAt: Date?
    
    @Timestamp(key: .updatedAt, on: .update, format: .iso8601)
    var updatedAt: Date?
    
    public init() {}
    
    public init(id: UUID? = nil, userID: UserModel.IDValue, name: String, lastName: String, email: String, institutionName: String, phoneNumber: String, sport: String, athleteIDs: [UUID]?, age: Int?, profileImageName: String?, nationality: String?, institutionImageName: String?, leagueName: String, leagueDivision: String, coachTitle: String, leagueImageName: String?, isAvailable: Bool, reasonWhy: String?, season: String, teamName: String, teamGender: String, badgeStyle: String, badgeSize: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.$user.id = userID
        self.name = name
        self.lastName = lastName
        self.email = email
        self.institutionName = institutionName
        self.phoneNumber = phoneNumber
        self.sport = sport
        self.athleteIDs = athleteIDs
        self.age = age
        self.profileImageName = profileImageName
        self.nationality = nationality
        self.institutionImageName = institutionImageName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.leagueName = leagueName
        self.leagueDivision = leagueDivision
        self.coachTitle = coachTitle
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
