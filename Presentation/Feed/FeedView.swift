import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(viewModel.posts) { post in
                        PostCard(post: post)
                    }
                }
                .padding()
            }
            .navigationTitle("Feed")
            .refreshable {
                await viewModel.fetchPosts()
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}

struct PostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User header
            HStack {
                AsyncImage(url: URL(string: post.user.avatarUrl ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(post.user.username)
                        .font(.headline)
                    Text("2h ago")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Post image
            AsyncImage(url: URL(string: post.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            // Actions
            HStack(spacing: 20) {
                Button(action: {}) {
                    Image(systemName: "heart")
                        .font(.title2)
                }
                
                Button(action: {}) {
                    Image(systemName: "bubble.right")
                        .font(.title2)
                }
                
                Button(action: {}) {
                    Image(systemName: "paperplane")
                        .font(.title2)
                }
            }
            .foregroundColor(.primary)
            
            // Likes count
            Text("\(post.likesCount) likes")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            // Caption
            Text(post.caption)
                .font(.body)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}