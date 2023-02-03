//
//  Thread+isMainThread.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//  Copyright © 2023 Abdullah Al-Ashi. All rights reserved.
//

import Foundation

extension Thread {
    static func executeOnMain(_ block: @escaping () -> Void) {
        if !isMainThread {
            
            DispatchQueue.main.async(execute: block)
        }
    }
}
