//
//  Check Tap Status.swift
//  Cork
//
//  Created by David Bureš on 11.07.2024.
//

import Foundation

extension MigrationTracker
{
    /// Checks whether the old and new taps are added
    func checkStatusOfTaps(tapTracker: AvailableTaps)
    {
        if tapTracker.addedTaps.contains(where: { $0.name == "enigmaticdb/super-secret-tap" })
        {
            self.isOldTapAdded = true
        }
        else
        {
            self.isOldTapAdded = false
        }
        
        if tapTracker.addedTaps.contains(where: { $0.name == "marsanne/cask" })
        {
            self.isNewTapAdded = true
        }
        else
        {
            self.isNewTapAdded = false
        }
    }
}
