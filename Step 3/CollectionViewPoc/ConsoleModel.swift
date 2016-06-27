//
//  ConsoleModel.swift
//  CollectionViewPoc
//
//  Created by Nicolas Bellon on 23/06/2016.
//  Copyright © 2016 Nicolas Bellon. All rights reserved.
//

import Foundation
import UIKit

struct ConsoleModel {
    
    let name: String
    let image: UIImage
    
}


extension ConsoleModel {
    
    init(dico: [String: AnyObject]) {
        
        guard
            let dico = dico as? [String : String],
            let name = dico["name"],
            let imageName = dico["image"],
            let image = UIImage(named:imageName) else {
                self.name = "unanme"
                self.image = UIImage()
                return
        }
        
        self.name = name
        self.image = image
    }
}