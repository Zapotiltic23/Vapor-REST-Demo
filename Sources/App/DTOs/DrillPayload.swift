//
//  DrillPayload.swift
//
//
//  Created by Horacio Alexandro Sanchez on 9/6/23.
//

import Foundation
import Vapor

public struct DrillPayload: Content {
    
    var id: UUID?
    var athleteID: UUID
    var name: String
    var recordedMeasure: Double
    var unitOfMeasure: String
    var drillType: String
    var createdAt: String?
    var updatedAt: Date?
    
    public init(id: UUID? = nil, athleteID: UUID, name: String, recordedMeasure: Double, unitOfMeasure: String, drillType: String, createdAt: String? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.athleteID = athleteID
        self.name = name
        self.recordedMeasure = recordedMeasure
        self.unitOfMeasure = unitOfMeasure
        self.drillType = drillType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
