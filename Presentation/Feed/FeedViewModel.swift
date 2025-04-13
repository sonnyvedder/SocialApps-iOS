import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchPosts() {
        Task {
            isLoading = true
            do {
                posts = try await APIClient.shared.request("/posts")
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
}