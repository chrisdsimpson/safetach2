/*
 * File Name:	ScannedPeripheralTableViewCell.m
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

#import "ScannedPeripheralTableViewCell.h"
#import "CBPeripheralExt.h"
#import "Constants.h"


/*!
 *  @class ScannedPeripheralTableViewCell
 *
 *  @discussion Model class for handling operations related to peripheral table cell
 *
 */
@implementation ScannedPeripheralTableViewCell
{
    /*  Data fields  */
    __weak IBOutlet UILabel *RSSIValueLabel;
    __weak IBOutlet UILabel *peripheralAdressLabel;
    __weak IBOutlet UILabel *peripheralName;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*!
 *  @method nameForPeripheral:
 *
 *  @discussion Method to get the peripheral name
 *
 */
-(NSString *)nameForPeripheral:(CBPeripheralExt *)ble
{
    NSString *bleName ;
    
    if ([ble.mAdvertisementData valueForKey:CBAdvertisementDataLocalNameKey] != nil)
    {
        bleName = [ble.mAdvertisementData valueForKey:CBAdvertisementDataLocalNameKey];
    }
    
    // If the peripheral name is not found in advertisement data, then check whether it is there in peripheral object. If it's not found then assign it as unknown peripheral
    
    if(bleName.length < 1 )
    {
        if (ble.mPeripheral.name.length > 0) {
            bleName = ble.mPeripheral.name;
        }
        else
            bleName = LOCALIZEDSTRING(@"unknownPeripheral");
    }
    
    return bleName;
}


/*!
 *  @method UUIDStringfromPeripheral:
 *
 *  @discussion Method to get the UUID from the peripheral
 *
 */
-(NSString *)UUIDStringfromPeripheral:(CBPeripheralExt *)ble
{
    
    NSString *bleUUID = ble.mPeripheral.identifier.UUIDString;
    if(bleUUID.length < 1 )
        bleUUID = @"Nil";
    else
        bleUUID = [NSString stringWithFormat:@"UUID: %@",bleUUID];
    
    return bleUUID;
}

/*!
 *  @method ServiceCountfromPeripheral:
 *
 *  @discussion Method to get the number of services present in a device
 *
 */
-(NSString *)ServiceCountfromPeripheral:(CBPeripheralExt *)ble
{
    NSString *bleService =@"";
    NSInteger serViceCount = [[ble.mAdvertisementData valueForKey:CBAdvertisementDataServiceUUIDsKey] count];
    if(serViceCount < 1 )
        bleService = LOCALIZEDSTRING(@"noServices");
    else
        bleService = [NSString stringWithFormat:@" %ld Service Advertised ",(long)serViceCount];
    
    return bleService;
}

#define RSSI_UNDEFINED_VALUE 127


/*!
 *  @method RSSIValue:
 *
 *  @discussion Method to get the RSSI value
 *
 */
-(NSString *)RSSIValue:(CBPeripheralExt *)ble
{
    NSString *deviceRSSI=[ble.mRSSI stringValue];
    
    if(deviceRSSI.length < 1 )
    {
        if([ble.mPeripheral respondsToSelector:@selector(RSSI)])
            deviceRSSI = ble.mPeripheral.RSSI.stringValue;
    }
    
    if([deviceRSSI intValue]>=RSSI_UNDEFINED_VALUE)
        deviceRSSI = LOCALIZEDSTRING(@"undefined");
    else
        deviceRSSI=[NSString stringWithFormat:@"%@ dBm",deviceRSSI];
    
    return deviceRSSI;
}


/*!
 *  @method setDiscoveredPeripheralDataFromPeripheral:
 *
 *  @discussion Method to display the device details
 *
 */
-(void)setDiscoveredPeripheralDataFromPeripheral:(CBPeripheralExt*) discoveredPeripheral
{
    peripheralName.text         = [self nameForPeripheral:discoveredPeripheral];
    peripheralAdressLabel.text  = [self ServiceCountfromPeripheral:discoveredPeripheral];
    RSSIValueLabel.text         = [self RSSIValue:discoveredPeripheral];
}

/*!
 *  @method updateRSSIWithValue:
 *
 *  @discussion Method to update the RSSI value of a device
 *
 */
-(void)updateRSSIWithValue:(NSString*) newRSSI
{
    RSSIValueLabel.text=newRSSI;
}
@end
