struct User: Codable, Identifiable {
    let id: String
    let username: String
    let avatarUrl: String?
    let bio: String?
    let postsCount: Int
    let followersCount: Int
    let followingCount: Int
}