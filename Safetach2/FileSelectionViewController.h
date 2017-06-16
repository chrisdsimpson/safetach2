/*
 * File Name:	FileSelectionViewController.h
 *
 * Version      1.0.0
 *
 * Date:		06/16/2017
 *
 * Description:
 *   This is view controller class for run file selection for the iOS Safetach2 project.
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


@interface FileSelectionViewController : UIViewController
{
    NSArray *FilePathsArray;
    NSArray *RunDataFiles;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *HelpButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *EditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *DeleteButton;

@property (weak, nonatomic) IBOutlet UITableView *FileListingsTableView;

- (IBAction)didTouchUp:(id)sender;

@end
