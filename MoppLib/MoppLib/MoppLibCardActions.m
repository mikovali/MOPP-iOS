//
//  MoppLibCardActions.m
//  MoppLib
//
//  Created by Katrin Annuk on 27/12/16.
//  Copyright © 2016 Mobi Lab. All rights reserved.
//

#import "MoppLibCardActions.h"
#import "CardActionsManager.h"

@implementation MoppLibCardActions

+ (void)cardPersonalDataWithViewController:(UIViewController *)controller success:(PersonalDataBlock)success failure:(FailureBlock)failure {
  [[CardActionsManager sharedInstance] cardPersonalDataWithViewController:controller success:success failure:failure];
}

+ (void)minimalCardPersonalDataWithViewController:(UIViewController *)controller success:(PersonalDataBlock)success failure:(FailureBlock)failure {
  [[CardActionsManager sharedInstance] minimalCardPersonalDataWithViewController:controller success:success failure:failure];
}

+ (void)isCardInserted:(void (^)(BOOL))completion {
  [[CardActionsManager sharedInstance] isCardInserted:completion];
}

+ (BOOL)isReaderConnected {
  return [[CardActionsManager sharedInstance] isReaderConnected];
}

+ (void)signingCertWithViewController:(UIViewController *)controller success:(CertDataBlock)success failure:(FailureBlock)failure {
  [[CardActionsManager sharedInstance] signingCertWithViewController:controller success:success failure:failure];
}

+ (void)authenticationCertWithViewController:(UIViewController *)controller success:(CertDataBlock)success failure:(FailureBlock)failure {
  [[CardActionsManager sharedInstance] authenticationCertWithViewController:controller success:success failure:failure];
}

+ (void)pin1RetryCountWithViewController:(UIViewController *)controller success:(void (^)(NSNumber *))success failure:(FailureBlock)failure {
  [[CardActionsManager sharedInstance] code:CodeTypePin1 retryCountWithViewController:controller success:success failure:failure];
}

+ (void)pin2RetryCountWithViewController:(UIViewController *)controller success:(void (^)(NSNumber *))success failure:(FailureBlock)failure {
  [[CardActionsManager sharedInstance] code:CodeTypePin2 retryCountWithViewController:controller success:success failure:failure];
}

+ (void)pukRetryCountWithViewController:(UIViewController *)controller success:(void (^)(NSNumber *))success failure:(FailureBlock)failure {
  [[CardActionsManager sharedInstance] code:CodeTypePuk retryCountWithViewController:controller success:success failure:failure];
}

@end
