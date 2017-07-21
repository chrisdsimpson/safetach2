/*
 * File Name:	RideServiceModel.h
 *
 * Version      1.0.0
 *
 * Date:		07/21/2017
 *
 * Description:
 *   This is Bluetooth service model for ride data for the iOS Safetach2 project.
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

@interface RideServiceModel : NSObject

/*!
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */
-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler;


/*!
 *  @method writeValueForCTRL:
 *
 *  @discussion Method to write value for ctrl characteristic
 *
 */
-(void) writeValueForCTRL:(NSInteger)ctrlvalue;


/*!
 *  @method writeValueForCTRL:ctrlvalue:With
 *
 *  @discussion Write value to specified characteristic.
 */
-(void)writeValueForCTRL:(NSInteger)ctrlvalue With:(void (^) (BOOL success, NSError *error))handler;


/*!
 *  @method startUpdate
 *
 *  @discussion Starts notifications or indications for the value of a specified characteristic.
 */
-(void)startUpdate;


/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */
-(void)stopUpdate;


/*!
 *  @property xData
 *
 *  @discussion X axis accel data
 *
 */
@property (nonatomic , assign ) NSInteger xData;


/*!
 *  @property yData
 *
 *  @discussion  Y axis accel data
 *
 */
@property (nonatomic , assign ) NSInteger yData;


/*!
 *  @property zData
 *
 *  @discussion Z axis accel data
 *
 */
@property (nonatomic , assign ) NSInteger zData;


/*!
 *  @property lData
 *
 *  @discussion audio level data
 *
 */
@property (nonatomic , assign ) NSInteger lData;


/*!
 *  @property fData
 *
 *  @discussion audio frequency data
 *
 */
@property (nonatomic , assign ) NSInteger fData;


@end
