//
//  GravatarImageProvider.swift
//  Roomguru
//
//  Created by Peter Bruz on 03/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async

final class GravatarImageProvider {
    
    class func imageForURL(url: NSURL, completion: (image: UIImage?) -> Void){
        
        let imageName = parseURLToImageFileName(url)
        
        if let imageFromDisk = FileCache.cachedImage(imageName) {
            completion(image: imageFromDisk)
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            if let downloadedData = data where data?.length>0 {
                let image = UIImage(data: downloadedData)
                
                Async.background {
                    FileCache.cacheImage(downloadedData, imageName: imageName)
                }.main {
                    completion(image: image)
                }
            }
            else {
                completion(image: nil)
            }
        }.resume()
    }
    
    // MARK: Image name creating
    
    private class func parseURLToImageFileName(url: NSURL) -> String {
        return url.absoluteString.md5()
    }
    
    // MARK: Image cache
    
    private class FileCache {
        
        private static let GravatarImagesDirectory = "/GravatarImages/"
        private static let FileExtension = ".jpg"
        
        private class func cachedImage(imageName: String) -> UIImage? {
            let filePath = NSHomeDirectory().stringByAppendingString(GravatarImagesDirectory+imageName+FileExtension)
            
            if let imageData = NSData(contentsOfFile: filePath) {
                return UIImage(data: imageData)
            }
            
            return nil
        }
        
        private class func cacheImage(imageData: NSData, imageName: String) {
            let filePath = NSHomeDirectory().stringByAppendingString(GravatarImagesDirectory+imageName+FileExtension)
            imageData.writeToFile(filePath, atomically: true)
        }
    }
}
