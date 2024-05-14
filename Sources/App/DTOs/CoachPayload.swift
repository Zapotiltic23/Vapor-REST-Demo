//
//  CoachPayload.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Vapor

struct CoachPayload: Content {
    
    var id: UUID?
    var userID: UUID
    var athleteIDs: [UUID]
    var name: String
    var lastName: String
    var email: String
    var institutionName: String
    var phoneNumber: String
    var sport: String
    var age: Int?
    var profileImageName: String?
    var nationality: String?
    var institutionImageName: String?
    var leagueName: String
    var leagueDivision: String
    var coachTitle: String
    var isAvailable: Bool
    var season: String
    var teamName: String
    var teamGender: String
    var badgeStyle: String
    var badgeSize: String
    var leagueImageName: String?
    var reasonWhy: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    public init(id: UUID?, userID: UUID, athleteIDs: [UUID], name: String, lastName: String, email: String, institutionName: String, phoneNumber: String, sport: String, age: Int?, profileImageName: String?, nationality: String?, institutionImageName: String?, leagueName: String, leagueDivision: String, coachTitle: String, leagueImageName: String?, isAvailable: Bool, reasonWhy: String?, season: String, teamName: String, teamGender: String, badgeStyle: String, badgeSize: String, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.userID = userID
        self.athleteIDs = athleteIDs
        self.name = name
        self.lastName = lastName
        self.email = email
        self.institutionName = institutionName
        self.phoneNumber = phoneNumber
        self.sport = sport
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
        self.badgeStyle = badgeStyle
        self.badgeSize = badgeSize
    }
}
