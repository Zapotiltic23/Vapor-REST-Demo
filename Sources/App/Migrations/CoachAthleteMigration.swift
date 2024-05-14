//
//  CoachAthleteMigration.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Foundation
import Fluent

struct CoachAthleteMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.coach_athlete_pivot_schema)
            .id()
            .field(.coach, .uuid, .required, .references(Constants.ModelSchema.coach_schema, "id", onDelete: .cascade))
            .field(.athlete, .uuid, .required, .references(Constants.ModelSchema.athlete_schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.coach_athlete_pivot_schema).delete()
    }
}
