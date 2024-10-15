//
//  App State.swift
//  Cork
//
//  Created by David Bureš on 05.02.2023.
//

import AppKit
import Foundation
@preconcurrency import UserNotifications
import CorkShared
import CorkNotifications

/// Class that holds the global state of the app, excluding services
@Observable @MainActor
final class AppState
{
    // MARK: - Licensing

    var licensingState: LicensingState = .notBoughtOrHasNotActivatedDemo
    var isShowingLicensingSheet: Bool = false

    // MARK: - Navigation

    var navigationTarget: NavigationTargetMainWindow?

    // MARK: - Notifications

    var notificationEnabledInSystemSettings: Bool?
    var notificationAuthStatus: UNAuthorizationStatus = .notDetermined

    // MARK: - Stuff for controlling various sheets from the menu bar

    var isShowingInstallationSheet: Bool = false
    var isShowingPackageReinstallationSheet: Bool = false
    var isShowingUninstallationSheet: Bool = false
    var isShowingMaintenanceSheet: Bool = false
    var isShowingFastCacheDeletionMaintenanceView: Bool = false
    var isShowingAddTapSheet: Bool = false
    var isShowingUpdateSheet: Bool = false

    // MARK: - Stuff for controlling the UI in general

    var isSearchFieldFocused: Bool = false

    // MARK: - Brewfile importing and exporting

    var isShowingBrewfileExportProgress: Bool = false
    var isShowingBrewfileImportProgress: Bool = false
    var brewfileImportingStage: BrewfileImportStage = .importing

    var isCheckingForPackageUpdates: Bool = true

    var isShowingUninstallationProgressView: Bool = false
    var isShowingFatalError: Bool = false
    var fatalAlertType: DisplayableAlert? = nil

    var isShowingSudoRequiredForUninstallSheet: Bool = false
    var packageTryingToBeUninstalledWithSudo: BrewPackage?

    var isShowingRemoveTapFailedAlert: Bool = false

    var isShowingIncrementalUpdateSheet: Bool = false

    var isLoadingFormulae: Bool = true
    var isLoadingCasks: Bool = true

    var isLoadingTopPackages: Bool = false
    var failedWhileLoadingTopPackages: Bool = false

    var cachedDownloadsFolderSize: Int64 = AppConstants.brewCachedDownloadsPath.directorySize
    var cachedDownloads: [CachedDownload] = .init()

    private var cachedDownloadsTemp: [CachedDownload] = .init()

    var taggedPackageNames: Set<String> = .init()

    var corruptedPackage: String = ""

    // MARK: - Showing errors

    func showAlert(errorToShow: DisplayableAlert)
    {
        fatalAlertType = errorToShow

        isShowingFatalError = true
    }

    func dismissAlert()
    {
        isShowingFatalError = false

        fatalAlertType = nil
    }

    // MARK: - Notification setup

    func setupNotifications() async
    {
        let notificationCenter: UNUserNotificationCenter = AppConstants.notificationCenter

        let authStatus: UNAuthorizationStatus = await notificationCenter.authorizationStatus()

        switch authStatus
        {
        case .notDetermined:
            AppConstants.logger.debug("Notification authorization status not determined. Will request notifications again")

            await requestNotificationAuthorization()

        case .denied:
            AppConstants.logger.debug("Notifications were refused")

        case .authorized:
            AppConstants.logger.debug("Notifications were authorized")

        case .provisional:
            AppConstants.logger.debug("Notifications are provisional")

        case .ephemeral:
            AppConstants.logger.debug("Notifications are ephemeral")

        @unknown default:
            AppConstants.logger.error("Something got really fucked up about notifications setup")
        }

        notificationAuthStatus = authStatus
    }

    func requestNotificationAuthorization() async
    {
        let notificationCenter: UNUserNotificationCenter = AppConstants.notificationCenter

        do
        {
            try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])

            notificationEnabledInSystemSettings = true
        }
        catch let notificationPermissionsObtainingError as NSError
        {
            AppConstants.logger.error("Notification permissions obtaining error: \(notificationPermissionsObtainingError.localizedDescription, privacy: .public)\nError code: \(notificationPermissionsObtainingError.code, privacy: .public)")

            notificationEnabledInSystemSettings = false
        }
    }

    // MARK: - Initiating the update process from legacy contexts

    @objc func startUpdateProcessForLegacySelectors(_: NSMenuItem!)
    {
        isShowingUpdateSheet = true

        sendNotification(title: String(localized: "notification.upgrade-process-started"))
    }

    @MainActor
    func loadCachedDownloadedPackages() async
    {
        let smallestDispalyableSize: Int = .init(cachedDownloadsFolderSize / 50)

        var packagesThatAreTooSmallToDisplaySize: Int = 0

        guard let cachedDownloadsFolderContents: [URL] = try? FileManager.default.contentsOfDirectory(at: AppConstants.brewCachedDownloadsPath, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles])
        else
        {
            return
        }

        let usableCachedDownloads: [URL] = cachedDownloadsFolderContents.filter { $0.pathExtension != "json" }

        for usableCachedDownload in usableCachedDownloads
        {
            guard var itemName: String = try? usableCachedDownload.lastPathComponent.regexMatch("(?<=--)(.*?)(?=\\.)")
            else
            {
                return
            }

            AppConstants.logger.debug("Temp item name: \(itemName, privacy: .public)")

            if itemName.contains("--")
            {
                do
                {
                    itemName = try itemName.regexMatch(".*?(?=--)")
                }
                catch {}
            }

            guard let itemAttributes = try? FileManager.default.attributesOfItem(atPath: usableCachedDownload.path)
            else
            {
                return
            }

            guard let itemSize = itemAttributes[.size] as? Int
            else
            {
                return
            }

            if itemSize < smallestDispalyableSize
            {
                packagesThatAreTooSmallToDisplaySize = packagesThatAreTooSmallToDisplaySize + itemSize
            }
            else
            {
                cachedDownloads.append(CachedDownload(packageName: itemName, sizeInBytes: itemSize))
            }

            AppConstants.logger.debug("Others size: \(packagesThatAreTooSmallToDisplaySize, privacy: .public)")
        }

        AppConstants.logger.log("Cached downloads contents: \(self.cachedDownloads)")

        cachedDownloads = cachedDownloads.sorted(by: { $0.sizeInBytes < $1.sizeInBytes })

        cachedDownloads.append(.init(packageName: String(localized: "start-page.cached-downloads.graph.other-smaller-packages"), sizeInBytes: packagesThatAreTooSmallToDisplaySize, packageType: .other))
    }
}

private extension UNUserNotificationCenter
{
    func authorizationStatus() async -> UNAuthorizationStatus
    {
        await notificationSettings().authorizationStatus
    }
}

extension AppState
{
    @MainActor
    func assignPackageTypeToCachedDownloads(brewData: BrewDataStorage)
    {
        var cachedDownloadsTracker: [CachedDownload] = .init()

        AppConstants.logger.debug("Package tracker in cached download assignment function has \(brewData.installedFormulae.count + brewData.installedCasks.count) packages")

        for cachedDownload in cachedDownloads
        {
            let normalizedCachedPackageName: String = cachedDownload.packageName.onlyLetters

            if brewData.installedFormulae.contains(where: { $0.name.localizedCaseInsensitiveContains(normalizedCachedPackageName) })
            { /// The cached package is a formula
                AppConstants.logger.debug("Cached package \(cachedDownload.packageName) (\(normalizedCachedPackageName)) is a formula")
                cachedDownloadsTracker.append(.init(packageName: cachedDownload.packageName, sizeInBytes: cachedDownload.sizeInBytes, packageType: .formula))
            }
            else if brewData.installedCasks.contains(where: { $0.name.localizedCaseInsensitiveContains(normalizedCachedPackageName) })
            { /// The cached package is a cask
                AppConstants.logger.debug("Cached package \(cachedDownload.packageName) (\(normalizedCachedPackageName)) is a cask")
                cachedDownloadsTracker.append(.init(packageName: cachedDownload.packageName, sizeInBytes: cachedDownload.sizeInBytes, packageType: .cask))
            }
            else
            { /// The cached package cannot be found
                AppConstants.logger.debug("Cached package \(cachedDownload.packageName) (\(normalizedCachedPackageName)) is unknown")
                cachedDownloadsTracker.append(.init(packageName: cachedDownload.packageName, sizeInBytes: cachedDownload.sizeInBytes, packageType: .unknown))
            }
        }

        cachedDownloads = cachedDownloadsTracker
    }
}
