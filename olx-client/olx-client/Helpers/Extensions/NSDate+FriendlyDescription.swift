//
//  Date+FriendlyDescription.swift
//  olx-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation

extension NSDate {

    func friendlyDescription() -> String {
        
        var description = "";
        let now = NSDate()
        let timeInterval = now.timeIntervalSince(self as Date)
        
        let justCreatedSeconds = TimeInterval(40.0);
        let secondsPerMinute = TimeInterval(60.0);
        let minutesPerHour = TimeInterval(60.0);
        let hoursPerDay = TimeInterval(24.0);
        let daysPerMonth = TimeInterval(30.0);
        let monthsPerYear = TimeInterval(12.0);
        
        if (timeInterval < justCreatedSeconds)
        {
            description = "A few seconds ago"
        }
        else if (timeInterval < secondsPerMinute)
        {
            description = "Less than a minute ago"
        }
        else
        {
            let minutesAgo = floor(timeInterval / secondsPerMinute);
            
            if (minutesAgo < minutesPerHour)
            {
                description = (minutesAgo == 1 ?
                    String(format: "%.0f minute ago", minutesAgo) :
                    String(format: "%.0f minutes ago", minutesAgo));
            }
            else
            {
                let hoursAgo = floor(minutesAgo / minutesPerHour);
                
                if (hoursAgo < hoursPerDay)
                {
                    description = (hoursAgo == 1 ?
                        String(format: "%.0f hour ago", hoursAgo) :
                        String(format: "%.0f hours ago", hoursAgo));
                    
                }
                else
                {
                    let daysAgo = floor(hoursAgo / hoursPerDay);
                    
                    if (daysAgo < daysPerMonth)
                    {
                        description = (daysAgo == 1 ?
                            String(format: "%.0f day ago", daysAgo) :
                            String(format: "%.0f days ago", daysAgo));
                    }
                    else
                    {
                        let monthsAgo = floor(daysAgo / daysPerMonth);
                        
                        if (monthsAgo < monthsPerYear)
                        {
                            description = (monthsAgo == 1 ?
                                String(format: "%.0f  month ago", monthsAgo) :
                                String(format: "%.0f months ago", monthsAgo));
                        }
                        else
                        {
                            let yearsAgo = floor(monthsAgo / monthsPerYear);
                            
                            description = (yearsAgo == 1 ?
                                String(format: "%.0f year ago", yearsAgo) :
                                String(format: "%.0f years ago", yearsAgo));
                        }
                    }
                }
            }
        }
        
        return description;
    }

}
