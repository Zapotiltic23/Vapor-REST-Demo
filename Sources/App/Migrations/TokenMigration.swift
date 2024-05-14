//
//  TokenMigration.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 8/6/23.
//

import Foundation
import Fluent

struct TokenMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.token_schema)
            .id()
            .field(.value, .string, .required)
            .field(.userID, .uuid, .required, .references(Constants.ModelSchema.user_schema, "id"))
            .field(.createdAt, .string)
            .unique(on: .value)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Constants.ModelSchema.token_schema).delete()
    }
}
