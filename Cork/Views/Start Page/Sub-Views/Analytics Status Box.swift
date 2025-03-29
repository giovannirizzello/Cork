//
//  Analytics Status Box.swift
//  Cork
//
//  Created by David Bureš on 05.04.2023.
//

import CorkShared
import Defaults
import SwiftUI

struct AnalyticsStatusBox: View
{
    @Default(.allowBrewAnalytics) var allowBrewAnalytics

    var body: some View
    {
        VStack(alignment: .leading)
        {
            GroupBoxHeadlineGroup(
                image: "chart.bar",
                title: allowBrewAnalytics ? "start-page.analytics.enabled" : "start-page.analytics.disabled",
                mainText: allowBrewAnalytics ? "start-page.analytics.enabled.description" : "start-page.analytics.disabled.description"
            )
        }
    }
}
