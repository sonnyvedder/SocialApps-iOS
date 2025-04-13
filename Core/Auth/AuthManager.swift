import Foundation

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private let tokenKey = "auth_token"
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    
    func signIn(username: String, password: String) async throws {
        // Implementation will be added
        isAuthenticated = true
    }
    
    func signOut() {
        token = nil
        isAuthenticated = false
        currentUser = nil
    }
}