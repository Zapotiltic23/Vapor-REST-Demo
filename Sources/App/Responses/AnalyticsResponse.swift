//
//  AnalyticsResponse.swift
//  
//
//  Created by Horacio Alexandro Sanchez on 1/30/23.
//

import Fluent
import Vapor

final class AnalyticsResponse<M: Content>: Content, AsyncResponseEncodable, Sendable {
     
    var data: [M]?
    var statusCode: HTTPStatus
    var errorMessage: String?
    var dateOrigin: Date
    
    init (statusCode: HTTPStatus, dateOrigin: Date = .now, data: [M]? = nil, errorMessage: String? = nil) {
        self.statusCode = statusCode
        self.errorMessage = errorMessage
        self.dateOrigin = dateOrigin
        self.data = data
    }
    
    func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        let response = Response()
        try response.content.encode(self)
        return response
    }
}
