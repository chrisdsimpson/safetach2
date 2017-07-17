

#import "BatteryServiceModel.h"

/*!
 *  @class BatteryServiceModel
 *
 *  @discussion Class to handle the battery service related operations
 *
 */
@interface BatteryServiceModel()<cbCharacteristicManagerDelegate>
{
    void(^cbCharacteristicDiscoverHandler)(BOOL success,NSError *error);
    BOOL isCharacteristicRead;
}

@end


@implementation BatteryServiceModel


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.batteryServiceDict = [[NSMutableDictionary alloc] init];
        [self.batteryServiceDict setValue:@" " forKey:[NSString stringWithFormat:@"%@",[[CBManager sharedManager] myService]]];
    }
    
    return self;
}


/*!
 *  @method startDiscoverCharacteristicsWithCompletionHandler:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */
-(void)startDiscoverCharacteristicsWithCompletionHandler:(void (^)(BOOL success,NSError *error))handler
{
    cbCharacteristicDiscoverHandler = handler;
    [[CBManager sharedManager] setCbCharacteristicDelegate:self];
    [[[CBManager sharedManager] myPeripheral] discoverCharacteristics:nil forService:[[CBManager sharedManager] myService]];
}


/*!
 *  @method readBatteryLevel
 *
 *  @discussion Method to read battery level value from characteristic
 *
 */
-(void) readBatteryLevel
{
    if (_batteryCharacterisic != nil)
    {
        isCharacteristicRead = YES;
        //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:BATTERY_LEVEL_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:BATTERY_LEVEL_CHARACTERISTIC_UUID] descriptor:nil operation:READ_REQUEST];
        
        [[[CBManager sharedManager] myPeripheral] readValueForCharacteristic:_batteryCharacterisic];
    }
}


/*!
 *  @method startUpdateCharacteristic
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */
-(void)startUpdateCharacteristic
{
    if (_batteryCharacterisic != nil)
    {
        //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:BATTERY_LEVEL_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:BATTERY_LEVEL_CHARACTERISTIC_UUID] descriptor:nil operation:START_NOTIFY];
        
        [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:_batteryCharacterisic];
    }
}

/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */
-(void)stopUpdate
{
    if (_batteryCharacterisic != nil)
    {
        if (_batteryCharacterisic.isNotifying)
        {
            [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:_batteryCharacterisic];
            //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:BATTERY_LEVEL_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:BATTERY_LEVEL_CHARACTERISTIC_UUID] descriptor:nil operation:STOP_NOTIFY];
        }
    }
}



#pragma mark - characteristicManager delegate

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:BATTERY_SERVICE_UUID])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Checking for the required characteristic
            if ([aChar.UUID isEqual:BATTERY_LEVEL_UUID])
            {
                _batteryCharacterisic = aChar;
                cbCharacteristicDiscoverHandler(YES,nil);
            }
           
        }
    }
    else
        cbCharacteristicDiscoverHandler(NO,error);
}


/*!
 *  @method peripheral: didUpdateValueForCharacteristic: error:
 *
 *  @discussion Method invoked when the characteristic value changes
 *
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error == nil )
    {
        [self handleBatteryCharacteristicValueWithChar:characteristic];
    }
}


/*!
 *  @method handleBatteryCharacteristicValueWithChar:
 *
 *  @discussion Method to handle the characteristic value
 *
 */
-(void) handleBatteryCharacteristicValueWithChar:(CBCharacteristic *) characteristic
{
    if ([characteristic.UUID isEqual:BATTERY_LEVEL_UUID] && characteristic.value)
    {
        [self getBatteryData:characteristic];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateBatteryUI)])
    {
        [_delegate updateBatteryUI];
    }
}


/*!
 *  @method getBatteryData:
 *
 *  @discussion Method to get the Battery Level information
 *
 */
- (void)getBatteryData:(CBCharacteristic *)characteristic
{
    NSData *data = [characteristic value];
    const uint8_t *reportData = [data bytes];
    NSString *levelString=[NSString stringWithFormat:@"%d",reportData[0]];
    
    if (!isCharacteristicRead)
    {
        //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",NOTIFY_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
    }
    else
    {
        //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",READ_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
        isCharacteristicRead = NO;
    }
    
    [self.batteryServiceDict setValue:levelString forKey:[NSString stringWithFormat:@"%@",characteristic.service]];
}


@end
