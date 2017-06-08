/*
 * File Name:	ScannedPeripheralTableViewCell.h
 *
 * Version      1.0.0
 *
 * Date:		06/08/2017
 *
 * Description:
 *   This is BLE device scan class for the iOS Safetach2 project.
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

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ScannedPeripheralTableViewCell : UITableViewCell

/*!
 *  @method setDiscoveredPeripheralDataFromPeripheral:
 *
 *  @discussion Method to display the device details
 *
 */
-(void)setDiscoveredPeripheralDataFromPeripheral:(CBPeripheral*) discoveredPeripheral ;

/*!
 *  @method updateRSSIWithValue:
 *
 *  @discussion Method to update the RSSI value of a device
 *
 */

-(void)updateRSSIWithValue:(NSString*) newRSSI;

@end
