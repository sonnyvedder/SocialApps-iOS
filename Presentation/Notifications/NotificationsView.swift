import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notifications) { notification in
                    NotificationCell(notification: notification)
                }
            }
            .navigationTitle("Activity")
            .refreshable {
                viewModel.fetchNotifications()
            }
        }
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
}

struct NotificationCell: View {
    let notification: Notification
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: notification.userAvatar ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.username)
                        .fontWeight(.semibold)
                    
                    Text(notificationText(for: notification.type))
                        .foregroundColor(.secondary)
                }
                
                Text(timeAgo(from: notification.createdAt))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if notification.type != .follow {
                AsyncImage(url: URL(string: "post_thumbnail_url")) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 44, height: 44)
                .cornerRadius(6)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func notificationText(for type: Notification.NotificationType) -> String {
        switch type {
        case .like:
            return "liked your post"
        case .comment:
            return "commented on your post"
        case .follow:
            return "started following you"
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        // Implement time ago logic
        return "2h ago"
    }
}