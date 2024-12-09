//
//  ImageSaver.swift
//  DisneyQuiz
//
//  Created by James Kim on 11/28/24.
//

import Foundation
import SwiftUI
import PhotosUI

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func load(_ url: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    static func writeToDisk(image: UIImage, imageName: String) -> URL? {
        if let pngDate = image.pngData() {
            let savePath = FileManager.documentsDirectory.appendingPathComponent("\(imageName).png")
            try? pngDate.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Image saved as PNG \(savePath)")
            return savePath
        }
        if let jpegData = image.jpegData(compressionQuality: 1) {
            let savePath = FileManager.documentsDirectory.appendingPathComponent("\(imageName).jpeg")
            try? jpegData.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Image saved as JPEG \(savePath)")
            return savePath
        }
        return nil
    }
}
