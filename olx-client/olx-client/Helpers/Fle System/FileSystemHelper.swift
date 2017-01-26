//
//  FileSystemHelper.swift
//  olx-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class FileSystemHelper: NSObject {

    static let sharedInstance: FileSystemHelper = FileSystemHelper()
    let fileManager = FileManager.default
    
    func existFile(atUrl url: URL) -> Bool {
        let path = url.path
        return self.fileManager.fileExists(atPath: path)
    }
    
    func copyFile(atUrl: URL, toUrl: URL) {
        if self.existFile(atUrl: toUrl) {
            try! self.fileManager.removeItem(at: toUrl)
        }
        try! self.fileManager.copyItem(at: atUrl, to: toUrl)
    }
    
    static func cachesUrl() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        let path = paths.first!
        return URL(fileURLWithPath: path)
    }
    
    static func documentsUrl() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        let path = paths.first!
        return URL(fileURLWithPath: path)
    }
}
