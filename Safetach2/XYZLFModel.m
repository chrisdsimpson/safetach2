
#import "XYZLFModel.h"
#import "CBManager.h"

/*!
 *  @class XYZLFModel
 *
 *  @discussion Class to handle the accel X Y Z and audio L and F service and related operations.
 *
 */
@interface XYZLFModel () <cbCharacteristicManagerDelegate>
{
    void (^cbCharacteristicHandler)(BOOL success, NSError *error);
    void (^cbCharacteristicDiscoverHandler)(BOOL success, NSError *error);
    CBCharacteristic *XYZLFCharacter;
}

@end

@implementation XYZLFModel

@synthesize InstantaneousSpeed;
@synthesize InstantaneousCadence;
@synthesize InstantaneousStrideLength;
@synthesize TotalDistance;


- (instancetype)init
{
    self = [super init];
    if (self) {

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
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */
-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler
{
    cbCharacteristicHandler = handler;
    if(XYZLFCharacter)
    {
        //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:RSC_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:RSC_CHARACTERISTIC_UUID] descriptor:nil operation:START_NOTIFY];
        
        [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:XYZLFCharacter];
    }
}


/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */
-(void)stopUpdate
{
    cbCharacteristicHandler = nil;
    if(XYZLFCharacter)
    {
        if (XYZLFCharacter.isNotifying)
        {
            //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:RSC_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:RSC_CHARACTERISTIC_UUID] descriptor:nil operation:STOP_NOTIFY];
            
            [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:XYZLFCharacter];
        }
    }
}


#pragma mark - CBCharecteristicManger delegate methods

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:RIDE_QUALITY_DATA_SERVICE_UUID])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Checking for required characteristic
            if ([aChar.UUID isEqual:XYZLF_DATA_CHAR_UUID])
            {
                XYZLFCharacter = aChar ;
                cbCharacteristicDiscoverHandler(YES,nil);
            }
        }
    }
}


/*!
 *  @method peripheral: didUpdateValueForCharacteristic: error:
 *
 *  @discussion Method invoked when the characteristic value changes or read value
 *
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:XYZLF_DATA_CHAR_UUID])
    {
        if(error == nil)
        {
            [self getXYZLFData:characteristic];
            cbCharacteristicHandler(YES,nil);
        }
        else
        {
            cbCharacteristicHandler(NO,error);
        }
    }
}


/*!
 *  @method getXYZLFData
 *
 *  @discussion Parces the XYZLF data and writes it to the Ride data file and send it in a notification.
 *
 */
- (void)getXYZLFData:(CBCharacteristic *)characteristic
{
    NSData *data = [characteristic value];
    const uint8_t *reportData = [data bytes];
    NSInteger shiftVal = 1;

    //    Instantaneous Speed ------ Unit is in m/s with a resolution of 1/256 s
    uint16_t _instantaneousSpeed = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[shiftVal]));
    //Unit is in m/s with a resolution of 1/256 s
    //Convert to km/hr  ( m/s *3.6)
    self.InstantaneousSpeed = 3.6*(_instantaneousSpeed/256.0);
    
    shiftVal+=2;
    
    //    Instantaneous Cadence ---- Unit is in 1/minute (or RPM) with a resolutions of 1 1/min (or 1 RPM)
    
    uint8_t _instantaneousCadence = reportData[shiftVal++];
    self.InstantaneousCadence = (float)_instantaneousCadence;
    
    uint16_t _instantaneousStrideLength = 0;
    uint32_t _totalDistancePresent = 0;
    
    self.InstantaneousStrideLength = 0.0f;

    if ((reportData[0] & 0x01) == 1)
    {
        //Instantaneous Stride Length Present
        // Instantaneous Stride Length ---- Unit is in meter with a resolution of 1/100 m (or centimeter).
         _instantaneousStrideLength = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[shiftVal]));
        self.InstantaneousStrideLength = ((float)_instantaneousStrideLength)/100.0f;
        
        shiftVal += 2 ;
    }

    if (reportData[0] & 0x02)
    {
        //Total Distance Present
        // Unit is in meter with a resolution of 1/10 m (or decimeter)
        _totalDistancePresent =(uint32_t)CFSwapInt32LittleToHost(*(uint32_t*)&reportData[shiftVal]);
        
        if (_totalDistancePresent)
        {
            self.TotalDistance = _totalDistancePresent/10.0;

        }
    }
    
    if ((reportData[0] & 0x04) == 0)
    {
        self.IsWalking = YES ;
    }
    
    //[Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:RSC_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:RSC_CHARACTERISTIC_UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",NOTIFY_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
    
}


@end
