//
// Autogenerated by Laurine - by Jiri Trecak ( http://jiritrecak.com, @jiritrecak )
// Do not change this file manually!
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

@import Foundation;


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Header

@interface _Localizations : NSObject

/// Base translation: Singing method
- (NSString *)ContainerDetailsSigningMethodAlertTitle;

/// Base translation: Change %@
- (NSString *(^)(NSString *))PinActionsChangePin;
/// Base translation: Version
- (NSString *)SettingsApplicationVersion;

/// Base translation: Signature certificate
- (NSString *)MyEidSignatureCertificate;

/// Base translation: Card reader is not connected.  Please make sure your reader is turned on and %@ to select it.   %@
- (NSString *(^)(NSString *, NSString *))MyEidWarningReaderNotFound;
/// Base translation: Changing %@
- (NSString *(^)(NSString *))PinActionsChangingPin;
/// Base translation: Card in reader:
- (NSString *)MyEidCardInReader;

/// Base translation: Authentication certificate
- (NSString *)MyEidAuthenticationCertificate;

/// Base translation: Create document
- (NSString *)FileImportCreateContainerButton;

/// Base translation: PIN actions view
- (NSString *)MyEidPinActionsView;

/// Base translation: Personal Code:
- (NSString *)MyEidPersonalCode;

/// Base translation: Rename
- (NSString *)ContainerDetailsRename;

/// Base translation: Search
- (NSString *)ContainersListSearchPlaceholder;

/// Base translation: E-mail:
- (NSString *)MyEidEmail;

/// Base translation: No internet connection
- (NSString *)ContainerDetailsInternetConnectionErrorTitle;

/// Base translation: Name
- (NSString *)ContainerDetailsName;

/// Base translation: %@ has been changed and unblocked.
- (NSString *(^)(NSString *))PinActionsSuccessPinUnblocked;
/// Base translation: Failed to open document %@
- (NSString *(^)(NSString *))FileImportImportFailedAlertMessage;
/// Base translation: Read more.
- (NSString *)MyEidFindMoreInfo;

/// Base translation: Importing file
- (NSString *)ShareExtensionImportTitle;

/// Base translation: Send crash report?
- (NSString *)CrashlyticsTitle;

/// Base translation: Birth:
- (NSString *)MyEidBirth;

/// Base translation: Signed
- (NSString *)ContainersListSectionHeaderSigned;

/// Base translation: Signature %@
- (NSString *(^)(NSString *))ContainerDetailsSignaturePrefix;
/// Base translation: Always send
- (NSString *)CrashlyticsActionAlwaysSend;

/// Base translation: Error
- (NSString *)PinActionsErrorTitle;

/// Base translation: Phone number
- (NSString *)SettingsPhoneNumberTitle;

/// Base translation: Code: %@
- (NSString *(^)(NSString *))ChallengeCodeLabel;
/// Base translation: Valid until:
- (NSString *)MyEidValidUntil;

/// Base translation: ID card
- (NSString *)ContainerDetailsSigningMethodIdCard;

/// Base translation: PUK
- (NSString *)PinActionsPuk;

/// Base translation: Mobile-ID
- (NSString *)SettingsMobileIdHeader;

/// Base translation: Unblock %@
- (NSString *(^)(NSString *))PinActionsUnblockPin;
/// Base translation: Validity:
- (NSString *)MyEidValidity;

/// Base translation: %i times
- (NSString *(^)(int))MyEidTimesUsed;
/// Base translation: Changing %@:
- (NSString *(^)(NSString *))PinActionsVerificationTitle;
/// Base translation: Invalid phone number
- (NSString *)ContainerDetailsPhoneNumberErrorAlertTitle;

/// Base translation: Choose signing method
- (NSString *)ContainerDetailsSigningMethodAlertMessage;

/// Base translation: New container format
- (NSString *)SettingsNewContainerFormat;

/// Base translation: Add to existing document
- (NSString *)ActionAddToDocument;

/// Base translation: eID
- (NSString *)MyEidEid;

/// Base translation: Adding signature failed.
- (NSString *)ContainerDetailsGeneralError;

/// Base translation: Additional dependencies
- (NSString *)AboutDependencies;

/// Base translation: Delete
- (NSString *)ActionDelete;

/// Base translation: ID-card is a compulsory identity document in Estonia. ID-card can be used to travel in Member States of the European Union and the European Economic Area.  The ID-card can be applied for in Service Offices of Police and Border Guard Administration, in foreign representations of the Republic of Estonia, by post or by e-mail. %@
- (NSString *(^)(NSString *))MyEidIdCardInfo;
/// Base translation: About
- (NSString *)SettingsAbout;

/// Base translation: File with same name already exists. Do you want to overwrite?
- (NSString *)ContainerDetailsFileAlreadyExists;

/// Base translation: Here you can change your PIN codes and unblock them if needed. PIN operations require a card reader to be connected to your phone.
- (NSString *)PinActionsInfo;

/// Base translation: New %@ must be different from current %@.
- (NSString *(^)(NSString *, NSString *))PinActionsSameAsCurrent;
/// Base translation: Cancel
- (NSString *)ActionCancel;

/// Base translation: New %@ and repeated %@ are different.
- (NSString *(^)(NSString *, NSString *))PinActionsRepeatedPinDoesntMatch;
/// Base translation: Your signature already exists on this document.
- (NSString *)ContainerDetailsSignatureAlreadyExists;

/// Base translation: Format: %@ | Size: %ld kb
- (NSString *(^)(NSString *, long))ContainerDetailsHeaderDetails;
/// Base translation: Files
- (NSString *)ContainerDetailsDatafileSectionHeader;

/// Base translation: Rules
- (NSString *)PinActionsRulesTitle;

/// Base translation: %@ has been changed.
- (NSString *(^)(NSString *))PinActionsSuccessPinChanged;
/// Base translation: Do you wish to store the entered ID code and phone number for future use ? 
- (NSString *)ContainerDetailsStoreMobileIdCredentialsAlertMessage;

/// Base translation: Size: %ld kb
- (NSString *(^)(long))ContainerDetailsDatafileDetails;
/// Base translation: Citizenship:
- (NSString *)MyEidCitizenship;

/// Base translation: Your signature has been added to the document.
- (NSString *)ContainerDetailsSignatureAdded;

/// Base translation: Imported files
- (NSString *)ContainersListCachedFilesTitle;

/// Base translation: Attention!
- (NSString *)ContainerDetailsAttention;

/// Base translation: Surname:
- (NSString *)MyEidSurname;

/// Base translation: You have some imported files. What do you want to do with them?
- (NSString *)ContainersListCachedFilesMessage;

/// Base translation: Unblocking %@
- (NSString *(^)(NSString *))PinActionsTitleUnblockingPin;
/// Base translation: Mobile-ID
- (NSString *)ContainerDetailsSigningMethodMobileId;

/// Base translation: Settings
- (NSString *)TabSettings;

/// Base translation: Unsigned
- (NSString *)ContainersListSectionHeaderUnsigned;

/// Base translation: Given names:
- (NSString *)MyEidGivenNames;

/// Base translation: https://www.politsei.ee/en/teenused/isikut-toendavad-dokumendid/id-kaart/taiskasvanule/
- (NSString *)MyEidIdCardInfoLink;

/// Base translation: Software ordered by RIA, developed by Mobi Lab
- (NSString *)AboutDevelopment;

/// Base translation: tap here
- (NSString *)MyEidTapHere;

/// Base translation: Type in your ID code
- (NSString *)SettingsIdCodeAlertMessage;

/// Base translation: No
- (NSString *)ActionNo;

/// Base translation: Authentication with PIN code is required for signing.
- (NSString *)ContainerDetailsPinNotProvided;

/// Base translation: is not valid
- (NSString *)ContainerDetailsSignatureInvalid;

/// Base translation: Used:
- (NSString *)MyEidUseCount;

/// Base translation: Not valid
- (NSString *)MyEidNotValid;

/// Base translation: New %@ must be %i-%i digits long.
- (NSString *(^)(NSString *, int, int))PinActionsRulePinLength;
/// Base translation: Documents
- (NSString *)TabContainers;

/// Base translation: Don’t send
- (NSString *)CrashlyticsActionDoNotSend;

/// Base translation: New %@ can't be %@, or contain combination of your birthdate.
- (NSString *(^)(NSString *, NSString *))PinActionsRuleForbiddenPins;
/// Base translation: Supported reader
- (NSString *)MyEidSupportedReader;

/// Base translation: ID card is missing. Please make sure ID card is inserted correctly.
- (NSString *)ContainerDetailsCardNotFound;

/// Base translation: This %@ is not allowed.
- (NSString *(^)(NSString *))PinActionsInvalidFormat;
/// Base translation: Enter details
- (NSString *)ContainerDetailsIdcodePhoneAlertTitle;

/// Base translation: If you forget the PUK code or the certificates remain blocked, you have to visit the service center to obtain new codes.
- (NSString *)PinActionsPukChangeWarning;

/// Base translation: Create new document
- (NSString *)ActionCreateNewDocument;

/// Base translation: PIN settings
- (NSString *)TabSimSettings;

/// Base translation: Send
- (NSString *)CrashlyticsActionSend;

/// Base translation: Put them in container
- (NSString *)ContainersListCachedFilesOption1;

/// Base translation: OK
- (NSString *)ActionOk;

/// Base translation: Mobile-ID request timeout
- (NSString *)MobileIdTimeoutMessage;

/// Base translation: Failure
- (NSString *)ErrorAlertTitleGeneral;

/// Base translation: Document
- (NSString *)ContainerDetailsTitle;

/// Base translation: My eID
- (NSString *)MyEidMyEid;

/// Base translation: Document name too long.
- (NSString *)ContainerDetailsFileNameTooLong;

/// Base translation: New %@ code
- (NSString *(^)(NSString *))PinActionsNewPin;
/// Base translation: is valid
- (NSString *)ContainerDetailsSignatureValid;

/// Base translation: Enter new container name
- (NSString *)ContainerDetailsEnterNewName;

/// Base translation: Delete them
- (NSString *)ContainersListCachedFilesOption2;

/// Base translation: Import file
- (NSString *)FileImportTitle;

/// Base translation: PIN action was successful
- (NSString *)PinActionsSuccessTitle;

/// Base translation: Hey. Looks like we crashed! Please help us fix the problem by sending a crash report.
- (NSString *)CrashlyticsMessage;

/// Base translation: 1 time
- (NSString *)MyEidUsedOnce;

/// Base translation: Unblocking %@:
- (NSString *(^)(NSString *))PinActionsUnblockingPin;
/// Base translation: %@  Please select unsigned document or create new one.
- (NSString *(^)(NSString *))FileImportInfo;
/// Base translation: ID code
- (NSString *)SettingsIdCodeTitle;

/// Base translation: Rename container
- (NSString *)ContainerDetailsRenameContainer;

/// Base translation: My eID
- (NSString *)TabMyEid;

/// Base translation: Type in your phone number
- (NSString *)SettingsPhoneNumberAlertMessage;

/// Base translation: It seems that you have provided an invalid phone number
- (NSString *)ContainerDetailsPhoneNumberErrorAlertMessage;

/// Base translation: Internet connection must be available for signing.
- (NSString *)ContainerDetailsInternetConnectionErrorMessage;

/// Base translation: Signatures
- (NSString *)ContainerDetailsSignatureSectionHeader;

/// Base translation: Failed to change document name.
- (NSString *)ContainerDetailsNameChangeFailed;

/// Base translation: Edit
- (NSString *)ActionEdit;

/// Base translation: No containers found
- (NSString *)NoContainersCellTitle;

/// Base translation: Please enter your PIN2 code.
- (NSString *)ContainerDetailsEnterPin;

/// Base translation: %@ is blocked. You can unblock %@ in %@.
- (NSString *(^)(NSString *, NSString *, NSString *))MyEidPinBlocked;
/// Base translation: Add signature
- (NSString *)ContainerDetailsAddSignature;

/// Base translation: Store credentials
- (NSString *)ContainerDetailsStoreMobileIdCredentialsAlertTitle;

/// Base translation: Repeat new %@ code
- (NSString *(^)(NSString *))PinActionsRepeatPin;
/// Base translation: Yes
- (NSString *)ActionYes;

/// Base translation: %@ must contain numbers only.
- (NSString *(^)(NSString *))PinActionsRuleNumbersOnly;
/// Base translation: ID card is not found.  Please check if ID card is inserted correctly. New ID cards have chip on the back side of the card.
- (NSString *)MyEidWarningCardNotFound;

/// Base translation: PIN1
- (NSString *)PinActionsPin1;

/// Base translation: You have already signed the container, are you sure you want to add another signature?
- (NSString *)ContainerDetailsSignatureAlreadyExistsAlertMessage;

/// Base translation: Signature added
- (NSString *)ContainerDetailsSigningSuccess;

/// Base translation: New %@ must be different from previous one.
- (NSString *(^)(NSString *))PinActionsRuleDifferentFromPrevious;
/// Base translation: File is now cached for you. Go to RIA DigiDoc application to finish import
- (NSString *)ShareExtensionImportMessage;

/// Base translation: %@ is blocked.
- (NSString *(^)(NSString *))PinActionsPinBlocked;
/// Base translation: Personal data
- (NSString *)MyEidPersonalData;

/// Base translation: ID code
- (NSString *)ContainerDetailsIdcodePhoneAlertIdcodePlacholder;

/// Base translation: Enter ID code and phone number
- (NSString *)ContainerDetailsIdcodePhoneAlertMessage;

/// Base translation: Signture exists
- (NSString *)ContainerDetailsSignatureAlreadyExistsAlertTitle;

/// Base translation: You need to connect a card reader to sign documents.
- (NSString *)ContainerDetailsReaderNotFound;

/// Base translation: Phone number
- (NSString *)ContainerDetailsIdcodePhoneAlertPhonenumberPlacholder;

/// Base translation: Current %@ was wrong. %@ has been blocked.
- (NSString *(^)(NSString *, NSString *))PinActionsWrongPinBlocked;
/// Base translation: Could not change %@
- (NSString *(^)(NSString *))PinActionsGeneralError;
/// Base translation: Valid
- (NSString *)MyEidValid;

/// Base translation: Import failed
- (NSString *)FileImportImportFailedAlertTitle;

/// Base translation: PIN2
- (NSString *)PinActionsPin2;

/// Base translation: Current %@ was wrong. You have %i tries left.
- (NSString *(^)(NSString *, int))PinActionsWrongPinRetry;
/// Base translation: Current %@ code
- (NSString *(^)(NSString *))PinActionsCurrentPin;
/// Base translation: Using current %@ code
- (NSString *(^)(NSString *))PinActionsVerificationOption;
+ (_Localizations *)sharedInstance;

@end


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Macros

// Make localization to be easily accessible
#define Localizations [_Localizations sharedInstance]
