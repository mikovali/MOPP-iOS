//
//  MoppLibDigidocManager.h
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
#import "MoppLibContainer.h"
#import "MoppLibSignature.h"
#import "MoppLibConstants.h"

@interface MoppLibDigidocManager : NSObject

+ (MoppLibDigidocManager *)sharedInstance;

- (void)setupWithSuccess:(EmptySuccessBlock)success andFailure:(FailureBlock)failure;

- (MoppLibContainer *)getContainerWithPath:(NSString *)containerPath error:(NSError **)error;
- (MoppLibContainer *)createContainerWithPath:(NSString *)containerPath withDataFilePaths:(NSArray *)dataFilePaths;
- (MoppLibContainer *)addDataFilesToContainerWithPath:(NSString *)containerPath withDataFilePaths:(NSArray *)dataFilePaths;
- (MoppLibContainer *)removeDataFileFromContainerWithPath:(NSString *)containerPath atIndex:(NSUInteger)dataFileIndex;
- (NSArray *)getContainers;

- (NSString *)dataFileCalculateHashWithDigestMethod:(NSString *)method container:(MoppLibContainer *)moppContainer dataFileId:(NSString *)dataFileId;
- (BOOL)container:(MoppLibContainer *)moppContainer containsSignatureWithCert:(NSData *)cert;
- (void)addSignature:(NSString *)containerPath pin2:(NSString *)pin2 cert:(NSData *)cert success:(ContainerBlock)success andFailure:(FailureBlock)failure;
- (void)addMobileIDSignatureToContainer:(MoppLibContainer *)moppContainer signature:(NSString *)signature success:(ContainerBlock)success andFailure:(FailureBlock)failure;
- (MoppLibContainer *)removeSignature:(MoppLibSignature *)moppSignature fromContainerWithPath:(NSString *)containerPath;
- (NSString *)getMoppLibVersion;
- (void)container:(NSString *)containerPath saveDataFile:(NSString *)fileName to:(NSString *)path;
@end
