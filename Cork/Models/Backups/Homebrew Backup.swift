//
//  Homebrew Backup.swift
//  Cork
//
//  Created by David Bureš on 30.07.2024.
//

import Foundation
import SwiftUI

struct HomebrewBackup
{
    let file: URL
}

extension HomebrewBackup: Transferable
{
    static var transferRepresentation: some TransferRepresentation
    {
        FileRepresentation(contentType: .homebrewBackup) { sentFile in
            SentTransferredFile(sentFile.file)
        } importing: { receivedFile in
            let copy = receivedFile.file
            
            return Self.init(file: copy)
        }

        ProxyRepresentation(exporting: \.file)
    }
}
