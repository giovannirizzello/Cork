//
//  Migration Step - Checking Prerequisites.swift
//  Cork
//
//  Created by David Bureš on 11.07.2024.
//

import SwiftUI

struct MigrationStep_CheckingPrerequisites: View
{
    @EnvironmentObject var tapTracker: AvailableTaps
    @EnvironmentObject var migrationTracker: MigrationTracker

    @State private var hasFinishedChckingInternet: Bool = false

    var body: some View
    {
        VStack
        {
            if !hasFinishedChckingInternet
            {
                Text("migration.checking-prerequisites")
            }
            else
            {
                if migrationTracker.isInternetStableEnoughAndEverythingAccessible
                {
                    Text("migration.checking-prerequisites.internet-check-passed")
                        .onAppear
                        {
                            migrationTracker.incrementProgress(by: .large)
                            
                            migrationTracker.checkStatusOfTaps(tapTracker: tapTracker)
                            
                            migrationTracker.migrationStep = .addingNewTap
                        }
                }
                else
                {
                    Text("migration.checking-prerequisites.internet-check-failed")

                    DismissSheetButton()
                }
            }
        }
        .task
        {
            defer
            {
                hasFinishedChckingInternet = true
                
                migrationTracker.incrementProgress(by: .large)
            }

            await migrationTracker.checkInternetStability()
        }
    }
}
