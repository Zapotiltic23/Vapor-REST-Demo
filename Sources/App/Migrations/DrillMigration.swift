//
//  DrillMigration.swift
//
//
//  Created by Horacio Alexandro Sanchez on 9/6/23.
//

import Foundation
import Fluent

struct DrillMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.drill_schema)
            .id()
            .field(.athleteID, .uuid, .required, .references(Constants.ModelSchema.athlete_schema, "id"))
            .field(.name, .string, .required)
            .field(.recordedMeasure, .double, .required)
            .field(.unitOfMeasure, .string, .required)
            .field(.drillType, .string, .required)
            .field(.createdAt, .string, .required)
            .field(.updatedAt, .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.drill_schema).delete()
    }
}
