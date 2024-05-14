//
//  AthleteMigration.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Fluent

struct AthleteMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.athlete_schema)
            .id()
            .field(.userID, .uuid, .required, .references(Constants.ModelSchema.user_schema, "id"))
            .field(.athleteNumber, .int32, .required)
            .field(.name, .string, .required)
            .field(.lastName, .string, .required)
            .field(.position, .string, .required)
            .field(.paceScore, .int32, .required)
            .field(.enduranceScore, .int32, .required)
            .field(.passingScore, .int32, .required)
            .field(.dribblingScore, .int32, .required)
            .field(.defenseScore, .int32, .required)
            .field(.physicalScore, .int32, .required)
            .field(.attendanceScore, .int32, .required)
            .field(.strenghtScore, .int32, .required)
            .field(.institutionScore, .int32, .required)
            .field(.sport, .string, .required)
            .field(.rating, .int32, .required)
            .field(.leagueName, .string, .required)
            .field(.leagueDivision, .string, .required)
            .field(.isCaptain, .bool, .required)
            .field(.isInjured, .bool, .required)
            .field(.isAvailable, .bool, .required)
            .field(.season, .string, .required)
            .field(.teamName, .string, .required)
            .field(.teamGender, .string, .required)
            .field(.badgeStyle, .string, .required)
            .field(.badgeSize, .string, .required)
            .field(.reasonWhy, .string)
            .field(.leagueImageName, .string)
            .field(.email, .string)
            .field(.phoneNumber, .string)
            .field(.coachIDs, .array(of: .uuid))
            .field(.drillIDs, .array(of: .uuid))
            .field(.age, .int32)
            .field(.nickname, .string)
            .field(.grade, .string)
            .field(.profileImageName, .string)
            .field(.gpa, .double)
            .field(.institutionName, .string)
            .field(.nationality, .string)
            .field(.clubName, .string)
            .field(.createdAt, .string)
            .field(.updatedAt, .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.athlete_schema).delete()
    }
}
