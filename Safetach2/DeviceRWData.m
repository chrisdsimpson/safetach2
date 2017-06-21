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


-(NSString *) setFileName
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
-(NSString *) getDocumentsDirectory
{
    FileManager = [NSFileManager defaultManager];
    HomeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return HomeDir;
}


/* Create the new ride data file */
-(void) createRideDataFile
{
    FilePath = [[NSString alloc] init];
    NSError *err;
    
    FilePath = [self.getDocumentsDirectory stringByAppendingPathComponent:self.setFileName];
    
    BOOL ok = [@"" writeToFile:FilePath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    
    if(!ok)
    {
        NSLog(@"Log - Error writing ride data file at %@\n%@", FilePath, [err localizedFailureReason]);
    }
}


/* Open the file path for the file */
-(void) openRideDataFile:(NSString *)fileName
{
    FilePath = [[NSString alloc] init];
    FilePath = [self.getDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    if(![FileManager fileExistsAtPath:FilePath])
    {
        NSLog(@"Log - Error no ride data file at %@", FilePath);
    }
}


/* Write a new line to the ride data file */
-(void) writeLineRideDataFile:(NSString *)textToWrite
{
    NSError *error = nil;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:RIDE_DATA_DATE_TIME_FORMAT];
    
    NSString *tstr = [NSString stringWithFormat:@"%@, %@\r\n", [dateFormat stringFromDate:[NSDate date]], textToWrite];
   
    if([FileManager fileExistsAtPath:FilePath])
    {
        /* Less efficient but pure text data */
        NSString *contents = [NSString stringWithContentsOfFile:FilePath encoding:NSUnicodeStringEncoding error:&error];
        contents = [contents stringByAppendingString:tstr];
        [contents writeToFile:FilePath atomically:YES encoding:NSUnicodeStringEncoding error:&error];
        
        /* More efficient but inserts non string data in the file */
        //NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:FilePath];
        //[fileHandle seekToEndOfFile];
        //[fileHandle writeData:[tstr dataUsingEncoding:NSUnicodeStringEncoding]];
        //[fileHandle closeFile];
    }
}


/* Read the lines from the ride data file */
-(NSArray *) readLineRideDataFile:(NSString *)fileName
{
    NSError *error;
    NSArray *lines;
    
    FilePath = [[NSString alloc] init];
    FilePath = [self.getDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    if([FileManager fileExistsAtPath:FilePath])
    {
        NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:FilePath encoding:NSUnicodeStringEncoding error:&error];
        
        if(!txtInFile)
        {
            NSLog(@"Log - Error reading ride data file at %@\n%@", FilePath, [error localizedFailureReason]);
        }
    
        lines = [txtInFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    else
    {
        NSLog(@"Log - Error reading ride data file at %@", FilePath);
    }
    
    return lines;
}


/* Get the reformatted date and time from the file name */
-(NSString *) getRideDataFileDateTime:(NSString *)fileName
{
    NSString *retval;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    /* Set the date format to match the file name */
    [dateFormat setDateFormat:RIDE_DATA_FILE_DATE_TIME_FORMAT];
    
    /* Strip of the file extention leading text from the file name */
    NSString *tstr = [fileName substringWithRange:NSMakeRange(3, 15)];
    
    /* Create date object from the file name */
    NSDate *dt = [dateFormat dateFromString:tstr];
    
    /* Reset the date format to match our output format */
    [dateFormat setDateFormat:RIDE_DATA_FILE_LIST_FORMAT];
    
    /* Format the date and time from the file name date and time */
    retval = [dateFormat stringFromDate:dt];
    
    return retval;
}


/* Read the next line from the ride data file */
-(NSArray *) readLineRideDataFile
{
    NSError *error;
    NSArray *lines;
    
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


/* Create a new file with the contents of textToWrite */
-(void) writeToStringFile:(NSMutableString *)textToWrite
{
    FilePath = [[NSString alloc] init];
    NSError *err;
    
    NSMutableString *tstr = [NSMutableString stringWithFormat:@"%@\r\n", textToWrite];
    
    
    FilePath = [self.getDocumentsDirectory stringByAppendingPathComponent:self.setFileName];
    
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
        [fileHandle closeFile];
    }
}


/* Read the contents from file */
-(NSString *) readFromFile
{
    FilePath = [[NSString alloc] init];
    NSError *error;
    
    FilePath = [self.getDocumentsDirectory stringByAppendingPathComponent:self.setFileName];
    NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:FilePath encoding:NSUnicodeStringEncoding error:&error];
    
    if(!txtInFile)
    {
        NSLog(@"Error writing file at %@\n%@", FilePath, [error localizedFailureReason]);
    }
    
    return txtInFile;
}

@end
