
import UIKit

extension UIImage {
    func toBase64String(format: ImageFormat = .png) -> String? {
        let imageData: Data?
        
        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compressionQuality):
            imageData = self.jpegData(compressionQuality: compressionQuality)
        }
        
        return imageData?.base64EncodedString()
    }
    
    enum ImageFormat {
        case png
        case jpeg(compressionQuality: CGFloat)
    }
}
