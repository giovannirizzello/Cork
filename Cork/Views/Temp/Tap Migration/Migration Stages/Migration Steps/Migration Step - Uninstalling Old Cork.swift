//
//  Migration Step - Uninstalling Old Cork.swift
//  Cork
//
//  Created by David Bureš on 11.07.2024.
//

import SwiftUI

struct MigrationStep_UninstallingOldCork: View
{
    
    @EnvironmentObject var migrationTracker: MigrationTracker
    
    @State private var hasSuccessfullyUninstalledOldCork: Bool = false
    @State private var hasFailedWhileUninstallingOldCork: Bool = false
    
    var body: some View
    {
        VStack
        {
            if !hasFailedWhileUninstallingOldCork
            {
                if !hasSuccessfullyUninstalledOldCork
                {
                    Text("migration.uninstalling-old-cork")
                }
                else
                {
                    Text("migration.uninstalling-old-cork.passed")
                }
            }
            else
            {
                Text("migration.uninstalling-old-cork.failed")
            }
        }
        .task
        {
            let uninstallationResult: TerminalOutput = await shell(AppConstants.brewExecutablePath, ["uninstall", "--cask", "enigmaticdb/super-secret-tap/cork"])
            
            if !uninstallationResult.standardError.isEmpty
            {
                hasFailedWhileUninstallingOldCork = true
            }
            
            hasSuccessfullyUninstalledOldCork = true
            
            migrationTracker.incrementProgress(by: .large)
        }
    }
}
