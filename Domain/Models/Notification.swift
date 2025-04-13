struct Notification: Identifiable, Codable {
    let id: String
    let type: NotificationType
    let userId: String
    let username: String
    let userAvatar: String?
    let postId: String?
    let createdAt: Date
    
    enum NotificationType: String, Codable {
        case like
        case comment
        case follow
    }
}