
#import "RideServiceModel.h"
#import "CBManager.h"


/*!
 *  @class RideServiceModel
 *
 *  @discussion Class to handle the ride service related operations
 *
 */

@interface RideServiceModel()<cbCharacteristicManagerDelegate>
{
    void (^cbCharacteristicHandler)(BOOL success, NSError *error);
    void (^cbWriteCharacteristicHandler)(BOOL success, NSError *error);
    CBCharacteristic *xyzlfCharacteristics, *ctrlCharacteristics;
    BOOL isWriteSuccess;
}

@end

@implementation RideServiceModel

@synthesize  redColor;
@synthesize  greenColor;
@synthesize  blueColor;
@synthesize  intensity;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self startDiscoverChar];
    }
    
    return self;
}


/*!
 *  @method startDiscoverChar
 *
 *  @discussion Discovers the specified characteristics of a service..
 */
-(void)startDiscoverChar
{
    isWriteSuccess = YES ;
    [[CBManager sharedManager] setCbCharacteristicDelegate:self];
    
    for(CBService *service in [[CBManager sharedManager] myPeripheral].services)
    {
        if([service.UUID isEqual:RIDE_QUALITY_DATA_SERVICE_UUID])
        {
            //[[CBManager sharedManager] setMyService:service] ;
            [[[CBManager sharedManager] myPeripheral] discoverCharacteristics:nil forService:service];
        }
    }
}


/*!
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */
-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler
{
    cbCharacteristicHandler = handler;
}


/*!
 *  @method startUpdate
 *
 *  @discussion Starts notifications or indications for the value of a specified characteristic.
 */
-(void)startUpdate
{
    //cbCharacteristicHandler = nil;
    
    if([[[CBManager sharedManager] myService].UUID isEqual:RIDE_QUALITY_DATA_SERVICE_UUID])
    {
        for(CBCharacteristic *aChar in [[CBManager sharedManager] myService].characteristics)
        {
            if([aChar.UUID isEqual:XYZLF_DATA_CHAR_UUID] || [aChar.UUID isEqual:CTRL_DATA_CHAR_UUID])
            {
                [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES  forCharacteristic:aChar];
            }
        }
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
    
    if([[[CBManager sharedManager] myService].UUID isEqual:RIDE_QUALITY_DATA_SERVICE_UUID])
    {
        for(CBCharacteristic *aChar in [[CBManager sharedManager] myService].characteristics)
        {
            if([aChar.UUID isEqual:XYZLF_DATA_CHAR_UUID] || [aChar.UUID isEqual:CTRL_DATA_CHAR_UUID])
            {
                [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO  forCharacteristic:aChar];
            }
        }
    }
}


/*!
 *  @method writeValueForCTRL:
 *
 *  @discussion Method to write value for node command
 *
 */
-(void) writeValueForCTRL:(NSInteger)ctrlvalue
{
    if(ctrlCharacteristics)
    {
        /* The value which you want to write */
        uint8_t val = (uint8_t)ctrlvalue;
        NSData  *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        
        [[[CBManager sharedManager] myPeripheral] writeValue:valData forCharacteristic:ctrlCharacteristics type:CBCharacteristicWriteWithoutResponse];
                
        NSLog(@"Log - CTRL Write Value = %ld", ctrlvalue);
    }
}


/*!
 *  @method writeValueForCTRL:vtrlvalue:With
 *
 *  @discussion Write value to specified characteristic.
 */
-(void)writeValueForCTRL:(NSInteger)ctrlvalue With:(void (^) (BOOL success, NSError *error))handler
{
    cbWriteCharacteristicHandler = handler;
    
    if(isWriteSuccess && ctrlCharacteristics)
    {
        uint8_t val = (uint8_t)ctrlvalue;
        NSData  *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        
        [[[CBManager sharedManager] myPeripheral] writeValue:valData forCharacteristic:ctrlCharacteristics type:CBCharacteristicWriteWithResponse];
        isWriteSuccess = NO;
        
        NSLog(@"Log - CTRL Write Value = %ld", ctrlvalue);
    }
}


#pragma mark - CBManagerDelagate methods

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if([service.UUID isEqual:RIDE_QUALITY_DATA_SERVICE_UUID])
    {
        for(CBCharacteristic *aChar in service.characteristics)
        {
            if([aChar.UUID isEqual:XYZLF_DATA_CHAR_UUID])
            {
                xyzlfCharacteristics = aChar;
                [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES  forCharacteristic:aChar];
            }
            
            if([aChar.UUID isEqual:CTRL_DATA_CHAR_UUID])
            {
                ctrlCharacteristics = aChar;
                [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES  forCharacteristic:aChar];
                
                [self writeValueForCTRL:CTRL_RX_REPORT With:^(BOOL success, NSError *error)
                {
                    if(success)
                    {
                        //NSLog(@"Log = Write success");
                    }
                }];
            }
        }
    }
}


/*!
 *  @method peripheral: didUpdateValueForCharacteristic: error:
 *
 *  @discussion Method invoked when the characteristic value changes
 *
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [self updateValues:characteristic error:error];
}


/*!
 *  @method peripheral: didWriteVlueForCharacteristic: error:
 *
 *  @discussion Write acknowledgement for RGB colors and intensity to specified characteristic.
 */
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if(error)
    {
        isWriteSuccess = NO ;
        cbWriteCharacteristicHandler(NO,error);
        NSLog(@"Log - CTRL Write Failed");
    }
    else
    {
        isWriteSuccess = YES ;
        cbWriteCharacteristicHandler(YES,error);
        NSLog(@"Log - CTRL Write Completed");
    }
}


/*!
 *  @method updateValues:error
 *
 *  @discussion Initially get value from specified characteristic.
 */
-(void)updateValues:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error == nil)
    {
        if(([characteristic.UUID isEqual:XYZLF_DATA_CHAR_UUID]) && characteristic.value)
        {
            NSData *data = [characteristic value];
            const uint8_t *reportData = [data bytes];
            
            self.redColor =  reportData[0];
            self.greenColor =  reportData[1];
            self.blueColor =  reportData[2];
            self.intensity =  reportData[3];
            
            NSLog(@"Log - XYZLF Notify value = %@, %@, %@, %@", [NSString stringWithFormat:@"%d",reportData[0]],
                                                                [NSString stringWithFormat:@"%d",reportData[1]],
                                                                [NSString stringWithFormat:@"%d",reportData[2]],
                                                                [NSString stringWithFormat:@"%d",reportData[3]]);
            
            cbCharacteristicHandler(YES,nil);
        }
        else if(([characteristic.UUID isEqual:CTRL_DATA_CHAR_UUID]) && characteristic.value)
        {
            NSData *data = [characteristic value];
            const uint8_t *reportData = [data bytes];
            NSString *ctrlString = [NSString stringWithFormat:@"%d",reportData[0]];
            
            NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
            //NSLog(@"Log - CTRL Notify Value = %@", ctrlString);
            //NSLog(@"Log - CTRL Notify Value = %@", [NSString stringWithFormat:@"%d",reportData[0]]);
            
            cbCharacteristicHandler(YES,nil);
        }
        else
        {
            cbCharacteristicHandler(NO,error);
        }
    }
    else
    {
        cbCharacteristicHandler(NO,error);
    }
}


@end
