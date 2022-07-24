import UIKit

public class ImageCache {
    
    public static let shared = ImageCache()
    var placeholderImage = UIImage(systemName: "rectangle")!
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [URL: [(UIImage?) -> Swift.Void]]()
    
    public final func image(url: URL) -> UIImage? {
        return cachedImages.object(forKey: url as NSURL)
    }
    
    final func load(url: URL, completion: @escaping (UIImage?) -> Swift.Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data),
                let blocks = self?.loadingResponses[url] {
                self?.cachedImages.setObject(image, forKey: url as NSURL, cost: data.count)
                for block in blocks {
                    DispatchQueue.main.async {
                        block(image)
                    }
                    return
                }
                
            }
        }
    }
}
