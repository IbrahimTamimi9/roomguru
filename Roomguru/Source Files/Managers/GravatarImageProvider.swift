//
//  GravatarImageProvider.swift
//  Roomguru
//
//  Created by Peter Bruz on 03/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async

class GravatarImageProvider {
    
    private let gravatarImagesDirectory = "/GravatarImages/"
    
    private let fileExtension = ".jpg"
    
    func getImageFromUrl(url: NSURL, completion: (image: UIImage?) -> Void){
        
        let imageName = parseURLToImageFileName(url)
        
        if let imageFromDisk = getImageFromDisk(imageName) {
            completion(image: imageFromDisk)
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            if let downloadedData = data where data?.length>0 {
                let image = UIImage(data: downloadedData)
                
                Async.background {
                    self.saveImageToDisk(downloadedData, imageName: imageName)
                    }.main {
                        completion(image: image)
                }
            }
        }.resume()
    }
    
    // MARK: Disk operations
    
    func getImageFromDisk(imageName: String) -> UIImage? {
        let filePath = NSHomeDirectory().stringByAppendingString(gravatarImagesDirectory+imageName+fileExtension)
        
        if let imageData = NSData(contentsOfFile: filePath) {
            return UIImage(data: imageData)
        }
        
        return nil
    }
    
    func saveImageToDisk (imageData: NSData, imageName: String) {
        let filePath = NSHomeDirectory().stringByAppendingString(gravatarImagesDirectory+imageName+fileExtension)
        imageData.writeToFile(filePath, atomically: true)
    }
    
    // MARK: Image name creating
    
    private func parseURLToImageFileName(url: NSURL) -> String {
        return url.absoluteString.md5()
    }
}
