//
//  Tap Migration.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import SwiftUI

struct CorkTapMigrationView: View
{
    var body: some View
    {
        VStack(alignment: .center, spacing: 15)
        {
            Image(systemName: "music.note.house")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100)
            
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
             
            Button
            {
                AppConstants.logger.debug("Migration button pressed")
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
        .padding()
    }
}
