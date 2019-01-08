//
//  Media.swift
//  Engagingu
//
//  Created by Nicholas on 7/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

struct Media{
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key;
        self.mimeType = "image/png"
        self.filename = "photo\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        self.data = data
        
    }
    
}
