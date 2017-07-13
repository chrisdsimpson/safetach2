/*
 * File Name:	InfoViewController.h
 *
 * Version      1.0.0
 *
 * Date:		07/13/2017
 *
 * Description:
 *   This is info view controller for the iOS Safetach2 project.
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

@interface InfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *ModelNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *SerialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *HardwareLabel;
@property (weak, nonatomic) IBOutlet UILabel *FirmwareLabel;

@end
