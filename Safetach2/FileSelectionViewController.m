/*
 * File Name:	FileSelectionViewController.m
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


#import "FileSelectionViewController.h"

@interface FileSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FileSelectionViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //FilePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    [self buildFileList];
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTouchUp:(id)sender
{
    UIButton *button = sender;
    
    switch(button.tag)
    {
        case 1: /* Help button */
            
        break;
            
        case 2: /* Edit button */
            
        break;
            
        case 3: /* Delete button */
            
        break;
    }
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //if(!isDataLoading)  // if data loading has been completed, return the number of rows ELSE return 1
    {
        
        if([RunDataFiles count] > 0)
        {
            return [RunDataFiles count];
        }
        else
        {
            return 1;
        }
    }
    
    //return 1;
    //return [FilePathsArray count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //FilePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    cell.textLabel.text = [RunDataFiles objectAtIndex:indexPath.row];
    
    return cell;
    
}


-(void) buildFileList
{
    NSMutableArray *filelist;
    NSString *item;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FilePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
    RunDataFiles = [FilePathsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.csv'"]];
    
    
    
}

@end
