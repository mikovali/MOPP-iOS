//
//  ContainersListViewController.m
//  MoppApp
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
#import "DefaultsHelper.h"

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

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self cancelEditing];
}

- (void)willEnterForeground:(NSNotification *)notification {
  [self checkSharedDocsCache];
}

- (void)containerChanged:(NSNotification *)notification {
  // May consider updating just one file
  MoppLibContainer *newContainer = [[notification userInfo] objectForKey:kKeyContainerNew];
  MoppLibContainer *oldContainer = [[notification userInfo] objectForKey:kKeyContainerOld];
  [self signatureChangeOperationWithNewContainer:newContainer oldContainer:oldContainer];
}

- (BOOL)removeContainer:(MoppLibContainer *)container fromArray:(NSMutableArray *)array {
  NSInteger index = [self indexOfContainer:container inArray:array];
  if (index != NSNotFound) {
    [array removeObjectAtIndex:index];
    return YES;
  }
  return NO;
}

- (void) checkSharedDocsCache {
  NSArray *cachedDocs = [[FileManager sharedInstance] sharedDocumentPaths];
  if (cachedDocs.count > 0) {
    for (NSString *file in cachedDocs) {
      NSString *fileExtension = [file pathExtension];
        if ([fileExtension isEqualToString:ContainerFormatDdoc] ||
            [fileExtension isEqualToString:ContainerFormatAsice] ||
            [fileExtension isEqualToString:ContainerFormatBdoc]) {
          
          NSError *error;
          [[FileManager sharedInstance] moveFileWithPath:file toPath:[[FileManager sharedInstance] filePathWithFileName:file.lastPathComponent] overwrite:NO error:&error];
      }
    }
    
    [self importNonContainersIfNeeded];
  }
}

- (void)importNonContainersIfNeeded {
  NSArray *cachedDocs = [[FileManager sharedInstance] sharedDocumentPaths];
  
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localizations.ContainersListCachedFilesTitle message:Localizations.ContainersListCachedFilesMessage preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:Localizations.ContainersListCachedFilesOption1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:NO];

    [self setDataFilePaths:cachedDocs];
  }]];
  
  [alert addAction:[UIAlertAction actionWithTitle:Localizations.ContainersListCachedFilesOption2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [[FileManager sharedInstance] removeFilesAtPaths:cachedDocs];
  }]];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)signatureChangeOperationWithNewContainer:(MoppLibContainer *)newContainer oldContainer:(MoppLibContainer *)oldContainer {
  
  NSMutableArray *mutSigned = [NSMutableArray array];
  mutSigned = [self.signedContainers mutableCopy];
  NSMutableArray *mutUnsigned = [NSMutableArray array];
  mutUnsigned = [self.unsignedContainers mutableCopy];
  
  if (![self removeContainer:oldContainer fromArray:mutSigned]) {
    if (![self removeContainer:oldContainer fromArray:mutUnsigned]) {
      if (![self removeContainer:newContainer fromArray:mutSigned]) {
        [self removeContainer:newContainer fromArray:mutUnsigned];
      }
    }
  }

  if (newContainer.isSigned) {
    [mutSigned addObject:newContainer];
  } else {
    [mutUnsigned addObject:newContainer];
  }
  self.signedContainers = [mutSigned copy];
  self.unsignedContainers = [mutUnsigned copy];

  [super reloadData];
}

- (NSInteger)indexOfContainer:(MoppLibContainer *)container inArray:(NSArray *)array {
  for (int i = 0; i < array.count; i++) {
    MoppLibContainer *con = array[i];
    if ([con.filePath isEqualToString:container.filePath]) {
      return i;
    }
  }
  return NSNotFound;
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
