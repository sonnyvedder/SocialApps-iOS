struct Post: Codable, Identifiable {
    let id: String
    let userId: String
    let imageUrl: String
    let caption: String
    let likesCount: Int
    let createdAt: Date
    let user: User
}