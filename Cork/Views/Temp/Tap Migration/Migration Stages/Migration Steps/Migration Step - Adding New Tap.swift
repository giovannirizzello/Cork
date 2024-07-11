//
//  Migration Step - Adding New Tap.swift
//  Cork
//
//  Created by David Bureš on 11.07.2024.
//

import SwiftUI

struct MigrationStep_AddingNewTap: View
{
    @EnvironmentObject var migrationTracker: MigrationTracker

    @State private var hasSuccessfullyAddedNewTap: Bool = false
    @State private var hasFailedWhileAddingTap: Bool = false

    var body: some View
    {
        VStack
        {
            if !hasFailedWhileAddingTap
            {
                if !hasSuccessfullyAddedNewTap
                {
                    Text("migration.adding-new-tap")
                }
                else
                {
                    Text("migration.adding-new-tap.passed")
                }
            }
            else
            {
                Text("migration.adding-new-tap.failed")

                DismissSheetButton()
            }
        }
        .task
        {
            let tapResult: String = await addTap(name: "marsanne/cask")

            if tapResult.contains("Tapped")
            {
                AppConstants.logger.info("Adding of new tap was successful")

                hasSuccessfullyAddedNewTap = true
                
                migrationTracker.incrementProgress(by: .large)
                
                migrationTracker.migrationStep = .removingOldTap
            }
            else
            {
                AppConstants.logger.warning("Adding of new tap failed")

                hasFailedWhileAddingTap = true
            }
            
        }
    }
}
