import SwiftUI
import PhotosUI
import CoreLocation

@MainActor
class CreatePostViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var caption = ""
    @Published var location = ""
    @Published var isLoading = false
    @Published var showImagePicker = false
    @Published var showLocationPicker = false
    @Published var error: Error?
    @Published var selectedFilter: ImageFilter = .none
    @Published var hashtags: Set<String> = []
    @Published var mentionedUsers: Set<String> = []
    
    enum ImageFilter: String, CaseIterable, Identifiable {
        case none = "Original"
        case mono = "Monochrome"
        case vivid = "Vivid"
        case fade = "Fade"
        case noir = "Noir"
        
        var id: String { rawValue }
    }
    
    private let locationManager = CLLocationManager()
    
    func applyFilter() {
        guard let image = selectedImage else { return }
        
        let context = CIContext()
        let ciImage = CIImage(image: image)
        
        switch selectedFilter {
        case .mono:
            guard let filter = CIFilter(name: "CIPhotoEffectMono") else { return }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                selectedImage = UIImage(cgImage: cgImage)
            }
        case .vivid:
            guard let filter = CIFilter(name: "CIVibrance") else { return }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(1.5, forKey: kCIInputAmountKey)
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                selectedImage = UIImage(cgImage: cgImage)
            }
        case .fade:
            guard let filter = CIFilter(name: "CIPhotoEffectFade") else { return }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                selectedImage = UIImage(cgImage: cgImage)
            }
        case .noir:
            guard let filter = CIFilter(name: "CIPhotoEffectNoir") else { return }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                selectedImage = UIImage(cgImage: cgImage)
            }
        case .none:
            return
        }
    }
    
    func extractHashtags() {
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        hashtags = Set(words.filter { $0.starts(with: "#") })
    }
    
    func extractMentions() {
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        mentionedUsers = Set(words.filter { $0.starts(with: "@") })
    }
    
    func getCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func createPost() async {
        guard let image = selectedImage else { return }
        isLoading = true
        
        do {
            // Compress and prepare image
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw APIError.invalidData
            }
            
            // Upload image first
            let uploadResponse: ImageUploadResponse = try await APIClient.shared.uploadImage(
                imageData,
                endpoint: PostEndpoint.upload
            )
            
            extractHashtags()
            extractMentions()
            
            // Create post with uploaded image URL
            let parameters: [String: Any] = [
                "imageUrl": uploadResponse.url,
                "caption": caption,
                "location": location,
                "filter": selectedFilter.rawValue,
                "hashtags": Array(hashtags),
                "mentions": Array(mentionedUsers)
            ]
            
            let post: Post = try await APIClient.shared.request(
                PostEndpoint.create,
                method: .post,
                body: parameters
            )
            
            // Reset state after successful creation
            isLoading = false
            selectedImage = nil
            caption = ""
            location = ""
            hashtags.removeAll()
            mentionedUsers.removeAll()
            
            NotificationCenter.default.post(name: .postCreated, object: post)
            
        } catch APIError.unauthorized {
            error = APIError.unauthorized
            isLoading = false
        } catch APIError.networkError {
            error = APIError.networkError
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

// Add Notification name extension
extension Notification.Name {
    static let postCreated = Notification.Name("postCreated")
}