//
//  Migration Step - Removing Old Tap.swift
//  Cork
//
//  Created by David Bureš on 11.07.2024.
//

import SwiftUI

struct MigrationStep_RemovingOldTap: View
{
    @EnvironmentObject var migrationTracker: MigrationTracker

    @State private var hasSuccessfullyRemovedOldTap: Bool = false
    @State private var hasFailedWhileRemovingOldTap: Bool = false

    var body: some View
    {
        VStack
        {
            if !hasFailedWhileRemovingOldTap
            {
                if !hasSuccessfullyRemovedOldTap
                {
                    Text("migration.removing-old-tap")
                }
                else
                {
                    Text("migration.removing-old-tap.passed")
                        .onAppear
                        {
                            migrationTracker.migrationStage = .migrated
                        }
                }
            }
            else
            {
                Text("migration.removing-old-tap.failed")

                DismissSheetButton()
            }
        }
        .task
        {
            let untapResult = await shell(AppConstants.brewExecutablePath, ["untap", "enigmaticdb/super-secret-tap"]).standardError

            if untapResult.contains("Untapped")
            {
                AppConstants.logger.debug("Untapping was successful")

                hasSuccessfullyRemovedOldTap = true

                migrationTracker.incrementProgress(by: .large)
            }
            else
            {
                AppConstants.logger.warning("Untaping Failed")

                hasFailedWhileRemovingOldTap = true
            }
        }
    }
}
