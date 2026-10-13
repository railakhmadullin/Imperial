import Foundation
import Vapor

struct UpworkRouter: FederatedServiceRouter {
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    let scope: [String]
    let callbackURL: String
    let accessTokenURL: String = "https://www.upwork.com/api/v3/oauth2/token"
    let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try UpworkAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.upwork.com"
        components.path = "/ab/account-security/oauth2/authorize"
        components.queryItems = [
            codeResponseTypeItem,
            clientIDItem,
            redirectURIItem
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        return "grant_type=authorization_code&client_id=\(tokens.clientID)&client_secret=\(tokens.clientSecret)&code=\(code)&redirect_uri=\(callbackURL)"
    }
}
