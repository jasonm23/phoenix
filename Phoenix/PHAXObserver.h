/*
 * Phoenix is released under the MIT License. Refer to https://github.com/kasper/phoenix/blob/master/LICENSE.md
 */

@import Cocoa;

#import "PHAXUIElement.h"

static NSString * const PHAXObserverWindowKey = @"PHAXObserverWindowKey";

@interface PHAXObserver : PHAXUIElement

#pragma mark - Initialise

- (instancetype) initWithApp:(NSRunningApplication *)app;

@end
