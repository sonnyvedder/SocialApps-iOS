@MainActor
class PostInteractionViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLiked = false
    @Published var likesCount = 0
    @Published var showCommentSheet = false
    @Published var newComment = ""
    
    func toggleLike(for postId: String) async {
        isLiked.toggle()
        likesCount += isLiked ? 1 : -1
        
        do {
            let endpoint = "/posts/\(postId)/like"
            let method: HTTPMethod = isLiked ? .post : .delete
            try await APIClient.shared.request(endpoint, method: method)
        } catch {
            // Revert on failure
            isLiked.toggle()
            likesCount -= isLiked ? 1 : -1
        }
    }
    
    func addComment(to postId: String) async throws {
        guard !newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let comment: Comment = try await APIClient.shared.request(
            "/posts/\(postId)/comments",
            method: .post,
            body: ["text": newComment]
        )
        
        comments.append(comment)
        newComment = ""
    }
}