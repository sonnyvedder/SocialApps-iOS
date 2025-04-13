import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 3)
    
    var body: some View {
        NavigationView {
            ScrollView {
                SearchBar(text: $viewModel.searchText)
                    .padding()
                
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
            }
            .navigationTitle("Explore")
        }
        .onChange(of: viewModel.searchText) { _ in
            viewModel.searchPosts()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}