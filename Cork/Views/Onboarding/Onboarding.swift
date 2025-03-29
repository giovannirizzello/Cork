//
//  Onboarding.swift
//  Cork
//
//  Created by David Bureš on 21.10.2023.
//

import SwiftUI
import CorkShared
import CorkNotifications
import Defaults

struct OnboardingView: View
{
    @Environment(\.dismiss) var dismiss: DismissAction

    @Default(.showRealTimeTerminalOutputOfOperations) var showRealTimeTerminalOutputOfOperations
    @Default(.allowMoreCompleteUninstallations) var allowMoreCompleteUninstallations

    @Default(.displayAdvancedDependencies) var displayAdvancedDependencies

    @Default(.caveatDisplayOptions) var caveatDisplayOptions
    @Default(.showDescriptionsInSearchResults) var showDescriptionsInSearchResults

    @Default(.showSearchFieldForDependenciesInPackageDetails) var showSearchFieldForDependenciesInPackageDetails
    
    @Default(.showInMenuBar) var showInMenuBar

    @Default(.areNotificationsEnabled) var areNotificationsEnabled
    @Default(.outdatedPackageNotificationType) var outdatedPackageNotificationType

    @Default(.notifyAboutPackageUpgradeResults) var notifyAboutPackageUpgradeResults
    @Default(.notifyAboutPackageInstallationResults) var notifyAboutPackageInstallationResults
    
    @Default(.showCompatibilityWarning) var showCompatibilityWarning

    @Default(.enableDiscoverability) var enableDiscoverability

    @AppStorage("enableRevealInFinder") var enableRevealInFinder: Bool = false

    @AppStorage("displayOnlyIntentionallyInstalledPackagesByDefault") var displayOnlyIntentionallyInstalledPackagesByDefault: Bool = true

    @AppStorage("outdatedPackageInfoDisplayAmount") var outdatedPackageInfoDisplayAmount: OutdatedPackageInfoAmount = .all
    @AppStorage("showOldVersionsInOutdatedPackageList") var showOldVersionsInOutdatedPackageList: Bool = true

    @State var onboardingSetupLevel: SetupLevels = .medium

    /// Level numbers:
    /// - 0: Basic
    /// - 1: Slightly basic
    /// - 2: Balanced
    /// - 3: Slightly advanced
    /// - 4: Advanced
    @State var onboardingSetupLevelNumber: Float = 2

    @State private var areDetailsExpanded: Bool = false

    var body: some View
    {
        VStack(alignment: .center, spacing: 20, content: {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 100, height: 100)

            if !areDetailsExpanded
            {
                VStack(alignment: .center, spacing: 5, content: {
                    Text("onboarding.title")
                        .font(.title)

                    Text("onboarding.subtitle")
                })
            }

            VStack(alignment: .leading, spacing: 10, content: {
                OnboardingDefaultsSlider(setupLevel: $onboardingSetupLevel, sliderValue: $onboardingSetupLevelNumber)

                DisclosureGroup(
                    isExpanded: $areDetailsExpanded,
                    content: {
                        if onboardingSetupLevelNumber < 4
                        {
                            Form
                            {
                                OnboardingBasicCategory(onboardingSetupLevelNumber: onboardingSetupLevelNumber)

                                OnboardingDiscoverabilityCategory(onboardingSetupLevelNumber: onboardingSetupLevelNumber)

                                OnboardingPackageFeaturesCategory(onboardingSetupLevelNumber: onboardingSetupLevelNumber)

                                OnboardingTapFeaturesCategory(onboardingSetupLevelNumber: onboardingSetupLevelNumber)

                                OnboardingExtrasCategory(onboardingSetupLevelNumber: onboardingSetupLevelNumber)
                            }
                            .formStyle(.grouped)
                        }
                        else
                        {
                            Text("onboarding.all-features-enabled")
                        }
                    },
                    label: {
                        Text(areDetailsExpanded ? "add-package.install.hide-details" : "add-package.install.show-details")
                    }
                )
            })

            Button
            {
                /// First, purge all the current defaults if there are any
                if let bundleID = Bundle.main.bundleIdentifier
                {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }

                /// Now, do all the setup
                if onboardingSetupLevelNumber >= 1
                {
                    showDescriptionsInSearchResults = true
                    showCompatibilityWarning = true
                    outdatedPackageInfoDisplayAmount = .none
                }

                if onboardingSetupLevelNumber >= 2
                {
                    enableDiscoverability = true
                    caveatDisplayOptions = .full
                    areNotificationsEnabled = true
                    outdatedPackageNotificationType = .both

                    outdatedPackageInfoDisplayAmount = .versionOnly
                    showOldVersionsInOutdatedPackageList = true

                    displayOnlyIntentionallyInstalledPackagesByDefault = false
                }

                if onboardingSetupLevelNumber >= 3
                {
                    showSearchFieldForDependenciesInPackageDetails = true
                    displayAdvancedDependencies = true
                    allowMoreCompleteUninstallations = true
                    showInMenuBar = true

                    notifyAboutPackageUpgradeResults = true
                    notifyAboutPackageInstallationResults = true

                    outdatedPackageInfoDisplayAmount = .all

                    enableRevealInFinder = true
                }

                if onboardingSetupLevelNumber >= 4
                {
                    showRealTimeTerminalOutputOfOperations = true
                }

                AppConstants.shared.logger.info("Onboarding finished")

                dismiss()
            } label: {
                Text("action.done")
            }
            .keyboardShortcut(.defaultAction)
            .buttonStyle(LargeButtonStyle())

        })
        .fixedSize()
        .padding()
        .animation(.none, value: areDetailsExpanded)
    }
}
