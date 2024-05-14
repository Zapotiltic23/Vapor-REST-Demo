//
//  CoachMigration.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Fluent

struct CoachMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.coach_schema)
            .id()
            .field(.userID, .uuid, .required, .references(Constants.ModelSchema.user_schema, "id"))
            .field(.name, .string, .required)
            .field(.lastName, .string, .required)
            .field(.email, .string, .required)
            .field(.phoneNumber, .string, .required)
            .field(.institutionName, .string, .required)
            .field(.sport, .string, .required)
            .field(.leagueName, .string, .required)
            .field(.leagueDivision, .string, .required)
            .field(.coachTitle, .string, .required)
            .field(.isAvailable, .bool, .required)
            .field(.season, .string, .required)
            .field(.teamName, .string, .required)
            .field(.teamGender, .string, .required)
            .field(.badgeStyle, .string, .required)
            .field(.badgeSize, .string, .required)
            .field(.reasonWhy, .string)
            .field(.leagueImageName, .string)
            .field(.athleteIDs, .array(of: .uuid))
            .field(.age, .int32)
            .field(.profileImageName, .string)
            .field(.nationality, .string)
            .field(.institutionImageName, .string)
            .field(.createdAt, .string)
            .field(.updatedAt, .string)
            .unique(on: .email)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.coach_schema).delete()
    }
}
