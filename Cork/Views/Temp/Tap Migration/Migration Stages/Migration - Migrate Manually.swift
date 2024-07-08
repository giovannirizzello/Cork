//
//  Migration - Migrate Manually.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import SwiftUI

struct MigrationMigrateManuallyView: View
{
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 15)
        {
            Image(systemName: "wrench.and.screwdriver")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100)
                .foregroundColor(.cyan)
                .fixedSize()
            
            Text("migration.manual.title")
                .font(.title2)
            
            Text("migration.manual.description")
                .multilineTextAlignment(.center)
                .frame(maxWidth: 700)
                .fixedSize()
            
            VStack(alignment: .leading, spacing: 10)
            {
                HStack(alignment: .center)
                {
                    Image(systemName: "1.circle.fill")
                    Text("migration.manual.step-0")
                }
                
                HStack(alignment: .center)
                {
                    Image(systemName: "2.circle.fill")
                    Text("migration.manual.step-1")
                    GroupBox
                    {
                        Text("brew uninstall --cask cork && brew untap enigmaticdb/super-secret-tap")
                            .textSelection(.enabled)
                    }
                }
                .fixedSize()
                
                HStack(alignment: .center)
                {
                    Image(systemName: "3.circle.fill")
                    Text("migration.manual.step-2")
                    GroupBox
                    {
                        Text("brew tap marsanne/cask")
                            .textSelection(.enabled)
                    }
                }
                
                HStack(alignment: .center)
                {
                    Image(systemName: "4.circle.fill")
                    Text("migration.manual.step-3")
                    GroupBox
                    {
                        Text("brew install --cask cork")
                            .textSelection(.enabled)
                    }
                }
            }
            
            Button
            {
                openTerminal()
                
                dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                {
                    NSApp.terminate(self)
                }
            } label: {
                Text("action.close-begin-migration")
            }
            .keyboardShortcut(.defaultAction)
        }
        .fixedSize()
    }
}
