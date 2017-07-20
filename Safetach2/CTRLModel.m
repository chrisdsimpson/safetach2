

#import "CTRLModel.h"
#import "CBManager.h"


/*!
 *  @class CTRLModel
 *
 *  @discussion Class to handle the CTRL char related operations
 *
 */
@interface CTRLModel () <cbCharacteristicManagerDelegate>
{
    void (^cbCharacteristicHandler)(BOOL success, NSError *error);
    void (^cbCharacteristicDiscoverHandler)(BOOL success, NSError *error);
    CBCharacteristic *CTRLCharacter;
}

@end

@implementation CTRLModel

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
    if(CTRLCharacter)
    {
        [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:CTRLCharacter];
    }
}


/*!
 *  @method writeValueForCTRLChar: ctrlvalue:
 *
 *  @discussion Method to write CTRL value to the node.
 *
 */
-(void) writeValueForCTRLchar:(int)ctrlvalue
{
    /* The value which you want to write */
    uint8_t val = (uint8_t)ctrlvalue;
    NSData  *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
    [[[CBManager sharedManager] myPeripheral] writeValue:valData forCharacteristic:CTRLCharacter type:CBCharacteristicWriteWithoutResponse];
    
    NSLog(@"Log - CTRL Write Value = %d", ctrlvalue);
}


/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */
-(void)stopUpdate
{
    cbCharacteristicHandler = nil;
    if(CTRLCharacter)
    {
        if(CTRLCharacter.isNotifying)
        {
            [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:CTRLCharacter];
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
            /* Checking for required characteristic */
            if ([aChar.UUID isEqual:CTRL_DATA_CHAR_UUID])
            {
                CTRLCharacter = aChar ;
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
    if ([characteristic.UUID isEqual:CTRL_DATA_CHAR_UUID])
    {
        if(error == nil)
        {
            [self getCTRLData:characteristic];
            cbCharacteristicHandler(YES,nil);
        }
        else
        {
            cbCharacteristicHandler(NO,error);
        }
    }
}


/*!
 *  @method getCTRLData
 *
 *  @discussion   The
 *
 */
- (void)getCTRLData:(CBCharacteristic *)characteristic
{
    NSData *data = [characteristic value];
    const uint8_t *reportData = [data bytes];
    NSString *ctrlString=[NSString stringWithFormat:@"%d",reportData[0]];
    
    NSDictionary *batterydata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:batterydata];
    NSLog(@"Log - CTRL Read Value = %@", ctrlString);
}


@end
