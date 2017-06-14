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
#import "Constants.h"

@implementation DeviceRWData
@synthesize FileManager;
@synthesize HomeDir;
@synthesize FileName;
@synthesize FilePath;


-(NSString *) SetFileName
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:RIDE_DATA_FILE_DATE_TIME_FORMAT];
    
    /* Format the ride data file name */
    FileName = [NSString stringWithFormat:@"st_%@.csv", [dateFormat stringFromDate:[NSDate date]]];
    
    return FileName;
}


/*
 * Get a handle on the directory where to write and read our files. If
 * it doesn't exist, it will be created.
 */
-(NSString *) GetDocumentsDirectory
{
    FileManager = [NSFileManager defaultManager];
    HomeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return HomeDir;
}


/* Create the new ride data file */
-(void) CreateRideDataFile
{
    FilePath = [[NSString alloc] init];
    NSError *err;
    
    FilePath = [self.GetDocumentsDirectory stringByAppendingPathComponent:self.SetFileName];
    
    BOOL ok = [@"" writeToFile:FilePath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    
    if(!ok)
    {
        NSLog(@"Log - Error writing ride data file at %@\n%@", FilePath, [err localizedFailureReason]);
    }
}


/* Open the file path for the file */
-(void) OpenRideDataFile:(NSString *)fileName
{
    FilePath = [[NSString alloc] init];
    FilePath = [self.GetDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    if(![FileManager fileExistsAtPath:FilePath])
    {
        NSLog(@"Log - Error no ride data file at %@", FilePath);
    }
}


/* Write a new line to the ride data file */
-(void) WriteLineRideDataFile:(NSString *)textToWrite
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:RIDE_DATA_DATE_TIME_FORMAT];
    
    NSString *tstr = [NSString stringWithFormat:@"%@, %@\r\n", [dateFormat stringFromDate:[NSDate date]], textToWrite];
   
    if([FileManager fileExistsAtPath:FilePath])
    {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:FilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[tstr dataUsingEncoding:NSUnicodeStringEncoding]];
        [fileHandle closeFile];
    }
}


/* Read the next line from the ride data file */
-(NSArray *) ReadLineRideDataFile:(NSString *)fileName
{
    NSError *error;
    NSArray *lines;
    
    FilePath = [[NSString alloc] init];
    FilePath = [self.GetDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    if([FileManager fileExistsAtPath:FilePath])
    {
        NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:FilePath encoding:NSUnicodeStringEncoding error:&error];
        
        if(!txtInFile)
        {
            NSLog(@"Log - Error reading ride data file at %@\n%@", FilePath, [error localizedFailureReason]);
        }
    
        lines = [txtInFile componentsSeparatedByString:@"\r\n"];
    }
    else
    {
        NSLog(@"Log - Error reading ride data file at %@", FilePath);
    }
    
    return lines;
}


/* Create a new file */
-(void) WriteToStringFile:(NSMutableString *)textToWrite
{
    FilePath = [[NSString alloc] init];
    NSError *err;
    
    NSMutableString *tstr = [NSMutableString stringWithFormat:@"%@\r\n", textToWrite];
    
    
    FilePath = [self.GetDocumentsDirectory stringByAppendingPathComponent:self.SetFileName];
    
    if(![FileManager fileExistsAtPath:FilePath])
    {
        BOOL ok = [tstr writeToFile:FilePath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
        
        if(!ok)
        {
            NSLog(@"Log - Error writing ride data file at %@\n%@", FilePath, [err localizedFailureReason]);
        }
    }
    else
    {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:FilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[tstr dataUsingEncoding:NSUnicodeStringEncoding]];
    }
    
}


/*
 *  Read the contents from file
 */
-(NSString *) ReadFromFile
{
    FilePath = [[NSString alloc] init];
    NSError *error;
    //NSString *title;
    FilePath = [self.GetDocumentsDirectory stringByAppendingPathComponent:self.SetFileName];
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
