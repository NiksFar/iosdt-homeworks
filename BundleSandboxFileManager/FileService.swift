//
//  FileService.swift
//  BundleSandboxFileManager
//
//  Created by Никита on 13.11.2023.
//

import Foundation
import UIKit

protocol FileManagerService {
    func contentsOfDirectory()
    func createDirectory(name: String)
    func createFile(image: UIImage, name: String, completion: @escaping(_ result: Bool) -> Void)
    func removeContent(path: String)
}

class FileService: FileManagerService {
    
    static var shared = FileService()
    let fileManager = FileManager.default
    
    func contentsOfDirectory() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let contents = try? fileManager.contentsOfDirectory(atPath: paths[0])
        //print("Содержимое директории: \(contents)")
    }
    
    func createDirectory(name: String) {
        
        do {
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let url = documentUrl.appendingPathComponent("\(name)")
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            
        } catch {
                    print(error.localizedDescription)
                }
    }
    
    
    func createFile(image: UIImage, name: String, completion: @escaping(_ result: Bool) -> Void) {
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentsDirectoryURL.appendingPathComponent(name + ".png")
            do {
                try image.pngData()?.write(to: fileURL)
                print("filesaved", name, fileURL)
                completion(true)
            } catch {
                completion(false)
                print(error.localizedDescription)
            }
    }
    
    func removeContent(path: String) {
        do {
            try fileManager.removeItem(atPath: path)
            print("File removed")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkFile(name: String) -> Bool? {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        let fullPath = paths + "/\(name)"
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: fullPath, isDirectory:&isDir) {
            if isDir.boolValue {
                print("Is Directory", fullPath)
                return false
            } else {
                print("Is file", fullPath)
                return true
            }
        } else {
            print("Else else")
            return nil
        }
    }
    
}


struct Content {
    let type: ContentType
}

enum ContentType {
    case file
    case folder
}
