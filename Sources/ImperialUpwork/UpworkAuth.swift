import Vapor

struct UpworkAuth: FederatedServiceTokens {
    static let idEnvKey: String = "UPWORK_CLIENT_ID"
    static let secretEnvKey: String = "UPWORK_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
        guard let clientID = Environment.get(UpworkAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(UpworkAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(UpworkAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(UpworkAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
