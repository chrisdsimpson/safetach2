/*
 * File Name:	DeviceRWData.m
 *
 * Version      1.0.0
 *
 * Date:		06/13/2017
 *
 * Description:
 *   This is ride data file read/write class for the iOS Safetach2 project.
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

#import "DeviceRWData.h"

@implementation DeviceRWData
@synthesize FileManager;
@synthesize HomeDir;
@synthesize FileName;
@synthesize FilePath;


-(NSString *) setFilename
{
    FileName = @"mytextfile.txt";
    return FileName;
}


/*
 * Get a handle on the directory where to write and read our files. If
 * it doesn't exist, it will be created.
 */
-(NSString *)GetDocumentDirectory
{
    FileManager = [NSFileManager defaultManager];
    HomeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return HomeDir;
}


/* Create a new file */
-(void)WriteToStringFile:(NSMutableString *)textToWrite
{
    FilePath = [[NSString alloc] init];
    NSError *err;
    
    FilePath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    
    BOOL ok = [textToWrite writeToFile:FilePath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    
    if(!ok)
    {
        NSLog(@"Error writing file at %@\n%@", FilePath, [err localizedFailureReason]);
    }
}


/*
 *  Read the contents from file
 */
-(NSString *) readFromFile
{
    FilePath = [[NSString alloc] init];
    NSError *error;
    //NSString *title;
    FilePath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:FilePath encoding:NSUnicodeStringEncoding error:&error];
    
    if(!txtInFile)
    {
        
        NSLog(@"Error writing file at %@\n%@", FilePath, [error localizedFailureReason]);
        //UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get text from file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[tellErr show];
    }
    return txtInFile;
}

@end
