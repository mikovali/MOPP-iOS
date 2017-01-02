//
//  EstEIDv3_4.m
//  MoppLib
//
//  Created by Katrin Annuk on 28/12/16.
//  Copyright © 2016 Mobi Lab. All rights reserved.
//

#import "EstEIDv3_4.h"

@implementation EstEIDv3_4

- (void)cardReader:(id<CardReaderWrapper>)reader readAuthenticationCertificateWithSuccess:(void (^)(MoppLibPersonalData *personalData))success failure:(FailureBlock)failure {

}

- (void)cardReader:(id<CardReaderWrapper>)reader readSignatureCertificateWithSuccess:(void (^)(MoppLibPersonalData *personalData))success failure:(FailureBlock)failure {
  
}

- (void)cardReader:(id<CardReaderWrapper>)reader readPublicDataWithSuccess:(void (^)(MoppLibPersonalData *personalData))success failure:(FailureBlock)failure {
  
  MoppLibPersonalData *personalData = [MoppLibPersonalData new];
  
  void (^readSurname)(void) = [self reader:reader readRecord:1 success:^(NSData *responseObject) {
    personalData.surname = [responseObject responseString];
    success(personalData);
  } failure:failure];
  
  void (^readFirstNameLine1)(void) = [self reader:reader readRecord:2 success:^(NSData *responseObject) {
    personalData.firstNameLine1 = [responseObject responseString];
    readSurname();
  } failure:failure];
  
  void (^readFirstNameLine2)(void) = [self reader:reader readRecord:3 success:^(NSData *responseObject) {
    personalData.firstNameLine2 = [responseObject responseString];
    readFirstNameLine1();
  } failure:failure];
  
  void (^readSex)(void) = [self reader:reader readRecord:4 success:^(NSData *responseObject) {
    personalData.sex = [responseObject responseString];
    readFirstNameLine2();
  } failure:failure];
  
  void (^readNationality)(void) = [self reader:reader readRecord:5 success:^(NSData *responseObject) {
    personalData.nationality = [responseObject responseString];
    readSex();
  } failure:failure];
  
  void (^readBirthDate)(void) = [self reader:reader readRecord:6 success:^(NSData *responseObject) {
    personalData.birthDate = [responseObject responseString];
    readNationality();
  } failure:failure];
  
  void (^readIdCode)(void) = [self reader:reader readRecord:7 success:^(NSData *responseObject) {
    personalData.personalIdentificationCode = [responseObject responseString];
    readBirthDate();
  } failure:failure];
  
  void (^readDocumentNr)(void) = [self reader:reader readRecord:8 success:^(NSData *responseObject) {
    personalData.documentNumber = [responseObject responseString];
    readIdCode();
  } failure:failure];
  
  void (^readExpiryDate)(void) = [self reader:reader readRecord:9 success:^(NSData *responseObject) {
    personalData.expiryDate = [responseObject responseString];
    readDocumentNr();
  } failure:failure];
  
  void (^readPlaceOfBirth)(void) = [self reader:reader readRecord:10 success:^(NSData *responseObject) {
    personalData.birthPlace = [responseObject responseString];
    readExpiryDate();
  } failure:failure];
  
  void (^readDateIssued)(void) = [self reader:reader readRecord:11 success:^(NSData *responseObject) {
    personalData.dateIssued = [responseObject responseString];
    readPlaceOfBirth();
  } failure:failure];
  
  void (^readTypeOfPermit)(void) = [self reader:reader readRecord:12 success:^(NSData *responseObject) {
    personalData.residentPermitType = [responseObject responseString];
    readDateIssued();
  } failure:failure];
  
  void (^readNotes1)(void) = [self reader:reader readRecord:13 success:^(NSData *responseObject) {
    personalData.notes1 = [responseObject responseString];
    readTypeOfPermit();
  } failure:failure];
  
  void (^readNotes2)(void) = [self reader:reader readRecord:14 success:^(NSData *responseObject) {
    personalData.notes2 = [responseObject responseString];
    readNotes1();
  } failure:failure];
  
  void (^readNotes3)(void) = [self reader:reader readRecord:15 success:^(NSData *responseObject) {
    personalData.notes3 = [responseObject responseString];
    readNotes2();
  } failure:failure];
  
  void (^readNotes4)(void) = [self reader:reader readRecord:16 success:^(NSData *responseObject) {
    personalData.notes4 = [responseObject responseString];
    readNotes3();
  } failure:failure];
  
  void (^select5044)(NSData *) = ^void (NSData *responseObject) {
    [reader transmitCommand:kCommandSelectFile5044 success:^(NSData *responseObject) {
      readNotes1();
    } failure:failure];
  };
  
  void (^selectEEEE)(NSData *) = ^void (NSData *responseObject) {
    [reader transmitCommand:kCommandSelectFileEEEE success:select5044 failure:failure];
  };
  
  [reader transmitCommand:kCommandSelectFileMaster success:selectEEEE failure:failure];
}

- (void (^)(void))reader:(id<CardReaderWrapper>)reader readRecord:(NSInteger)record success:(DataSuccessBlock)success failure:(FailureBlock)failure {
  return ^void (void) {

    [reader transmitCommand:[NSString stringWithFormat:kCommandReadRecord, record] success:^(NSData *responseObject) {
      const unsigned char *trailer = [responseObject responseTrailer];
      
      if (trailer[0] == 0x90 && trailer[1] == 0x00) {
        success(responseObject);
        
      } else if (trailer[0] == 0x61) {
        NSData *length = [responseObject subdataWithRange:NSMakeRange(responseObject.length - 1, 1)];
        [reader transmitCommand:[NSString stringWithFormat:kCommandReadBytes, [length toHexString]] success:success failure:failure];
      }
      
    } failure:failure];
  };
}
@end
