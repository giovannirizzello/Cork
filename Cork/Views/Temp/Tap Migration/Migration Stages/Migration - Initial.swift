//
//  Migration - Initial.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import SwiftUI

struct MigrationInitialView: View
{
    @EnvironmentObject var migrationTracker: MigrationTracker

    var body: some View
    {
        VStack(alignment: .center, spacing: 15)
        {
            Image(systemName: "music.note.house")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100)
                .foregroundColor(.orange)

            Text("migration.title")
                .font(.title)

            Text("migration.body")
                .multilineTextAlignment(.center)

            HStack(alignment: .lastTextBaseline)
            {
                GroupBox
                {
                    Text("enigmaticdb/super-secret-tap")
                } label: {
                    Text("migration.label.private")
                }

                Image(systemName: "arrow.forward")

                GroupBox
                {
                    Text("marsanne/cask")
                } label: {
                    Text("migration.label.public")
                }
            }

            /*
             DisclosureGroup
             {
             DisclosureGroup
             {
             Text("migration.faq.1.text")
             } label: {
             Text("migration.faq.1.label")
             }

             DisclosureGroup
             {
             Text("migration.faq.2.text")
             } label: {
             Text("migration.faq.2.label")
             }
             } label: {
             Text("generic.faq")
             }
             */

            HStack
            {
                migrateManuallyButton
                
                migrateAutomaticallyButton
            }
        }
    }
    
    @ViewBuilder
    var migrateAutomaticallyButton: some View
    {
        Button
        {
            AppConstants.logger.debug("Migration button pressed")
            
            migrationTracker.migrationStage = .migrating
        } label: {
            Text("action.migrate")
        }
        .modify
        { viewProxy in
            if #available(macOS 14.0, *)
            {
                viewProxy
                    .controlSize(.extraLarge)
            }
        }
        .keyboardShortcut(.defaultAction)
    }
    
    @ViewBuilder
    var migrateManuallyButton: some View
    {
        Button
        {
            migrationTracker.migrationStage = .migratingManually
        } label: {
            Text("action.migrate-manual")
        }
        .modify
        { viewProxy in
            if #available(macOS 14.0, *)
            {
                viewProxy
                    .controlSize(.extraLarge)
            }
        }
        .keyboardShortcut(.none)
    }
}
