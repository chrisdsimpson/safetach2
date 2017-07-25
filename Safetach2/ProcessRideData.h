/*
 * File Name:	ProcessRideData.h
 *
 * Version      1.0.0
 *
 * Date:		07/25/2017
 *
 * Description:
 *   This is class that processes the data from the ride data file for the iOS Safetach2 project.
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
#import <UIKit/UIKit.h>

@interface ProcessRideData : NSObject

-(NSArray *) getRawXGData;
-(NSArray *) getRawXMGData;
-(NSArray *) getRawYGData;
-(NSArray *) getRawYMGData;
-(NSArray *) getRawZGData;
-(NSArray *) getRawZMGData;
-(NSArray *) getRawSPLData;
-(NSArray *) getRawSPFData;
-(NSArray *) getVelocityDataIMP;
-(NSArray *) getVelocityDataMET;
-(NSArray *) getJerkData;
-(NSArray *) getJerkDataIMP;
-(NSArray *) getJerkDataMET;
-(NSString *) getHiSpeedVelocityIMPStr;
-(double) getHiSpeedVelocityIMP;
-(NSString *) getHiSpeedVelocityMETStr;
-(double) getHiSpeedVelocityMET;
-(NSString *) getHiSpeedTimeStr;
-(double) getHiSpeedTime;
-(NSString *) getLvSpeedVelocityIMPStr;
-(double) getLvSpeedVelocityIMP;
-(NSString *) getLvSpeedVelocityMETStr;
-(double) getLvSpeedVelocityMET;
-(NSString *) getLvSpeedTimeStr;
-(double) getLvSpeedTime;
-(NSString *) getStartAccelerationStr;
-(NSString *) getStartAccelerationMGStr;
-(double) getStartAcceleration;
-(NSString *) getHiAccelerationStr;
-(NSString *) getHiAccelerationMGStr;
-(double) getHiAcceleration;
-(NSString *) getDecelAccelerationStr;
-(NSString *) getDecelAccelerationMGStr;
-(double) getDecelAcceleration;
-(NSString *) getStopAccelerationStr;
-(NSString *) getStopAccelerationMGStr;
-(double) getStopAcceleration;
-(NSString *) getTotalRunTimeStr;
-(double) getTotalRunTime;
-(NSString *) getJerkVelocityIMPStr;
-(double) getJerkVelocityIMP;
-(NSString *) getJerkVelocityMETStr;
-(double) getJerkVelocityMET;
-(double) getPeakStartJerkIMP;
-(NSString *) getPeakStartJerkIMPStr;
-(double) getMaxZJerk;
-(NSString *) getMaxZJerkStr;
-(double) getMinZJerk;
-(NSString *) getMinZJerkStr;
-(NSString *) getHiXAccelerationStr;
-(NSString *) getHiXAccelerationMGStr;
-(double) getHiXAcceleration;
-(NSString *) getHiYAccelerationStr;
-(NSString *) getHiYAccelerationMGStr;
-(double) getHiYAcceleration;
-(double) getMaxSPLdBValue;
-(NSString *) getMaxSPLdBValueStr;
-(double) getMaxSPLFrequency;
-(NSString *) getMaxSPLFrequencyStr;
-(int) getRunLength;
-(BOOL) getRunDirectionUp;
-(int) getRideMode;
-(int) getRideDirection;
-(int) getRideSize;
-(int) getRideType;
-(int) getRideId;
-(NSDate *) getRideDate;
-(double) getXCalibrationVal;
-(double) getYCalibrationVal;
-(double) getZCalibrationVal;
-(double) getMinX;
-(double) getMaxX;
-(double) getMinY;
-(double) getMaxY;
-(double) getMinZ;
-(double) getMaxZ;
-(double) getMinZVelocityIMP;
-(double) getMaxZVelocityIMP;
-(double) getMinZVelocityMET;
-(double) getMaxZVelocityMET;
-(NSString *) getJobRef;
-(NSString *) getElevatorNum;
-(NSString *) getElevatorType;
-(NSString *) getUserName;
-(NSString *) getNotes;
-(UIColor *) getHiSpeedVelocityColor;
-(UIColor *) getHiSpeedTimeColor;
-(UIColor *) getLvSpeedVelocityColor;
-(UIColor *) getLvSpeedTimeColor;
-(UIColor *) getStartAccelerationColor;
-(UIColor *) getStartAccelerationMGColor;
-(UIColor *) getHiAccelerationColor;
-(UIColor *) getHiAccelerationMGColor;
-(UIColor *) getDecelAccelerationColor;
-(UIColor *) getDecelAccelerationMGColor;
-(UIColor *) getStopAccelerationColor;
-(UIColor *) getStopAccelerationMGColor;
-(UIColor *) getTotalRunTimeColor;
-(UIColor *) getJerkVelocityColor;
-(UIColor *) getMaxSPLdBValueColor;
-(UIColor *) getMaxSPLFrequencyColor;
-(UIColor *) getHiXAccelerationColor;
-(UIColor *) getHiYAccelerationColor;
-(int) getHiSpeedVelocityRange;
-(int) getHiSpeedTimeRange;
-(int) getLvSpeedVelocityRange;
-(int) getLvSpeedTimeRange;
-(int) getStartAccelerationRange;
-(int) getStartAccelerationMGRange;
-(int) getHiAccelerationRange;
-(int) getHiAccelerationMGRange;
-(int) getDecelAccelerationRange;
-(int) getDecelAccelerationMGRange;
-(int) getStopAccelerationRange;
-(int) getStopAccelerationMGRange;
-(int) getTotalRunTimeRange;
-(int) getJerkVelocityRange;
-(int) getMaxSPLdBValueRange;
-(int) getMaxSPLFrequencyRange;
-(int) getHiXAccelerationRange;
-(int) getHiYAccelerationRange;


@end

