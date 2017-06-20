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
#import "DeviceRWData.h"

@interface FileSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FileSelectionViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    if([SortedRunDataFiles count] > 0)
    {
        return [SortedRunDataFiles count];
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    cell.textLabel.text = [SortedRunDataFiles objectAtIndex:indexPath.row];
    
    return cell;
    
}


-(void) buildFileList
{
    NSError *error;
    NSString *filedatetime;
    NSString *direction;
    NSString *jobref;
    NSString *elevatorname;
    NSMutableArray *rundatafilenames;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FilePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
    RunDataFiles = [FilePathsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.csv'"]];
    
    
    /* Sort by creation date */
    NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[RunDataFiles count]];
    
    for(NSString* file in RunDataFiles)
    {
        NSString* filePath = [documentsDirectory stringByAppendingPathComponent:file];
        NSDictionary* properties = [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:&error];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
        
        if(error == nil)
        {
            [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:file, @"path", modDate, @"lastModDate", nil]];
        }
    }
    
    /* Sort using a block */
    /* Order inverted as we want latest date first */
    NSArray *sortedFiles = [filesAndProperties sortedArrayUsingComparator:^(id path1, id path2)
        {
            // compare
            NSComparisonResult comp = [[path1 objectForKey:@"lastModDate"] compare:[path2 objectForKey:@"lastModDate"]];
            
            // invert ordering
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
    SortedRunDataFiles = [sortedFiles valueForKey:@"path"];
    
    /* Create a instance of the ride data file read/write class */
    DeviceRWData *rwdata = [[DeviceRWData alloc] init];

    
    for(NSString *filename in SortedRunDataFiles)
    {
        
        /* Open the file and read the lines */
        NSArray *lines = [rwdata ReadLineRideDataFile:filename];
  
        /* Get the header line from the ride data file */
        NSString *header = [lines objectAtIndex:0];
        
        /* Split the header into seperate strings */
        NSArray *headerparts = [header componentsSeparatedByString:@","];
        
        /* Get the packet mode info */
        NSString *packetmode = [headerparts objectAtIndex:5];
        
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
            jobref = [headerparts objectAtIndex:6];
            elevatorname = [headerparts objectAtIndex:8];
        }
        
        
        /* Build the display string */
        [rundatafilenames addObject:[NSString stringWithFormat:@"%@ %@ %@ %@", filedatetime, direction, jobref, elevatorname]];
    
    }

    
}

@end
