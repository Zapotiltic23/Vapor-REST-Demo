//
//  Constants.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 7/23/23.
//

import Foundation

struct Constants {
    
    struct ModelSchema {
        static let user_schema : String = "user"
        static let coach_schema : String = "coach"
        static let athlete_schema : String = "athlete"
        static let token_schema : String = "token"
        static let drill_schema : String = "drill"
        static let coach_athlete_pivot_schema : String = "coach_athlete_pivot_schema"
    }
    
    struct Routes {
        static let api_route : String = "api-v1"
        static let user_route : String = "user"
        static let coach_route : String = "coach"
        static let athlete_route : String = "athlete"
        static let drill_route : String = "drill"
        static let login_route : String = "login"
        static let token_route : String = "token"
        static let authentication_route : String = "authentication"
        static let search_route : String = "search"
    }
}
