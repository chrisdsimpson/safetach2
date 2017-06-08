/*
 * File Name:	DeviceScanViewController.m
 *
 * Version      1.0.0
 *
 * Date:		06/08/2017
 *
 * Description:
 *   This is view controller class for the BLE device scan for the iOS Safetach2 project.
 *
 * Notes:
 *
 * Related Document:
 *
 * Code Tested With:
 *   1. Xcode 8.2.1
 *
 * Author:		Christopher D. Simpson
 *
 * Company:		Maxton Manufacturing Company
 *				1728 Orbit Way
 *				Minden, NV  89423
 *				www.maxtonvalve.com
 *
 * Copyright (c) 2017 Maxton Manufacturing Company
 * All rights reserved.
 * Claim of copyright does not imply waiver of other rights.
 *
 * NOTICE OF PROPRIETARY RIGHTS.
 *
 * This program is a confidential trade secret and the property of
 * Maxton Manufacturing Company. Use, examination, reproduction,
 * disassembly, decompiling, transfer and/or disclosure to others of all
 * or any part of this software program are strictly prohibited except by
 * express written agreement with Maxton Manufacturing Company.
 */


#import "DeviceScanViewController.h"
#import "ScannedPeripheralTableViewCell.h"
#import "CBManager.h"
#import "CBPeripheralExt.h"
#import "Constants.h"
//#import "ProgressHandler.h"
//#import "Utilities.h"
//#import "UIView+Toast.h"

#define CAROUSEL_SEGUE              @"CarouselViewID"
#define PERIPHERAL_CELL_IDENTIFIER  @"peripheralCell"

/*!
 *  @class DeviceScanViewController
 *
 *  @discussion Class to handle the available device listing and connection
 *
 */
@interface DeviceScanViewController () <UITableViewDataSource,UITableViewDelegate,cbDiscoveryManagerDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UILabel *refreshingStatusLabel;
    UIRefreshControl *refreshPeripheralListControl;
    BOOL isBluetoothON, isSearchActive;
    NSArray * searchResults;
}

@property (weak, nonatomic) IBOutlet UITableView *scannedPeripheralsTableView;


@end

@implementation DeviceScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addRefreshControl];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOCALIZEDSTRING(@"OTAUpgradeStatus")] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOCALIZEDSTRING(@"OTAUpgradeStatus")];

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:LOCALIZEDSTRING(@"OTAAppUpgradePendingWarning") delegate:self cancelButtonTitle:OK otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self addSearchButtonToNavBar];
    //[[self navBarTitleLabel] setText:BLE_DEVICE];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[CBManager sharedManager] disconnectPeripheral:[[CBManager sharedManager] myPeripheral]];
    [[CBManager sharedManager] setCbDiscoveryDelegate:self];
    
    // Start scanning for devices
    [[CBManager sharedManager] startScanning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[CBManager sharedManager] stopScanning];
    //[super removeSearchButtonFromNavBar];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == SEARCH_BAR_TAG) {
        isSearchActive = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == SEARCH_BAR_TAG) {
        isSearchActive = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * searchString = string.length == 0 ? [textField.text substringToIndex:textField.text.length-1] : [NSString stringWithFormat:@"%@%@",textField.text, string];
    
    if (searchString.length == 0) {
        isSearchActive = NO;
        [_scannedPeripheralsTableView reloadData];
    }else{
        isSearchActive = YES;
        [self searchBLEPeripheralsNamesForSubString:searchString onFinish:^(NSArray *filteredPeripheralList) {
            searchResults = [[NSArray alloc] initWithArray:filteredPeripheralList];
            [_scannedPeripheralsTableView reloadData];
        }];
    }
    return YES;
}

#pragma mark - Search Filter Method

- (void) searchBLEPeripheralsNamesForSubString:(NSString *)searchString onFinish:(void(^)(NSArray * filteredPeripheralList))finish
{
    NSMutableArray * filteredPeripheralList = [NSMutableArray new];
    for (CBPeripheralExt * peripheral in [[CBManager sharedManager] foundPeripherals])
    {
        if (peripheral.mPeripheral.name.length > 0)
        {
            if ([[peripheral.mPeripheral.name lowercaseString] rangeOfString:[searchString lowercaseString]].location != NSNotFound)
            {
                [filteredPeripheralList addObject:peripheral];
            }
        }
        else
        {
            if ([[LOCALIZEDSTRING(@"unknownPeripheral") lowercaseString] rangeOfString:[searchString lowercaseString]].location != NSNotFound)
            {
                [filteredPeripheralList addObject:peripheral];
            }
        }
    }
    finish((NSArray *)filteredPeripheralList);
}

#pragma mark - RefreshControl
/*!
 *  @method addRefreshControl
 *
 *  @discussion Method to add a control for pull to refresh functonality .
 *
 */
-(void)addRefreshControl
{
    refreshPeripheralListControl=[[UIRefreshControl alloc]init];
    [refreshPeripheralListControl addTarget:self action:@selector(refreshPeripheralList:) forControlEvents:UIControlEventValueChanged];
    [_scannedPeripheralsTableView addSubview:refreshPeripheralListControl];
}

#pragma mark - TableView Datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return isBluetoothON ? LOCALIZEDSTRING(@"pullToRefresh") : LOCALIZEDSTRING(@"bluetoothTurnOnAlert") ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    [header.textLabel setTextColor:[UIColor colorWithRed:12.0/255.0 green:55.0/255.0 blue:123.0/255.0 alpha:1.0]];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isBluetoothON) {
        
        if (isSearchActive) {
            return searchResults.count;
        }
        return [[[CBManager sharedManager] foundPeripherals] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScannedPeripheralTableViewCell *currentCell=[tableView dequeueReusableCellWithIdentifier:PERIPHERAL_CELL_IDENTIFIER];
    if (isSearchActive) {
        [currentCell setDiscoveredPeripheralDataFromPeripheral:[searchResults objectAtIndex:indexPath.row] ];
    }else{
        [currentCell setDiscoveredPeripheralDataFromPeripheral:[[[CBManager sharedManager] foundPeripherals] objectAtIndex:indexPath.row] ];
    }
    
    return currentCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *cellBGImageView=[[UIImageView alloc]initWithFrame:cell.bounds];
    UIImage *buttonImage = [[UIImage imageNamed:CELL_BG_IMAGE]resizableImageWithCapInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
    [cellBGImageView setImage:buttonImage];
    cell.backgroundView=cellBGImageView;
}


#pragma mark - TableView Delegates

/*!
 *  @method tableView: didSelectRowAtIndexPath:
 *
 *  @discussion Method to handle the device selection
 *
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isBluetoothON) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self connectPeripheral:indexPath.row];
    }
}


#pragma mark -Table Update

/*!
 *  @method refreshPeripheralList:
 *
 *  @discussion Method to refresh the device list
 *
 */
-(void)refreshPeripheralList:(UIRefreshControl*) refreshControl
{
    if(refreshControl)
    {
        [refreshControl endRefreshing];
        [[CBManager sharedManager] refreshPeripherals];
    }
}


#pragma mark - TableView Refresh

/*!
 *  @method reloadPeripheralTable
 *
 *  @discussion Method to reload the device list
 *
 */
-(void)reloadPeripheralTable
{
    if (!isSearchActive)
    {
        [_scannedPeripheralsTableView reloadData];
    }
}

-(void)discoveryDidRefresh
{
    [self reloadPeripheralTable];
}


#pragma mark - BlueTooth Turned Off Delegate

/*!
 *  @method bluetoothStateUpdatedToState:
 *
 *  @discussion Method to be called when state of Bluetooth changes
 *
 */
-(void)bluetoothStateUpdatedToState:(BOOL)state
{
    //NSLog(@"Log - BLE is On = %@", state ? @"Yes" : @"No");
    
    isBluetoothON = state;
    [self reloadPeripheralTable];
    isBluetoothON ? [_scannedPeripheralsTableView setScrollEnabled:YES] : [_scannedPeripheralsTableView setScrollEnabled:NO];
}


#pragma mark - Connect Peripheral

/*!
 *  @method connectPeripheral:
 *
 *  @discussion Method to connect the selected peripheral
 *
 */
-(void)connectPeripheral:(NSInteger)index
{
    if ([[CBManager sharedManager] foundPeripherals].count != 0)
    {
        CBPeripheralExt *selectedBLE = [[[CBManager sharedManager] foundPeripherals] objectAtIndex:index];
        //[[ProgressHandler sharedInstance] showWithDetailsLabel:LOCALIZEDSTRING(@"connecting") Detail:selectedBLE.mPeripheral.name];
        
        [[CBManager sharedManager] connectPeripheral:selectedBLE.mPeripheral CompletionBlock:^(BOOL success, NSError *error)
        {
            //[[ProgressHandler sharedInstance] hideProgressView];
            
            if(success)
            {
                //[self performSegueWithIdentifier:CAROUSEL_SEGUE sender:self];
            }
            else
            {
                if(error)
                {
                    NSString *errorString = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
                    
                    if(errorString.length)
                    {
                        NSLog(@"Log - User Alert - %@", errorString);
                        //[self.view makeToast:errorString];
                    }
                    else
                    {
                        NSLog(@"Log - User Alert - unknownError");
                        //[self.view makeToast:LOCALIZEDSTRING(@"unknownError")];
                    }
                }
            }
        }];
    }
    else
    {
        [[CBManager sharedManager] refreshPeripherals];
    }
}

@end
