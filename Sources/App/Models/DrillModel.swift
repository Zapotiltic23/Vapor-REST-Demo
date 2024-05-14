//
//  DrillModel.swift
//
//
//  Created by Horacio Alexandro Sanchez on 9/6/23.
//

import Foundation
import Fluent
import Vapor

final class DrillModel: Model, Content {
    
    static let schema = Constants.ModelSchema.drill_schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .athleteID)
    var athlete: AthleteModel
    
    @Field(key: .name)
    var name: String
        
    @Field(key: .recordedMeasure)
    var recordedMeasure: Double
    
    @Field(key: .unitOfMeasure)
    var unitOfMeasure: String
    
    @Field(key: .drillType)
    var drillType: String
    
    @Field(key: .createdAt)
    var createdAt: String?
    
    @Timestamp(key: .updatedAt, on: .update, format: .iso8601)
    var updatedAt: Date?
    
    public init() {}
    
    public init(id: UUID?, athleteID: AthleteModel.IDValue, name: String, recordedMeasure: Double, unitOfMeasure: String, drillType: String, createdAt: String? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.$athlete.id = athleteID
        self.name = name
        self.recordedMeasure = recordedMeasure
        self.unitOfMeasure = unitOfMeasure
        self.drillType = drillType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }   
}

