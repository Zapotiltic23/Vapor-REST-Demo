//
//  CoachAthletePivot.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/27/23.
//

import Fluent
import Foundation

final class CoachAthletePivot: Model {
    
    static let schema = Constants.ModelSchema.coach_athlete_pivot_schema

    @ID var id: UUID?
    
    @Parent(key: .coach)
    var coach: CoachModel
    
    @Parent(key: .athlete)
    var athlete: AthleteModel
    
    public init() {}
    
    public init(id: UUID? = nil, coach: CoachModel, athlete: AthleteModel) throws {
        self.id = id
        self.$coach.id = try coach.requireID()
        self.$athlete.id = try athlete.requireID()
    }
}
