//
//  Migration - Backing Up.swift
//  Cork
//
//  Created by David Bureš on 11.07.2024.
//

import SwiftUI

struct MigrationStep_BackingUp: View
{
    @EnvironmentObject var migrationTracker: MigrationTracker

    @State private var hasSuccessfullyBackedUp: Bool = false
    @State private var hasFailedWhileBackingUp: Bool = false
    @State private var isShowingManualBackupInstructions: Bool = false

    @State private var failureReason: String = ""

    var body: some View
    {
        if !isShowingManualBackupInstructions
        {
            if !hasFailedWhileBackingUp
            {
                if !hasSuccessfullyBackedUp
                {
                    Text("migration.backing.up")
                        .task
                    {
                        do
                        {
                            let backupResult: String = try await exportBrewfile(appState: AppState())
                            
                            migrationTracker.incrementProgress(by: .small)
                            
                            do
                            {
                                let backupURL: URL = URL.temporaryDirectory.appendingPathComponent("MigrationBackup", conformingTo: .homebrewBackup)
                                
                                AppConstants.logger.debug("Will write migration backup to \(backupURL)")
                                
                                try backupResult.write(to: backupURL, atomically: true, encoding: .utf8)
                                
                                migrationTracker.backupURL = backupURL
                                
                                migrationTracker.incrementProgress(by: .large)
                                
                                hasSuccessfullyBackedUp = true
                            }
                            catch let backupWritingFailure
                            {
                                AppConstants.logger.error("Failed while writing migration backup to file: \(backupWritingFailure.localizedDescription)")
                                
                                failureReason = backupWritingFailure.localizedDescription
                                hasFailedWhileBackingUp = true
                            }
                        }
                        catch let backupFailure
                        {
                            AppConstants.logger.error("Failed while creating migration backup: \(backupFailure.localizedDescription)")
                            
                            failureReason = backupFailure.localizedDescription
                            hasFailedWhileBackingUp = true
                        }
                    }
                }
                else
                {
                    Text("migration.backing-up.passed")
                        .onAppear
                    {
                        migrationTracker.migrationStep = .addingNewTap
                    }
                }
            }
            else
            {
                VStack(spacing: 15)
                {
                    Text("migration.backing-up.failure")
                    
                    GroupBox
                    {
                        Text(failureReason)
                    }
                    
                    Text("migration.backing-up.failure.next-steps")
                    
                    HStack
                    {
                        DismissSheetButton()
                        
                        Spacer()
                        
                        Button
                        {
                            isShowingManualBackupInstructions = true
                        } label:
                        {
                            Text("migration.action.back-up.manually")
                        }
                        
                        Button
                        {
                            migrationTracker.migrationStep = .addingNewTap
                        } label: {
                            Text("migration.action.continue-without-backing-up")
                        }
                        .keyboardShortcut(.defaultAction)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        else
        {
            VStack(alignment: .leading, spacing: 10)
            {
                
                HStack(alignment: .center)
                {
                    Image(systemName: "1.circle.fill")
                    Text("migration.backing-up.manual.step.1")
                    GroupBox
                    {
                        Text("brew bundle dump")
                    }
                }
                
                HStack(alignment: .center)
                {
                    Image(systemName: "2.circle.fill")
                    Text("migration.backing-up.manual.step.2")
                    GroupBox
                    {
                        Text("open .")
                    }
                }
                
                HStack(alignment: .center)
                {
                    Image(systemName: "3.circle.fill")
                    Text("migration.backing-up.manual.step.3")
                }
                
                HStack
                {
                    Spacer()
                    
                    Button
                    {
                        migrationTracker.migrationStep = .addingNewTap
                    } label: {
                        Text("action.continue")
                    }
                }
            }
        }
    }
}
