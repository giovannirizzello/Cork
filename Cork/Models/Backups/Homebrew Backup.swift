//
//  Homebrew Backup.swift
//  Cork
//
//  Created by David Bureš on 30.07.2024.
//

import Foundation
import SwiftUI

struct HomebrewBackup: Transferable
{
    static var transferRepresentation: some TransferRepresentation
    {
        return FileRepresentation(exportedContentType: .homebrewBackup) { homebrewBackup in
            SentTransferredFile(homebrewBackup)
        }
    }
}
