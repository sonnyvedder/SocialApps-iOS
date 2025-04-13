import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign In") {
                    Task {
                        await viewModel.signIn()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink("Create Account", destination: SignUpView())
            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
}