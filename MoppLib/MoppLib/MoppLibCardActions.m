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

+ (void)cardPersonalDataWithViewController:(UIViewController *)controller success:(void(^)(NSData *))success failure:(void(^)(NSError *))failure {
  
  [[CardActionsManager sharedInstance] cardPersonalDataWithViewController:controller success:success failure:failure];
}
@end
