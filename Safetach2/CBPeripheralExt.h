/*
 * File Name:	CBPeripheralExt.h
 *
 * Version      1.0.0
 *
 * Date:		06/08/2017
 *
 * Description:
 *   This is Core Bluetooth peripheral support class for the iOS Safetach2 project.
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
@import CoreBluetooth;

/*!
 *  @class CBPeripheralExt
 *
 *  @discussion Model class for handling the external peripheral
 *
 */

@interface CBPeripheralExt : NSObject

/*!
 *  @property mPeripheral
 *
 *  @discussion  Represents a peripheral.
 *
 */


@property (nonatomic, retain)CBPeripheral		*mPeripheral;

/*!
 *  @property mAdvertisementData
 *
 *  @discussion  A dictionary containing any advertisement and scan response data.
 *
 */
@property (nonatomic, retain)NSDictionary		*mAdvertisementData;

/*!
 *  @property mRSSI
 *
 *  @discussion   The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
 *							was not available.
 *
 */
@property (nonatomic, retain)NSNumber           *mRSSI;

@end
