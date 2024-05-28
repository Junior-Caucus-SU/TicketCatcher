//
//  LiveCount.swift
//  LiveCount
//
//  Created by Yinwei Z on 5/27/24.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct LiveCountWidget: Widget {
    let kind: String = "LiveCount"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveCountAttributes.self) { context in
            
            VStack {
                Text("\(context.state.attendeeCount) Attendees")
                    .font(.title).bold()
                    .contentTransition(.numericText())
                Text(context.isStale ? "Outdated Session" : "\(context.attributes.eventName)")
                    .font(.system(size: 16, design: .monospaced))
                    .opacity(0.5)
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.5))
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.isStale ? "Outdated" : "Active").opacity(0.5)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "person.3.fill").opacity(0.5)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("\(context.state.attendeeCount) Attendees").bold().padding().font(.title)
                }
            } compactLeading: {
                Text("\(context.state.attendeeCount)")
            } compactTrailing: {
                Image(systemName: "person.3.fill")
            } minimal: {
                Text("\(context.state.attendeeCount)")
            }
            .keylineTint(Color.red)
        }
    }
}
