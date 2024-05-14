//
//  Extensions.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 7/23/23.
//

import Foundation
import Fluent
import Vapor

extension UserModel: Authenticatable {}

extension UserModel: ModelAuthenticatable {
    static let usernameKey = \UserModel.$email
    static let passwordHashKey = \UserModel.$passwordHash
    public func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension FieldKey {
    
    static var userID: Self { "userID" }
    static var coachID: Self { "coach_id" }
    static var name: Self { "name" }
    static var lastName: Self { "last_name" }
    static var userName: Self { "user_name" }
    static var userRole: Self { "user_role" }
    static var profileImage: Self { "profile_image" }
    static var createdAt: Self { "created_at" }
    static var updatedAt: Self { "updated_at" }
    static var coach: Self { "coach" }
    static var athlete: Self { "athlete" }
    static var athleteID: Self { "athlete_id" }
    static var coachIDs: Self { "coach_ids" }
    static var athleteIDs: Self { "athlete_ids" }
    static var sport: Self { "sport" }
    static var dateOfBirth: Self { "dob" }
    static var leagueName: Self { "league_name" }
    static var leagueDivision: Self { "league_division" }
    static var coachTitle: Self { "coach_title" }
    static var leagueImageName: Self { "league_image_name" }
    static var isAvailable: Self { "is_available" }
    static var isInjured: Self { "is_injured" }
    static var isCaptain: Self { "is_captain" }
    static var reasonWhy: Self { "reason_why" }
    static var season: Self { "season" }
    static var teamName: Self { "team_name" }
    static var teamGender: Self { "team_gender" }
    static var badgeStyle: Self { "badge_style" }
    static var badgeSize: Self { "badge_size" }

    
    static var athleteNumber: Self { "athlete_number" }
    static var position: Self { "position" }
    static var institutionName: Self { "institution_name" }
    static var institutionImageName: Self { "institution_image_name" }
    static var clubName: Self { "club_name" }
    static var clubImageName: Self { "club_image_name" }
    static var nationality: Self { "nationality" }
    static var paceScore: Self { "pace_score" }
    static var enduranceScore: Self { "endurance_score" }
    static var passingScore: Self { "passing_score" }
    static var dribblingScore: Self { "dribbling_score" }
    static var defenseScore: Self { "defense_score" }
    static var physicalScore: Self { "physical_score" }
    static var strenghtScore: Self { "strenght_score" }
    static var attendanceScore: Self { "attendance_score" }
    static var institutionScore: Self { "institution_score" }

    static var rating: Self { "rating" }
    static var age: Self { "age" }
    static var nickname: Self { "nickname" }
    static var grade: Self { "grade" }
    static var profileImageName: Self { "profileImageName" }
    static var gpa: Self { "gpa" }
    static var value: Self { "value" }
    static var recordedMeasure: Self { "recorded_measure" }
    static var unitOfMeasure: Self { "unit_of_measure" }
    static var drillIDs: Self { "drill_ids" }
    static var drillType: Self { "drill_type" }

    
    static var streetNumber: Self { "street_number" }
    static var streetName: Self { "street_name" }
    static var city: Self { "city" }
    static var zipCode: Self { "zip_code" }
    static var state: Self { "state" }
    
    static var phoneNumber: Self { "phone_number" }
    static var email: Self { "email" }
    static var websiteUrl: Self { "website_url" }
    static var socialMedia: Self { "social_media" }
    
    static var passwordHash: Self { "password_hash" } 
}
