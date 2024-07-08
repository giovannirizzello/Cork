//
//  Migration Process.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import SwiftUI

struct MigrationMigratingView: View
{
    var body: some View
    {
        Text("migration.process.title")
            .font(.title2)
        
        ProgressView()
            .progressViewStyle(.linear)
    }
}
