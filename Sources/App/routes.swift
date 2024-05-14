import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UserController())
    try app.register(collection: AuthenticationController())
    try app.register(collection: TokenController())
    try app.register(collection: CoachController())
    try app.register(collection: AthleteController())
    try app.register(collection: DrillController())
}
