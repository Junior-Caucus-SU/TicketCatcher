//
//  LiveCountLiveActivity.swift
//  LiveCount
//
//  Created by Yinwei Z on 5/27/24.
//

import ActivityKit
import Foundation

struct LiveCountAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var attendeeCount: Int
    }
    var eventName: String
}
