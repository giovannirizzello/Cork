//
//  Migration Process.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import SwiftUI

struct MigrationMigratingView: View
{
    @EnvironmentObject var migrationTracker: MigrationTracker

    var body: some View
    {
        Text("migration.process.title")
            .font(.title2)

        ProgressView(value: migrationTracker.progress, total: 10)
            .progressViewStyle(.linear)

        switch migrationTracker.migrationStep
        {
        case .checkingPrerequisites:
            MigrationStep_CheckingPrerequisites()
        case .addingNewTap:
            MigrationStep_AddingNewTap()
        case .installingCorkFromNewTap:
            EmptyView()
        case .uninstallingOldCork:
            EmptyView()
        case .removingOldTap:
            EmptyView()
        case .finished:
            EmptyView()
        }
    }
}
