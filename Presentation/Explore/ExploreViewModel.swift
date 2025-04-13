import Foundation

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    func searchPosts() {
        Task {
            isLoading = true
            do {
                posts = try await APIClient.shared.request("/posts/explore?q=\(searchText)")
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
}