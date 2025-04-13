@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showEditProfile = false
    
    func fetchProfile() {
        Task {
            isLoading = true
            do {
                user = try await APIClient.shared.request("/profile")
                posts = try await APIClient.shared.request("/profile/posts")
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
}