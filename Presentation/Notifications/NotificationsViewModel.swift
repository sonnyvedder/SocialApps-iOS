@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchNotifications() {
        Task {
            isLoading = true
            do {
                notifications = try await APIClient.shared.request("/notifications")
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
}