//
//  Enums.swift
//
//
//  Created by Horacio Alexandro Sanchez on 8/5/23.
//

import Foundation


public enum UserRole: String, Codable, Sendable {
    case admin = "admin"
    case coach = "coach"
    case athlete = "athlete"
    case unknown = "unknown"
}

public enum MeasurementUnits: String, Codable {
    case milliseconds = "milliseconds"
    case seconds = "seconds"
    case minutes = "minutes"
    case hours = "hours"
    case unknown = "unknown"
}

enum DateFormats: String {
    
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case dateTime = "yyyy/MM/dd HH:mm:ss"
    case dateYear = "dd/MM/yyyy"
    
    // Helper function to format a Date as a String
    func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter.string(from: date)
    }
    
    // Helper function to parse a String into a Date
    func date(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter.date(from: string) ?? .now
    }
}
