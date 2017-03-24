//
//  ContainersListViewController.m
//  MoppApp
//
//  Created by Ants Käär on 16.01.17.
//  Copyright © 2017 Mobi Lab. All rights reserved.
//

#import "ContainersListViewController.h"
#import "FileManager.h"
#import "DateFormatter.h"
#import "ContainerCell.h"
#import "ContainerDetailsViewController.h"
#import "SimpleHeaderView.h"
#import <MoppLib/MoppLib.h>
#import "NoContainersCell.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>

typedef enum : NSUInteger {
  ContainersListSectionUnsigned,
  ContainersListSectionSigned
} ContainersListSection;

@interface ContainersListViewController ()

@property (strong, nonatomic) NSArray *unsignedContainers;
@property (strong, nonatomic) NSArray *signedContainers;
@property (strong, nonatomic) NSArray *filteredUnsignedContainers;
@property (strong, nonatomic) NSArray *filteredSignedContainers;

@end

@implementation ContainersListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerChanged:) name:kNotificationContainerChanged object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:kNotificationWillEnterForeground object:nil];
  
  
  [self setTitle:Localizations.TabContainers];
  
  self.unsignedContainers = [NSArray array];
  self.signedContainers = [NSArray array];
  
  //  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  //  self.containers = @[[bundle pathForResource:@"test1" ofType:@"bdoc"],
  //                      [bundle pathForResource:@"test2" ofType:@"bdoc"]];
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self setEditing:NO]; // Update edit button title.
  
  [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self checkSharedDocsCache];
}

- (void)willEnterForeground:(NSNotification *)notification {
  [self checkSharedDocsCache];
}

- (void)containerChanged:(NSNotification *)notification {
  // May consider updating just one file
  MoppLibContainer *newContainer = [[notification userInfo] objectForKey:kKeyContainerNew];
  MoppLibContainer *oldContainer = [[notification userInfo] objectForKey:kKeyContainerOld];
  MoppLibContainer *container = [[notification userInfo] objectForKey:kKeyContainer];
  if (container) {
    [self reloadData];
  }else {
    [self signatureChangeOperationWithNewContainer:newContainer oldContainer:oldContainer];
  }
}

- (void) checkSharedDocsCache {
  NSArray *cachedDocs = [[FileManager sharedInstance] sharedDocumentPaths];
  if (cachedDocs.count > 0) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Imported files" message:@"You have some imported files. What do you want to do with them?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Put them in container" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [self setDataFilePaths:cachedDocs];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Nothing. Delete them" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [[FileManager sharedInstance] removeFilesAtPaths:cachedDocs];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

-(void)signatureChangeOperationWithNewContainer:(MoppLibContainer *)newContainer oldContainer:(MoppLibContainer *)oldContainer {
  if(newContainer.isSigned && [self.unsignedContainers containsObject:oldContainer]) {
    NSMutableArray *mutSigned = [NSMutableArray array];
    NSMutableArray *mutUnsigned = [NSMutableArray array];
    mutSigned = [self.signedContainers mutableCopy];
    mutUnsigned = [self.unsignedContainers mutableCopy];
    [mutSigned addObject:newContainer];
    [mutUnsigned removeObject:oldContainer];
    self.signedContainers = [mutSigned copy];
    self.unsignedContainers = [mutUnsigned copy];
  } else if (!newContainer.isSigned && [self.signedContainers containsObject:oldContainer]) {
    NSMutableArray *mutSigned = [NSMutableArray array];
    NSMutableArray *mutUnsigned = [NSMutableArray array];
    mutSigned = [self.signedContainers mutableCopy];
    mutUnsigned = [self.unsignedContainers mutableCopy];
    [mutUnsigned addObject:newContainer];
    [mutSigned removeObject:oldContainer];
    self.signedContainers = [mutSigned copy];
    self.unsignedContainers = [mutUnsigned copy];
  }
  [super reloadData];
}

- (void)reloadData {
  MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  void (^updateValues)(NSArray *, NSArray *) = ^void (NSArray *unsignedContainers, NSArray *signedContainers) {
    [progress hide:YES];
    self.signedContainers = signedContainers;
    self.filteredSignedContainers = self.signedContainers;
    self.unsignedContainers = unsignedContainers;
    self.filteredUnsignedContainers = self.unsignedContainers;
    [super reloadData];
  };
  
  [[MoppLibContainerActions sharedInstance] getContainersWithSuccess:^(NSArray *containers) {
    NSMutableArray *sign = [NSMutableArray array];
    NSMutableArray *unsign = [NSMutableArray array];
    for (MoppLibContainer *container in containers) {
      if(container.isSigned) {
        [sign addObject:container];
      } else {
        [unsign addObject:container];
      }
    }
    updateValues([unsign copy], [sign copy]);
  } failure:^(NSError *error) {
    updateValues(self.unsignedContainers, self.signedContainers);
  }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  
  if (editing) {
    self.editButtonItem.title = Localizations.ActionCancel;
  } else {
    self.editButtonItem.title = Localizations.ActionEdit;
  }
}

- (void)filterContainers:(NSString *)searchString {
  if (searchString.length == 0) {
    self.filteredUnsignedContainers = self.unsignedContainers;
    self.filteredSignedContainers = self.signedContainers;
  } else {
    
    self.filteredUnsignedContainers = [self.unsignedContainers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.fileNameWithoutExtension contains[c] %@", searchString]];
    self.filteredSignedContainers = [self.signedContainers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.fileNameWithoutExtension contains[c] %@", searchString]];
  }
  [super filterContainers:searchString];
}

- (void)cancelEditing {
  [self setEditing:NO animated:YES];
}

- (void)setSelectedContainer:(MoppLibContainer *)selectedContainer {
  _selectedContainer = selectedContainer;
  
  [self performSegueWithIdentifier:@"ContainerDetailsSegue" sender:self];
}


#pragma mark - File importing
- (void)setDataFilePaths:(NSArray *)dataFilePaths {
  _dataFilePaths = dataFilePaths;
  
  [self performSegueWithIdentifier:@"FileImportSegue" sender:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger count = 0;
  switch (section) {
    case ContainersListSectionUnsigned: {
      if (self.filteredUnsignedContainers.count > 0) {
        count = self.filteredUnsignedContainers.count;
      } else {
        count = 1;
      }
      break;
    }
    case ContainersListSectionSigned: {
      if (self.filteredSignedContainers.count > 0) {
        count = self.filteredSignedContainers.count;
      } else {
        count = 1;
      }
      break;
    }
      
    default:
      break;
  }
  return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (indexPath.section) {
    case ContainersListSectionUnsigned: {
      if (self.filteredUnsignedContainers.count > 0) {
        MoppLibContainer *container = [self.filteredUnsignedContainers objectAtIndex:indexPath.row];
        ContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContainerCell class]) forIndexPath:indexPath];
        [cell.titleLabel setText:container.fileName];
        [cell.dateLabel setText:[[DateFormatter sharedInstance] dateToRelativeString:[container.fileAttributes fileCreationDate]]];
        return cell;
      } else {
        NoContainersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoContainersCell class]) forIndexPath:indexPath];
        return cell;
      }
      break;
    }
    case ContainersListSectionSigned: {
      if (self.filteredSignedContainers.count > 0) {
        MoppLibContainer *container = [self.filteredSignedContainers objectAtIndex:indexPath.row];
        ContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContainerCell class]) forIndexPath:indexPath];
        [cell.titleLabel setText:container.fileName];
        [cell.dateLabel setText:[[DateFormatter sharedInstance] dateToRelativeString:[container.fileAttributes fileCreationDate]]];
        return cell;
      } else {
        NoContainersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoContainersCell class]) forIndexPath:indexPath];
        return cell;
      }
      break;
    }
    default:
      break;
  }
  
  return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  switch (indexPath.section) {
    case ContainersListSectionUnsigned: {
      if (self.filteredUnsignedContainers.count == 0) {
        return;
      }
      self.selectedContainer = [self.filteredUnsignedContainers objectAtIndex:indexPath.row];
      break;
    }
    case ContainersListSectionSigned: {
      if (self.filteredSignedContainers.count == 0) {
        return;
      }
      self.selectedContainer = [self.filteredSignedContainers objectAtIndex:indexPath.row];
      break;
    }
    default:
      break;
  }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case ContainersListSectionUnsigned: {
      if (self.filteredUnsignedContainers.count == 0) {
        return NO;
      } else {
        return YES;
      }
      break;
    }
    case ContainersListSectionSigned: {
      if (self.filteredSignedContainers.count == 0) {
        return NO;
      } else {
        return YES;
      }
      break;
    }
    default:
      return NO;
      break;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  return Localizations.ActionDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    switch (indexPath.section) {
      case ContainersListSectionUnsigned: {
        MoppLibContainer *container = [self.unsignedContainers objectAtIndex:indexPath.row];
        [[FileManager sharedInstance] removeFileWithName:container.fileName];
        break;
      }
      case ContainersListSectionSigned: {
        MoppLibContainer *container = [self.signedContainers objectAtIndex:indexPath.row];
        [[FileManager sharedInstance] removeFileWithName:container.fileName];
        break;
      }
        
      default:
        break;
    }
    
    //    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self reloadData];
  }
  
  [self performSelector:@selector(cancelEditing) withObject:nil afterDelay:0.1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  SimpleHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SimpleHeaderView class]) owner:self options:nil] objectAtIndex:0];
  
  switch (section) {
    case ContainersListSectionUnsigned: {
      [header.titleLabel setText:Localizations.ContainersListSectionHeaderUnsigned];
      break;
    }
    case ContainersListSectionSigned: {
      [header.titleLabel setText:Localizations.ContainersListSectionHeaderSigned];
      break;
    }
      
    default:
      header = nil;
      break;
  }
  
  return header;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ContainerDetailsSegue"]) {
    ContainerDetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.container = self.selectedContainer;
    
  } else if ([segue.identifier isEqualToString:@"FileImportSegue"]) {
    UINavigationController *navController = [segue destinationViewController];
    FileImportViewController *fileImportViewController = (FileImportViewController *)navController.viewControllers[0];
    fileImportViewController.delegate = self;
    fileImportViewController.dataFilePaths = self.dataFilePaths;
  }
}


#pragma mark - FileImportViewControllerDelegate
- (void)openContainerDetails:(MoppLibContainer *)container {
  self.selectedContainer = container;
}

@end
