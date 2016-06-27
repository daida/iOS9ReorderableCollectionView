//
//  DataFetcher.swift
//  CollectionViewPoc
//
//  Created by Nicolas Bellon on 23/06/2016.
//  Copyright © 2016 Nicolas Bellon. All rights reserved.
//

import Foundation

struct DataFetcher {
    
   static func consoleModelsFetcher() -> [ConsoleModel] {
    
        guard let path = NSBundle.mainBundle().pathForResource("data", ofType: "plist") else { return [ConsoleModel]() }
    
        let array = NSArray(contentsOfFile: path)
        
        if let array = array as? [[String: AnyObject]] {
            
            return array.map { ConsoleModel(dico: $0) }
            
        }
        
        return [ConsoleModel]()
    }
    
}