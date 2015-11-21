/*
 * Phoenix is released under the MIT License. Refer to https://github.com/kasper/phoenix/blob/master/LICENSE.md
 */

@import Foundation;

@interface PHOpenAtLoginHelper : NSObject

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

#pragma mark - Login Item

+ (BOOL) opensAtLogin;
+ (void) setOpensAtLogin:(BOOL)opensAtLogin;

@end
