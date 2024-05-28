//
//  LiveCountBundle.swift
//  LiveCount
//
//  Created by Yinwei Z on 5/27/24.
//

import WidgetKit
import SwiftUI

@main
struct LiveCountBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        LiveCountWidget()
    }
}
