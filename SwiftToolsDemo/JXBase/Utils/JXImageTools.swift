//
//  JXImageTools.swift
//  Goallive
//
//  Created by ken Z on 2023/11/28.
//
import UIKit
import Photos
class JXImageTools: NSObject {
    //PHAsset转换url
    static func requetVideo(phAsset: PHAsset, completed: ((_ url: URL?) -> Void)?) {
        PHCachingImageManager.default().requestAVAsset(forVideo: phAsset, options: nil, resultHandler: { (video, audioMix, info) in
            DispatchQueue.main.async {
                var url: URL?
                if let urlAsset = video as? AVURLAsset {
                    url = urlAsset.url
                }
                completed?(url)
            }
        })
    }
    
    
    static func saveImageToTmpDirectory(_ image: UIImage, withName name: String = "ios_IMG_\(Date().timeIntervalSince1970).png") -> URL? {
        guard let data = image.pngData() else {
            return nil
        }
        let fileManager = FileManager.default
        let tmpDirectory = fileManager.temporaryDirectory
        let fileURL = tmpDirectory.appendingPathComponent(name)
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
    
    
}
