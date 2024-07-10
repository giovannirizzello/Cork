//
//  Check Internet Stability.swift
//  Cork
//
//  Created by David Bureš on 11.07.2024.
//

import Foundation

extension MigrationTracker
{
    /// This function checks whether internet prerequisites are met. These include:
    /// - Does internet work?
    /// - Is Homebrew accessible?
    func checkInternetStability() async
    {
        AppConstants.logger.debug("Will check internet stability")
        
        let data: Data? = try? await downloadDataFromURL(URL(string: "https://corkmac.app/RLS/latest/Cork.zip")!)
        
        if data != nil
        {
            AppConstants.logger.debug("Internet is stable enough - migration can proceed")
            self.isInternetStableEnoughAndEverythingAccessible = true
        }
        else
        {
            AppConstants.logger.warning("Internet is not stable enough - cancelling migration")
            self.isInternetStableEnoughAndEverythingAccessible = false
        }
    }
}
