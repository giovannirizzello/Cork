//
//  Migration - Finished.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import SwiftUI

struct MigrationFinishedView: View
{
    var body: some View
    {
        
        VStack(alignment: .center, spacing: 15)
        {
            Image(systemName: "checkmark.seal")
                .resizable()
                .foregroundColor(.green)
                .frame(width: 50, height: 50)
            
            Text("migration.finished.title")
                .font(.title2)
            
            Text("migration.finished.description")
            
            DismissSheetButton(customButtonText: "action.close")
                .keyboardShortcut(.defaultAction)
        }
        .fixedSize()
    }
}
