//
//  MyImageCache.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 29-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class MyImageCache {
    
    static let sharedCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "MyImageCache"
        cache.countLimit = 20 // Max 20 images in memory.
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
}

extension URL {
    
    typealias ImageCacheCompletion = (UIImage) -> Void
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// You should call this before calling fetchImage.
    var cachedImage: UIImage? {
        return MyImageCache.sharedCache.object(
            forKey: absoluteString as AnyObject) as? UIImage
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(_ completion: @escaping ImageCacheCompletion) {
        let task = URLSession.shared.dataTask(with: self, completionHandler: {
            data, response, error in
            if error == nil {
                if let  data = data,
                    let image = UIImage(data: data) {
                        MyImageCache.sharedCache.setObject(
                            image,
                            forKey: self.absoluteString as AnyObject,
                            cost: data.count)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                }
            }
        }) 
        task.resume()
    }
    
}
