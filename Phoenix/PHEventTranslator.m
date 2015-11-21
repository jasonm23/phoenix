/*
 * Phoenix is released under the MIT License. Refer to https://github.com/kasper/phoenix/blob/master/LICENSE.md
 */

@import Cocoa;

#import "PHEventConstants.h"
#import "PHEventTranslator.h"

@implementation PHEventTranslator

#pragma mark - Notification Center

+ (NSNotificationCenter *) notificationCenterForNotification:(NSString *)notification {

    static NSDictionary<NSString *, NSNotificationCenter *> *notificationToNotificationCenter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSNotificationCenter *workspaceNotificationCenter = [[NSWorkspace sharedWorkspace] notificationCenter];

        notificationToNotificationCenter = @{ /* App Notifications */

                                              NSWorkspaceDidLaunchApplicationNotification: workspaceNotificationCenter,
                                              NSWorkspaceDidTerminateApplicationNotification: workspaceNotificationCenter,
                                              NSWorkspaceDidActivateApplicationNotification: workspaceNotificationCenter,
                                              NSWorkspaceDidHideApplicationNotification: workspaceNotificationCenter,
                                              NSWorkspaceDidUnhideApplicationNotification: workspaceNotificationCenter };
    });

    NSNotificationCenter *notificationCenter = notificationToNotificationCenter[notification];

    // Specific notification center
    if (notificationCenter) {
        return notificationCenter;
    }

    // Default notification center
    return [NSNotificationCenter defaultCenter];
}

#pragma mark - Notification

+ (NSString *) notificationForEvent:(NSString *)event {

    static NSDictionary<NSString *, NSString *> *eventToNotification;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        eventToNotification = @{ /* Event Notifications */

                                 @"start": PHEventStartNotification,

                                 /* Screen Notifications */

                                 @"screensDidChange": NSApplicationDidChangeScreenParametersNotification,

                                 /* App Notifications */

                                 @"appDidLaunch": NSWorkspaceDidLaunchApplicationNotification,
                                 @"appDidTerminate": NSWorkspaceDidTerminateApplicationNotification,
                                 @"appDidActivate": NSWorkspaceDidActivateApplicationNotification,
                                 @"appDidHide": NSWorkspaceDidHideApplicationNotification,
                                 @"appDidShow": NSWorkspaceDidUnhideApplicationNotification,

                                 /* Window Notifications */

                                 @"windowDidOpen": NSAccessibilityWindowCreatedNotification,
                                 @"windowDidClose": NSAccessibilityUIElementDestroyedNotification,
                                 @"windowDidFocus": NSAccessibilityFocusedWindowChangedNotification,
                                 @"windowDidMove": NSAccessibilityWindowMovedNotification,
                                 @"windowDidResize": NSAccessibilityWindowResizedNotification,
                                 @"windowDidMinimize": NSAccessibilityWindowMiniaturizedNotification,
                                 @"windowDidUnminimize": NSAccessibilityWindowDeminiaturizedNotification };
    });

    return eventToNotification[event];
}

@end
