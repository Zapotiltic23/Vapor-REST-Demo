//
//  AthletePayload.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Vapor

public struct AthletePayload: Content {
    
    var id: UUID?
    var userID: UUID
    var coachIDs: [UUID]
    var drillIDs: [UUID]
    var name: String
    var lastName: String
    var athleteNumber: Int
    var position: String
    var paceScore: Int
    var enduranceScore: Int
    var passingScore: Int
    var dribblingScore: Int
    var defenseScore: Int
    var physicalScore: Int
    var strenghtScore: Int
    var attendanceScore: Int
    var institutionScore: Int
    var rating: Int
    var sport: String
    var leagueName: String
    var leagueDivision: String
    var isAvailable: Bool
    var isCaptain: Bool
    var isInjured: Bool
    var season: String
    var teamName: String
    var teamGender: String
    var badgeStyle: String
    var badgeSize: String
    var institutionName: String?
    var clubName: String?
    var nationality: String?
    var age: Int?
    var nickname: String?
    var profileImageName: String?
    var grade: String?
    var gpa: Double?
    var email: String?
    var phoneNumber: String?
    var leagueImageName: String?
    var reasonWhy: String?
    var createdAt: Date?
    var updatedAt: Date?
        
    public init(id: UUID? = nil, userID: UUID, name: String, lastName: String, coachIDs: [UUID], drillIDs: [UUID], athleteNumber: Int, position: String, paceScore: Int, enduranceScore: Int, passingScore: Int, dribblingScore: Int, defenseScore: Int, physicalScore: Int, institutionScore: Int, rating: Int, institutionName: String?, clubName: String?, nationality: String?, age: Int?, nickname: String?, profileImageName: String?, grade: String?, gpa: Double?, email: String?, phoneNumber: String?, sport: String, strenghtScore: Int, attendanceScore: Int, leagueName: String, leagueDivision: String, isInjured: Bool, leagueImageName: String?, isAvailable: Bool, isCaptain: Bool, reasonWhy: String?, season: String, teamName: String, teamGender: String, badgeStyle: String, badgeSize: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.userID = userID
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
        self.isInjured = isCaptain
        self.leagueImageName = leagueImageName
        self.isAvailable = isAvailable
        self.reasonWhy = reasonWhy
        self.season = season
        self.teamName = teamName
        self.teamGender = teamGender
        self.badgeSize = badgeSize
        self.badgeStyle = badgeStyle
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
