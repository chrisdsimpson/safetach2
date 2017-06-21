/*
 * File Name:	DeviceRWData.h
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


#import <Foundation/Foundation.h>

@interface DeviceRWData : NSObject
{
    NSFileManager *FileManager;
    NSString *HomeDir;
    NSString *FileName;
    NSString *FilePath;
}

@property (nonatomic, retain) NSFileManager *FileManager;
@property (nonatomic, retain) NSString *HomeDir;
@property (nonatomic, retain) NSString *FileName;
@property (nonatomic, retain) NSString *FilePath;

-(NSString *) getDocumentsDirectory;
-(void) writeToStringFile:(NSMutableString *)textToWrite;
-(NSString *) readFromFile;
-(NSString *) setFileName;
-(void) createRideDataFile;
-(void) openRideDataFile:(NSString *)fileName;
-(NSString *) getRideDataFileDateTime:(NSString *)fileName;
-(void) writeLineRideDataFile:(NSString *)textToWrite;
-(NSArray *) readLineRideDataFile:(NSString *)fileName;
-(NSArray *) readLineRideDataFile;

@end




