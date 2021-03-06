//
//  CardActionsManager.h
//  MoppLib
//
/*
 * Copyright 2017 Riigi Infosüsteemide Amet
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CardCommands.h"
#import "CBManagerHelper.h"


@interface CardActionsManager : NSObject <CBManagerHelperDelegate>
+ (CardActionsManager *)sharedInstance;

- (void)minimalCardPersonalDataWithViewController:(UIViewController *)controller success:(PersonalDataBlock)success failure:(FailureBlock)failure;

- (void)cardPersonalDataWithViewController:(UIViewController *)controller success:(PersonalDataBlock)success failure:(FailureBlock)failure;

- (void)cardOwnerBirthDateWithViewController:(UIViewController *)controller success:(void(^)(NSDate *date))success failure:(FailureBlock)failure;

- (void)signingCertWithViewController:(UIViewController *)controller success:(CertDataBlock)success failure:(FailureBlock)failure;
- (void)authenticationCertWithViewController:(UIViewController *)controller success:(CertDataBlock)success failure:(FailureBlock)failure;

- (void)authenticationCertDataWithViewController:(UIViewController *)controller success:(DataSuccessBlock)success failure:(FailureBlock)failure;
- (void)signingCertDataWithViewController:(UIViewController *)controller success:(DataSuccessBlock)success failure:(FailureBlock)failure;

- (void)changePin:(CodeType)type withPuk:(NSString *)puk to:(NSString *)newPin viewController:(UIViewController *)controller success:(VoidBlock)success failure:(FailureBlock)failure;

- (void)changeCode:(CodeType)type withVerifyCode:(NSString *)verify to:(NSString *)newCode viewController:(UIViewController *)controller success:(VoidBlock)success failure:(FailureBlock)failure;

- (void)unblockCode:(CodeType)type withPuk:(NSString *)puk newCode:(NSString *)newCode viewController:(UIViewController *)controller success:(VoidBlock)success failure:(FailureBlock)failure ;

- (void)code:(CodeType)type retryCountWithViewController:(UIViewController *)controller success:(void (^)(NSNumber *))success failure:(FailureBlock)failure;

- (void)addSignature:(NSString *)containerPath controller:(UIViewController *)controller success:(void (^)(MoppLibContainer *container, BOOL signatureWasAdded))success failure:(FailureBlock)failure;
- (void)calculateSignatureFor:(NSData *)hash pin2:(NSString *)pin2 controller:(UIViewController *)controller success:(DataSuccessBlock)success failure:(FailureBlock)failure;

- (void)isCardInserted:(void(^)(BOOL)) completion;
- (BOOL)isReaderConnected;
@end
