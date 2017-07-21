/*
 * File Name:	BatteryServiceModel.h
 *
 * Version      1.0.0
 *
 * Date:		07/21/2017
 *
 * Description:
 *   This is Bluetooth service model for battery level data for the iOS Safetach2 project.
 *
 * Notes:
 *   This class is a port from the cypress cysmart application.
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
#import "CBManager.h"


@protocol BatteryCharacteristicDelegate <NSObject>

-(void)updateBatteryUI;

@end

@interface BatteryServiceModel : NSObject

/*!
 *  @property batteryServiceDict
 *
 *  @discussion Dictionary to store battery level value against battery service
 *
 */

@property(nonatomic,retain)NSMutableDictionary *batteryServiceDict;

@property (strong,nonatomic) id <BatteryCharacteristicDelegate> delegate;

/*!
 *  @property batteryCharacterisic
 *
 *  @discussion characteristic that represent battery level
 *
 */

@property (strong, nonatomic) CBCharacteristic *batteryCharacterisic;

/*!
 *  @method startDiscoverCharacteristicsWithCompletionHandler:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */

-(void)startDiscoverCharacteristicsWithCompletionHandler:(void (^)(BOOL success,NSError *error))handler;

/*!
 *  @method startUpdateCharacteristic
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */

-(void)startUpdateCharacteristic;

/*!
 *  @method readBatteryLevel
 *
 *  @discussion Method to read battery level value from characteristic
 *
 */
-(void) readBatteryLevel;

/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */

-(void)stopUpdate;

/*!
 *  @method handleBatteryCharacteristicValueWithChar:
 *
 *  @discussion Method to handle the characteristic value
 *
 */
-(void) handleBatteryCharacteristicValueWithChar:(CBCharacteristic *) characteristic;


@end
