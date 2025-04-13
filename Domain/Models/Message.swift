struct Message: Identifiable, Codable {
    let id: String
    let senderId: String
    let receiverId: String
    let text: String
    let createdAt: Date
}