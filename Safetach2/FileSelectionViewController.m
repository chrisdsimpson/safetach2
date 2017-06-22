/*
 * File Name:	FileSelectionViewController.m
 *
 * Version      1.0.0
 *
 * Date:		06/22/2017
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
#import "FileSelectionTableViewCell.h"
#import "DeviceRWData.h"
#import "Constants.h"

static NSString *CellIdentifier = @"FileSelectionCell";


@interface FileSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FileSelectionViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* Register the class for the Cell Reuse Identifier */
    [self.FileListingsTableView registerClass:[FileSelectionTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    /* Set the tableview to allow more than one selection */
    self.FileListingsTableView.allowsMultipleSelection = true;
    NumSelectedRows = 1;
    
    NSLog(@"Log - FileListingMode = %d", self.FileListingMode);
    
    if(self.FileListingMode == FILE_LISTING_MODE_EDIT)
    {
        NumSelectableRows = 1;
    }
    else
    {
        NumSelectableRows = 8;
    }
    
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
    if([FormattedRowData count] > 0)
    {
        return [FormattedRowData count];
    }
    else
    {
        return 1;
    }
}

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(NumSelectedRows > NumSelectableRows)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *selectedFiles = [[NSMutableArray alloc] init];;
    NSArray *selectedRows = [tableView indexPathsForSelectedRows];
    
    NumSelectedRows++;
    
    for(NSIndexPath *index in selectedRows)
    {
         NSString *filename = [FormattedRowData objectAtIndex:index.row][@"key_filename"];
        [selectedFiles addObject:filename];
    }
    
    SelectedFiles = selectedFiles;
    
    if(self.FileListingMode == FILE_LISTING_MODE_EDIT)
    {
        /* Pass the file name back to the calling view controoler */
        [self.delegate addItem1ViewController:self didFinishEnteringItem:[SelectedFiles objectAtIndex:0]];
        
        /* Return to calling view controller */
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NumSelectedRows--;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileSelectionTableViewCell *cell = (FileSelectionTableViewCell *)
                                       [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.DateTime.text = [FormattedRowData objectAtIndex:indexPath.row][@"key_filedatetime"];
    cell.Direction.text = [FormattedRowData objectAtIndex:indexPath.row][@"key_direction"];
    cell.Jobref.text = [FormattedRowData objectAtIndex:indexPath.row][@"key_jobref"];
    cell.ElevatorName.text = [FormattedRowData objectAtIndex:indexPath.row][@"key_elevatorname"];
    
    return cell;
}


-(void) buildFileList
{
    NSError *error;
    NSString *filedatetime;
    NSString *direction;
    NSString *jobref;
    NSString *elevatorname;
    NSMutableArray *rundatafilenames = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filepaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSArray *rundatafiles = [filepaths filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.csv'"]];
    
    
    /* Sort by creation date */
    NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[rundatafiles count]];
    
    for(NSString* file in rundatafiles)
    {
        NSString* filePath = [documentsDirectory stringByAppendingPathComponent:file];
        NSDictionary* properties = [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:&error];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
        
        if(error == nil)
        {
            [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:file, @"path", modDate, @"fileCreationDate", nil]];
        }
    }
    
    /* Sort using a block and order inverted as we want latest date first */
    NSArray *sortedFiles = [filesAndProperties sortedArrayUsingComparator:^(id path1, id path2)
        {
            /* Do the compare */
            NSComparisonResult comp = [[path1 objectForKey:@"fileCreationDate"] compare:[path2 objectForKey:@"fileCreationDate"]];
            
            /* Now invert the ordering */
            if(comp == NSOrderedDescending)
            {
                comp = NSOrderedAscending;
            }
            else if(comp == NSOrderedAscending)
            {
                comp = NSOrderedDescending;
            }
            
            return comp;
        }];
    
    
    /* Sorted files */
    NSArray *sortedrundatafiles = [sortedFiles valueForKey:@"path"];
    
    /* Create a instance of the ride data file read/write class */
    DeviceRWData *rwdata = [[DeviceRWData alloc] init];
    
    for(NSString *filename in sortedrundatafiles)
    {
        /* Open the file and read the lines */
        NSArray *lines = [rwdata readLineRideDataFile:filename];
  
        /* Get the header line from the ride data file */
        NSString *header = [lines objectAtIndex:0];
        
        /* Split the header into seperate strings */
        NSArray *headerparts = [header componentsSeparatedByString:@","];
        
        /* Get the packet mode info */
        NSString *packetmode = TRIM([headerparts objectAtIndex:5]);
        
        /* Strip the run direction from the packet mode */
        int pm = [packetmode intValue];
        
        pm = pm & 0x0030;
        
        /* Get the correct text for the direction */
        if(pm == 0x0010)
        {
            direction = @"UP";
        }
        else
        {
            direction = @"DOWN";
        }
        
        /* Get the job refferenc and the elevator name if available */
        if([headerparts count] > 6)
        {
            jobref = TRIM([headerparts objectAtIndex:6]);
            elevatorname = TRIM([headerparts objectAtIndex:8]);
        }
        
        /* Get the string version of the ride data file date and time */
        filedatetime = [rwdata getRideDataFileDateTime:filename];
        
        /* Add the values to a dictionary */
        NSDictionary *cellvalues = [NSDictionary dictionaryWithObjectsAndKeys:filename, @"key_filename",
                                                                              filedatetime, @"key_filedatetime",
                                                                              direction, @"key_direction",
                                                                              jobref, @"key_jobref",
                                                                              elevatorname, @"key_elevatorname", nil];
        
        /* Add each record set to the array */
        [rundatafilenames addObject:cellvalues];
    }

    FormattedRowData = rundatafilenames;
}

@end
