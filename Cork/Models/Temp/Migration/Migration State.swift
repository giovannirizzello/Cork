//
//  Migration State.swift
//  Cork
//
//  Created by David Bureš on 08.07.2024.
//

import Foundation

enum MigrationStage
{
    case initial
    case migrating
    case migratingManually
    case migrated
    case failed
}

enum MigrationStep
{
    case addingNewTap
    case installingCorkFromNewTap
    case uninstallingOldCork
    case removingNewTap
    case finished
}

@MainActor
class MigrationTracker: ObservableObject
{
    @Published var migrationStage: MigrationStage = .initial
}
