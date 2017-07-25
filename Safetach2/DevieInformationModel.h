/*
 * File Name:	DeviceInformationModel.h
 *
 * Version      1.0.0
 *
 * Date:		07/21/2017
 *
 * Description:
 *   This is Bluetooth service model for device information data for the iOS Safetach2 project.
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

@interface DevieInformationModel : NSObject

/*!
 *  @method startDiscoverChar:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */

-(void)startDiscoverChar:(void (^) (BOOL success, NSError *error))handler;

/*!
 *  @method discoverCharacteristicValues:
 *
 *  @discussion Read values for the various characteristics in the service
 */

-(void) discoverCharacteristicValues:(void(^)(BOOL success, NSError *error))handler;

/*!
 *  @property deviceInfoCharValueDictionary
 *
 *  @discussion Dictionary contains the basic informations of service characteristic
 *
 */
@property(nonatomic,retain) NSMutableDictionary *deviceInfoCharValueDictionary;

@end
