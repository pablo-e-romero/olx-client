//
//  Date+FriendlyDescription.swift
//  olx-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation

extension NSDate {

    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    static func date(withISO860String string: String) -> NSDate? {
        return self.dateFormatter.date(from: string) as NSDate?
    }

}
