//
//  Migration State.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import Foundation

/// The various stages of the migration process
enum MigrationStage
{
    case initial
    case migrating
    case migratingManually
    case migrated
    case failed
}

/// Steps of ``MigrationStage.migrating``
enum MigrationStep
{
    case checkingPrerequisites
    case backingUp
    case addingNewTap
    case installingCorkFromNewTap
    case uninstallingOldCork
    case removingOldTap
    case finished
}

enum IncrementProgressStep
{
    case small
    case large
}

@MainActor
class MigrationTracker: ObservableObject
{
    // MARK: - Internet

    @Published var isInternetStableEnoughAndEverythingAccessible: Bool = false

    // MARK: - Taps

    @Published var isOldTapAdded: Bool = false
    @Published var isNewTapAdded: Bool = false

    // MARK: - Backup
    @Published var backupURL: URL?
    
    // MARK: - Migration Stages

    @Published var migrationStage: MigrationStage = .initial

    // MARK: - Migration Steps

    @Published var migrationStep: MigrationStep = .checkingPrerequisites

    // MARK: - Progress

    @Published var progress: Double = 0

    func incrementProgress(by magnitude: IncrementProgressStep)
    {
        switch magnitude
        {
        case .small:
            self.progress += 0.5
        case .large:
            self.progress += 1
        }
    }
}
