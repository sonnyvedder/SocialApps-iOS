import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 3)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ProfileHeaderView(user: viewModel.user)
                    
                    ProfileStatsView(user: viewModel.user)
                    
                    Button(action: { viewModel.showEditProfile = true }) {
                        Text("Edit Profile")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(viewModel.posts) { post in
                            NavigationLink(destination: PostDetailView(post: post)) {
                                AsyncImage(url: URL(string: post.imageUrl)) { image in
                                    image.resizable()
                                        .aspectRatio(1, contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $viewModel.showEditProfile) {
                EditProfileView(user: viewModel.user)
            }
        }
        .onAppear {
            viewModel.fetchProfile()
        }
    }
}

struct ProfileHeaderView: View {
    let user: User?
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user?.username ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user?.bio ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ProfileStatsView: View {
    let user: User?
    
    var body: some View {
        HStack(spacing: 30) {
            StatItem(number: user?.postsCount ?? 0, label: "Posts")
            StatItem(number: user?.followersCount ?? 0, label: "Followers")
            StatItem(number: user?.followingCount ?? 0, label: "Following")
        }
        .padding(.horizontal)
    }
}

struct StatItem: View {
    let number: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(number)")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}