/*
 * File Name:	ViewController.h
 *
 * Version      1.0.0
 *
 * Date:		05/22/2017
 *
 * Description:
 *   This is main view controller for the iOS Safetach2 project.
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


#import <UIKit/UIKit.h>
#import "DeviceRWData.h"
#import "FileSelectionViewController.h"
#import "CBManager.h"
#import "CBPeripheralExt.h"

@import Charts;





/* Globals */
UIButton *LastButtonClicked;

UIButton *Button01;
UIButton *Button02;
UIButton *Button03;
UIButton *Button04;
UIButton *Button05;
UIButton *Button06;

int MenuState;
int SubMenuState;
int FileListingMode;

NSMutableArray *XAxisData;
NSMutableArray *YAxisData;
NSMutableArray *ZAxisData;
NSMutableArray *AudioSPLData;
NSMutableArray *AudioFREQDatal;

NSMutableArray *RideData;

DeviceRWData *RWData = nil;
NSUserDefaults *DefaultValues;


@interface ViewController : UIViewController <FileSelectionViewControllerDelegate, cbDiscoveryManagerDelegate>



@property (weak, nonatomic) IBOutlet UIButton *Button1;
@property (weak, nonatomic) IBOutlet UIButton *Button2;
@property (weak, nonatomic) IBOutlet UIButton *Button3;
@property (weak, nonatomic) IBOutlet UIButton *Button4;
@property (weak, nonatomic) IBOutlet UIButton *Button5;
@property (weak, nonatomic) IBOutlet UIButton *Button6;

@property (weak, nonatomic) IBOutlet UIImageView *MainScreen1;
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BluetoothMenuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BatteryMenuButton;

- (IBAction)didTouchUp:(id)sender;


@end

