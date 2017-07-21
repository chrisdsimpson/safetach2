/*
 * File Name:	DeviceInformationModel.m
 *
 * Version      1.0.0
 *
 * Date:		07/21/2017
 *
 * Description:
 *   This is Bluetooth service model for device information data for the iOS Safetach2 project.
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



#import "DevieInformationModel.h"
#import "CBManager.h"
#import "Constants.h"
//#import "Utilities.h"

/*!
 *  @class DevieInformationModel
 *
 *  @discussion Class to handle the device information service related operations
 *
 */

@interface DevieInformationModel ()<cbCharacteristicManagerDelegate>
{
    void(^cbCharacteristicDiscoverHandler)(BOOL success, NSError *error);
    void(^cbCharacteristicHandler)(BOOL success, NSError *error);
    
    NSArray *deviceInfoCharArray;
    int charCount;
}

@end


@implementation DevieInformationModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (!_deviceInfoCharValueDictionary)
        {
            _deviceInfoCharValueDictionary = [NSMutableDictionary dictionary];
        }
        charCount = 0;
    }
    return self;
}


/*!
 *  @method startDiscoverChar:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */
-(void)startDiscoverChar:(void (^) (BOOL success, NSError *error))handler
{
    cbCharacteristicDiscoverHandler = handler;
    
    [[CBManager sharedManager] setCbCharacteristicDelegate:self];
    [[[CBManager sharedManager] myPeripheral] discoverCharacteristics:nil forService:[[CBManager sharedManager] myService]];
}

/*!
 *  @method discoverCharacteristicValues:
 *
 *  @discussion Read values for the various characteristics in the service
 */

-(void) discoverCharacteristicValues:(void(^)(BOOL success, NSError *error))handler
{
    cbCharacteristicHandler = handler;
    
    for (CBCharacteristic *aChar in deviceInfoCharArray)
    {
        //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:DEVICE_INFO_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:aChar.UUID] descriptor:nil operation:READ_REQUEST];
        
        [[[CBManager sharedManager] myPeripheral] readValueForCharacteristic:aChar];
    }
}



#pragma mark - CBCharacteristic manager delegate

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:DEVICE_INFO_SERVICE_UUID])
    {
        deviceInfoCharArray = service.characteristics;
        cbCharacteristicDiscoverHandler(YES,nil);
    }
    else
    {
        cbCharacteristicDiscoverHandler(NO,error);
    }
}

/*!
 *  @method didUpdateValueForCharacteristic:
 *
 *  @discussion  Method to get the basic information from the characteristic
 */


-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *charData = characteristic.value;
    
    /* Read the name of the manufacturer of the device from characteristic
     */
    if ([characteristic.UUID isEqual:DEVICE_INFO_MANUFACTURE_UUID])
    {
         NSString *manufactureName = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (manufactureName != nil)
        {
            [_deviceInfoCharValueDictionary setObject:manufactureName forKey:MANUFACTURER_NAME];
        }
    }
    /* Read the model number that is assigned by the device vendor from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_INFO_MODEL_UUID])
    {
        NSString *modelNumberString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (modelNumberString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:modelNumberString forKey:MODEL_NUMBER];
        }
    }
    /* Read the serial number for a particular instance of the device from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_INFO_SERIAL_UUID])
    {
        NSString *serialNumberString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (serialNumberString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:serialNumberString forKey:SERIAL_NUMBER];
        }
    }
    /* Read the hardware revision for the hardware within the device from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_INFO_HARDWARE_VERSION_UUID])
    {
        NSString *hardwareRevisionString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (hardwareRevisionString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:hardwareRevisionString forKey:HARDWARE_REVISION];
        }
    }
    else if ([characteristic.UUID isEqual:DEVICE_INFO_FIRMWARE_VERSION_UUID])
    {
        NSString *firmwareRevisionString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (firmwareRevisionString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:firmwareRevisionString forKey:FIRMWARE_REVISION];
        }
    }
    
    /* Read the software revision for the software within the device from characteristic
     */
    //else if ([characteristic.UUID isEqual:DEVICE_SOFTWARE_REVISION_CHARACTERISTIC_UUID])
    //{
    //
    //    NSString *softwareRevisionString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
    //
    //    if (softwareRevisionString != nil)
    //    {
    //        [_deviceInfoCharValueDictionary setObject:softwareRevisionString forKey:SOFTWARE_REVISION];
    //    }
    //}
    /* Read a structure containing an Organizationally Unique Identifier (OUI) followed by a manufacturer-defined identifier and is unique for each individual instance of the product from characteristic
     */
    //else if ([characteristic.UUID isEqual:DEVICE_SYSTEMID_CHARACTERISTIC_UUID])
    //{
    //
    //    NSString *systemID = [NSString stringWithFormat:@"%@",characteristic.value];
    //
    //    if (systemID != nil)
    //    {
    //        [_deviceInfoCharValueDictionary setObject:systemID forKey:SYSTEM_ID];
    //    }
    //
    //}
    /* Read the regulatory and certification information for the product in a list defined in IEEE 11073-20601 from characteristic
     */
    //else if ([characteristic.UUID isEqual:DEVICE_CERTIFICATION_DATALIST_CHARACTERISTIC_UUID])
    //{
    //
    //    NSString *certificationDataList = [NSString stringWithFormat:@"%@",charData];
    //
    //    if (certificationDataList != nil)
    //    {
    //        [_deviceInfoCharValueDictionary setObject:certificationDataList forKey:REGULATORY_CERTIFICATION_DATA_LIST];
    //    }
    //}
    /* Read a set of values used to create a device ID value that is unique for this device from characteristic
     */
    //else if ([characteristic.UUID isEqual:DEVICE_PNPID_CHARACTERISTIC_UUID])
    //{
    //
    //    NSString *pnpID = [NSString stringWithFormat:@"%@",characteristic.value];
    //
    //   if (pnpID != nil)
    //    {
    //        [_deviceInfoCharValueDictionary setObject:pnpID forKey:PNP_ID];
    //
    //    }
    //}
    
    
    //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:DEVICE_INFO_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",READ_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:charData]]];
    
    charCount ++;
    
    if (charCount == deviceInfoCharArray.count)
    {
        cbCharacteristicHandler(YES,nil);
    }
    
}


@end
