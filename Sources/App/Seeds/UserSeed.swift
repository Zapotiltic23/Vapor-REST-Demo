//
//  UserSeed.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 8/5/23.
//

import Foundation
import Vapor
import Fluent

struct UserSeed: AsyncMigration {
    func prepare(on database: Database) async throws {
        
        let adminID: UUID = UUID()
        let coachID: UUID = UUID()
        let athleteID: UUID = UUID()
        let adminUser: UserModel = UserModel(id: adminID,
                                             name: "Alexandro",
                                             lastName: "Sanchez",
                                             email: "horacio@matrixnumerics.com",
                                             passwordHash: try Bcrypt.hash("Password@1"),
                                             userRole: UserRole.admin.rawValue, dateOfBirth: DateFormats.iso8601.string(from: .now))
        
        let coachUser: UserModel = UserModel(id: coachID,
                                             name: "Ulises",
                                             lastName: "Gonzalez",
                                             email: "ulises@matrixnumerics.com",
                                             passwordHash: try Bcrypt.hash("Password@2"),
                                             userRole: UserRole.coach.rawValue, dateOfBirth: DateFormats.iso8601.string(from: .now))
        
        let athleteUser: UserModel = UserModel(id: athleteID,
                                               name: "Athlete",
                                               lastName: "Student",
                                               email: "athlete@matrixnumerics.com",
                                               passwordHash: try Bcrypt.hash("Password@3"),
                                               userRole: UserRole.athlete.rawValue, dateOfBirth: DateFormats.iso8601.string(from: .now))
        
        try await adminUser.create(on: database)
        try await coachUser.create(on: database)
        try await athleteUser.create(on: database)
    }
    
    func revert(on database: Database) async throws {
        try await UserModel.query(on: database).delete()
    }
}
