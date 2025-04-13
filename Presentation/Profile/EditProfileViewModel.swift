@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var username: String {
        didSet {
            validateUsername()
        }
    }
    @Published var bio: String
    @Published var profileImage: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var usernameError: String?
    
    private func validateUsername() {
        if username.count < 3 {
            usernameError = "Username must be at least 3 characters"
        } else if username.contains(" ") {
            usernameError = "Username cannot contain spaces"
        } else {
            usernameError = nil
        }
    }
    
    func updateProfile() async throws {
        guard usernameError == nil else { return }
        
        var parameters: [String: Any] = [
            "username": username,
            "bio": bio
        ]
        
        if let imageData = profileImage?.jpegData(compressionQuality: 0.8) {
            // Upload image first
            let imageURL: String = try await uploadProfileImage(imageData)
            parameters["avatarUrl"] = imageURL
        }
        
        let updatedUser: User = try await APIClient.shared.request(
            "/profile",
            method: .put,
            body: parameters
        )
        
        // Update local user data
    }
    
    private func uploadProfileImage(_ imageData: Data) async throws -> String {
        // Implement image upload to storage service
        return ""
    }
}