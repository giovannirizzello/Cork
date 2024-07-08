//
//  Tap Migration.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import SwiftUI

struct CorkTapMigrationView: View
{
    @StateObject var migrationTracker: MigrationTracker = .init()

    var body: some View
    {
        VStack
        {
            switch migrationTracker.migrationStage
            {
                case .initial:
                    MigrationInitialView()
                case .migrating:
                    MigrationMigratingView()
                case .migratingManually:
                    MigrationMigrateManuallyView()
                case .migrated:
                    MigrationFinishedView()
                case .failed:
                    MigrationFailedView()
            }
        }
        .padding()
        .environmentObject(migrationTracker)
    }
}
