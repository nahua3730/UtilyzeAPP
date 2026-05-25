import Foundation

struct StartEmailCodeResponse: Decodable {
    let requestId: String
}

struct VerifyEmailCodeResponse: Decodable {
    let sessionToken: String
    let userId: String
    let username: String
}

struct AlertsFeedResponse: Decodable {
    let alerts: [AlertItem]
}

struct PublishDemoAlertResponse: Decodable {
    let alert: AlertItem
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = "http://10.0.0.236:3000"

    func startEmailCode(email: String) async throws -> String {
        let payload = ["email": email]
        let response: StartEmailCodeResponse = try await post(
            path: "/v1/wallet/start-email-code",
            body: payload
        )
        return response.requestId
    }

    func verifyEmailCode(
        email: String,
        requestId: String,
        code: String,
        username: String
    ) async throws -> VerifyEmailCodeResponse {
        let payload = [
            "email": email,
            "requestId": requestId,
            "code": code,
            "username": username
        ]

        return try await post(
            path: "/v1/wallet/verify-email-code",
            body: payload
        )
    }

    func fetchAlerts(username: String) async throws -> [AlertItem] {
        let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? username
        let url = URL(string: "\(baseURL)/v1/alerts/feed?username=\(encodedUsername)")!

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(AlertsFeedResponse.self, from: data)
        return decoded.alerts
    }

    func publishDemoAlert() async throws -> AlertItem {
        let payload = [
            "severity": "High",
            "title": "Demo water leak alert",
            "bodyShort": "Possible leak detected from the Utilyze test flow",
            "bodyLong": "This is a demo alert created by the backend so you can test the Utilyze feed and notification experience without waiting on the HandCash wallet API.",
            "dataSummary": "{\n  \"rule\": \"demo_notification\",\n  \"source\": \"backend_test_button\"\n}"
        ]

        let response: PublishDemoAlertResponse = try await post(
            path: "/v1/demo/alerts",
            body: payload
        )
        return response.alert
    }

    private func post<Response: Decodable, Body: Encodable>(
        path: String,
        body: Body
    ) async throws -> Response {
        let url = URL(string: "\(baseURL)\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Response.self, from: data)
    }
}
