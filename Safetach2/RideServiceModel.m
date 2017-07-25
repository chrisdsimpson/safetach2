/*
 * File Name:	RideServiceModel.m
 *
 * Version      1.0.0
 *
 * Date:		07/21/2017
 *
 * Description:
 *   This is Bluetooth service model for ride data for the iOS Safetach2 project.
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


#import "RideServiceModel.h"
#import "CBManager.h"
#import "DeviceRWData.h"



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
    CBCharacteristic *xyzlfCharacteristics;
    CBCharacteristic *ctrlCharacteristics;
    BOOL isWriteSuccess;
    int PacketState;
    int NumSamplesSent;
    int NumSamples;
    int SampleCount;
    BOOL PacketXferInProgress;
    BOOL PacketXferPauseFlag;
    int RetryCounter;
    int PacketNumber;
    BOOL NodeCommStarted;
    int XferPercentOffset;
    BOOL ExistingConnectionFlag;

    NSMutableArray *RunDataPacket;
    NSMutableArray *RunDataNonPacket;
}

@end

@implementation RideServiceModel

@synthesize xData;
@synthesize yData;
@synthesize zData;
@synthesize lData;
@synthesize fData;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        /* Create the DeviceRWData class */
        //rwData = [[DeviceRWData alloc] init];
        
        /* Init all vars */
        PacketState = PACKET_STATE_DATA_REALTIME;
        NumSamplesSent = 0;
        NumSamples = 0;
        SampleCount = 0;
        PacketXferInProgress = false;
        RetryCounter = 0;
        PacketNumber = 0;
        NodeCommStarted = false;
        XferPercentOffset = 0;
        ExistingConnectionFlag = false;;
        RunDataPacket = [[NSMutableArray alloc] init];
        RunDataNonPacket = [[NSMutableArray alloc] init];
        
        /* Start up the characteristics discovery for the ride service */
        [self startDiscoverChar];
    }
    
    return self;
}


/*!
 *  @method resetPacketrTransfer
 *
 *  @discussion Resets the state of the packet transfer.
 */
-(void)resetPacketTransfer
{
    PacketXferInProgress = false;
    PacketXferPauseFlag = false;
    NumSamplesSent = 0;
    SampleCount = 0;
    PacketState = PACKET_STATE_DATA_REALTIME;
    [RunDataNonPacket removeAllObjects];
    [RunDataPacket removeAllObjects];
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
        
        /* If the node connection was lost during packet transfer request the packet be resent */
        if(PacketXferInProgress == true)
        {
            /* Set the packet state to watch for the header after the node connection */
            PacketState = PACKET_STATE_GET_HEADER;
        }
        else
        {
            /* If no transfer is in progress reset the capture state to default */
            PacketState = PACKET_STATE_DATA_REALTIME;
        }
       
        
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
        //NSLog(@"Log - CTRL Write Failed");
    }
    else
    {
        isWriteSuccess = YES ;
        cbWriteCharacteristicHandler(YES,error);
        //NSLog(@"Log - CTRL Write Completed");
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
            const uint16_t *reportData = [data bytes];
            
            self.xData = reportData[0];
            self.yData = reportData[1];
            self.zData = reportData[2];
            self.lData = reportData[3];
            self.fData = reportData[4];
            
            NSString *xyzlfString = [NSString stringWithFormat:@"%05d, %05d, %05d, %05d, %05d", reportData[0],
                                     reportData[1],
                                     reportData[2],
                                     reportData[3],
                                     reportData[4]];
            
            NSString *RunDataStr = xyzlfString;
            
            /* We are receiving data so reset the packet transfer watchdog */
            NSString *ctrlString = [NSString stringWithFormat:@"%d", CTRL_INT_PACKET_WD_RESET];
            NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
            //resetWatchDog();
            
            /* We are receiving data so set the packet transfer flag to true */
            if(PacketXferInProgress == false)
            {
                PacketXferInProgress = true;
                RetryCounter = 0;
                SampleCount = 0;
                
                /* Clear the RunDataNonPacket array list */
                [RunDataNonPacket removeAllObjects];
                
                NSLog(@"Debug - Packet sample data stream has started");
            }
            
            /* Update the total samples received count */
            SampleCount++;
            
            switch(PacketState)
            {
                case PACKET_STATE_IDLE:
                    
                break;
                    
                case PACKET_STATE_DATA_REALTIME:
                    
                    /* Look for the packet header and when found get all the necessary header data */
                    if(xData == PACKET_ID && fData != PACKET_EOP)
                    {
                        /*  Update the number of samples sent */
                        NumSamplesSent++;
                        
                        /* Add the header sample to the beginning of realtime non packet xfer arraylist */
                        [RunDataNonPacket insertObject:RunDataStr atIndex:0];
                        
                        /* Get the number of samples in the packet from the packet header */
                        NumSamples = zData;
                        
                        /* Get the packet number */
                        PacketNumber = lData;
                        
                        /* Clear the packet sample transfer flag */
                        PacketXferInProgress = false;
                        
                        /* Debuging info */
                        NSString *tstr = [NSString stringWithFormat:@"(Packet number=%d Packet size=%d SampleCount=%d NumSamplesSent=%d Array size=%ld)",
                                          PacketNumber,
                                          NumSamples,
                                          SampleCount,
                                          NumSamplesSent,
                                          [RunDataNonPacket count]];
                        
                        NSLog(@"Debug - Packet Header received %@", tstr);
                        
                        /* Test to see if we received the correct number of samples from the packet, if not request packet resend */
                        if(NumSamples == NumSamplesSent && NumSamples == [RunDataNonPacket count])
                        {
                            
                            /* Create a new ride data file */
                            [[DeviceRWData sharedDeviceRWData] createRideDataFile];
                            
                            
                            /*
                             * If the packet is intact write it to the run data file
                             * minus the packet footer.
                             */
                            for(int i = 0; i < ([RunDataNonPacket count] - 1); i++)
                            {
                                /* Write a line to the ride data file */
                                [[DeviceRWData sharedDeviceRWData] writeLineRideDataFile:[RunDataNonPacket objectAtIndex:i]];
                            }
                            
                            /* Close the ride data file */
                            //[[DeviceRWData sharedDeviceRWData] closeRideDataFile];
                            
                            /* Clear the RunDataPacket array list */
                            [RunDataNonPacket removeAllObjects];
                            
                            /* Reset the num samples sent */
                            NumSamplesSent = 0;
                            
                            /* Reset the total sample count */
                            SampleCount = 0;
                            
                            /* Send the command to notify the server that the packet was received */
                            [self writeValueForCTRL:CTRL_RX_PACKETRECEIVED With:^(BOOL success, NSError *error)
                            {
                                if(success)
                                {
                                    //NSLog(@"Log = Write success");
                                }
                            }];
                            
                            /* Notify the main activity that the run data file is ready to process */
                            NSString *ctrlString = [NSString stringWithFormat:@"%d", CTRL_INT_PACKET_COMPLETE];
                            NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
                            
                            NSLog(@"Debug - Packet received realtime OK");
                        }
                        else
                        {
                            NSLog(@"Debug - Error packet has missing samples (Packet size=%d NumSamplesSent=%d)", NumSamples, NumSamplesSent);
                            
                            /* Clear the RunDataPacket array list */
                            [RunDataNonPacket removeAllObjects];
                            
                            /* Reset the num samples sent */
                            NumSamplesSent = 0;
                            
                            /* Reset the total sample count */
                            SampleCount = 0;
                            
                            /* Send the command to resend the run packet */
                            [self writeValueForCTRL:CTRL_RX_PACKETRESEND With:^(BOOL success, NSError *error)
                            {
                                if(success)
                                {
                                    //NSLog(@"Log = Write success");
                                }
                            }];
                            
                            /* Set the state to watch for the packet header */
                            PacketState = PACKET_STATE_GET_HEADER;
                        }
                    }
                    else
                    {
                        /* Update the number of samples sent */
                        NumSamplesSent++;
                        
                        /* Add the sample to the realtime non packet xfer arraylist */
                        [RunDataNonPacket addObject:RunDataStr];
                    }
                    
                break;
                    
                case PACKET_STATE_GET_HEADER:
                    
                    /* Look for the packet header and when found get all the necessary header data */
                    if(xData == PACKET_ID)
                    {
                        /* Get the number of samples in the packet from the packet header */
                        NumSamples = zData;
                        
                        /* Get the packet number */
                        PacketNumber = lData;
                        
                        /* Update the number of samples sent to 1 for the header sample */
                        NumSamplesSent = 1;
                        
                        /* Clear the RunDataPacket array list */
                        [RunDataPacket removeAllObjects];
                        
                        /* Add the header sample to the arraylist */
                        [RunDataPacket addObject:RunDataStr];
                        
                        /* Set the packet transfer state to header sent and move to the data collection state */
                        PacketState = PACKET_STATE_GET_DATA;
                        
                        NSLog(@"Debug - Packet Header received OK (Packet size=%d Packet number=%d)", NumSamples, PacketNumber);
                        
                        /* If we have a partial packet just request the missing section */
                        if([RunDataNonPacket count] != 0)
                        {
                            double percentreceived = ((double)[RunDataNonPacket count]) / ((double)NumSamples);
                            
                            NSLog(@"Debug - Partial packet received (Packet size=%d RunDataNonPacket count=%ld percentreceived=%lf)",
                                  NumSamples, [RunDataNonPacket count], percentreceived);
                            
                            if(percentreceived >= 0.75 && percentreceived < 1.0)
                            {
                                [self writeValueForCTRL:CTRL_RX_PACKETRESEND_25 With:^(BOOL success, NSError *error)
                                {
                                    if(success)
                                    {
                                        //NSLog(@"Log = Write success");
                                    }
                                }];
                                
                                XferPercentOffset = 75;
                                NSLog(@"Debug - Request to resend the last 25%% of packet");
                            }
                            else if(percentreceived >= 0.50 && percentreceived < 0.75)
                            {
                                [self writeValueForCTRL:CTRL_RX_PACKETRESEND_50 With:^(BOOL success, NSError *error)
                                {
                                    if(success)
                                    {
                                        //NSLog(@"Log = Write success");
                                    }
                                }];
                                
                                XferPercentOffset = 50;
                                NSLog(@"Debug - Request to resend the last 50%% of packet");
                            }
                            else if(percentreceived >= 0.25 && percentreceived < 0.50)
                            {
                                [self writeValueForCTRL:CTRL_RX_PACKETRESEND_75 With:^(BOOL success, NSError *error)
                                {
                                    if(success)
                                    {
                                        //NSLog(@"Log = Write success");
                                    }
                                }];
                                
                                XferPercentOffset = 25;
                                NSLog(@"Debug - Request to resend the last 75%% of packet");
                            }
                            else
                            {
                                [self writeValueForCTRL:CTRL_RX_PACKETRESEND_99 With:^(BOOL success, NSError *error)
                                {
                                    if(success)
                                    {
                                        //NSLog(@"Log = Write success");
                                    }
                                }];
                                
                                XferPercentOffset = 1;
                                NSLog(@"Debug - Request to resend all but the packet header");
                            }
                        }
                        else
                        {
                            [self writeValueForCTRL:CTRL_RX_PACKETRESEND_99 With:^(BOOL success, NSError *error)
                            {
                                if(success)
                                {
                                    //NSLog(@"Log = Write success");
                                }
                            }];
                            
                            XferPercentOffset = 1;
                            NSLog(@"Debug - Request to resend all but the packet header");
                        }
                    }
                    else
                    {
                        RetryCounter++;
                        
                        if(RetryCounter == PACKET_TRANSFER_TIMEOUT_COUNT)
                        {
                            /* Reset the time out counter */
                            RetryCounter = 0;
                            
                            /* Reset the state */
                            PacketState = PACKET_STATE_DATA_REALTIME;
                            
                            /* Clear the packet transfer flag */
                            PacketXferInProgress = false;
                            
                            /* Notify the main activity that the run data file header transfer failed */
                            NSString *ctrlString = [NSString stringWithFormat:@"%d", CTRL_INT_PACKET_ERROR];
                            NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
                            
                            NSLog(@"Debug - Error Packet header not received (1) (Retries timed out)");
                        }
                        else
                        {
                            /*
                             * If we didn't get the packet header as the first sample
                             * Send the command to resend the run packet
                             */
                            [self writeValueForCTRL:CTRL_RX_PACKETRESEND With:^(BOOL success, NSError *error)
                            {
                                if(success)
                                {
                                    //NSLog(@"Log = Write success");
                                }
                            }];
                            
                            XferPercentOffset = 0;
                            NSLog(@"Debug - Error Packet header not received (1) (Retry count = %d)", RetryCounter);
                        }
                    }
                    
                break;
                    
                case PACKET_STATE_GET_DATA:
                    
                    /* Add the run data sample to the arraylist */
                    [RunDataPacket addObject:RunDataStr];
                    
                    /* Update the number of samples sent */
                    NumSamplesSent++;
                    
                    
                    /* Watch for the packet footer sample and end of packet flag */
                    if(xData == PACKET_ID && fData == PACKET_EOP)
                    {
                        //Log.d(TAG, "Debug - Packet footer received OK");
                        
                        NSLog(@"Debug - Packet footer received OK (Packet size=%d NumSamplesSent=%d RunDataPacket count=%ld)",
                              NumSamples, NumSamplesSent, [RunDataPacket count]);
                        
                        /* Test to see if we have received all the samples from the packet */
                        if(NumSamplesSent == NumSamples && [RunDataPacket count] == NumSamples)
                        {
                            /* Create a new ride data file */
                            [[DeviceRWData sharedDeviceRWData] createRideDataFile];
                           
                            /*
                             * If the packet is intact write it to the run data file
                             * minus the packet footer.
                             */
                            for(int i = 0; i < ([RunDataPacket count] - 1); i++)
                            {
                                [[DeviceRWData sharedDeviceRWData] writeLineRideDataFile:[RunDataNonPacket objectAtIndex:i]];
                            }
                            
                            /* Close the ride data file */
                            //[[DeviceRWData sharedDeviceRWData] closeRideDataFile];
                            
                            /* Clear the RunDataPacket array list */
                            [RunDataPacket removeAllObjects];
                            
                            /* Reset the num samples sent */
                            NumSamplesSent = 0;
                            
                            /* Reset the total sample count */
                            SampleCount = 0;
                            
                            /* Send the command to notify the server that the packet was received */
                            [self writeValueForCTRL:CTRL_RX_PACKETRECEIVED With:^(BOOL success, NSError *error)
                            {
                                if(success)
                                {
                                    //NSLog(@"Log = Write success");
                                }
                            }];
                           
                            /* Notify the main activity that the run data file is ready to process */
                            NSString *ctrlString = [NSString stringWithFormat:@"%d", CTRL_INT_PACKET_COMPLETE];
                            NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
                            
                            /*
                             * After the packet is received and written to the run data file reset
                             * the packet state to watch for the next run packet.
                             */
                            PacketState = PACKET_STATE_DATA_REALTIME;
                            
                            /* Clear the packet transfer flag */
                            PacketXferInProgress = false;
                            
                            /* Clear the packet transfer pause flag */
                            PacketXferPauseFlag = false;
                            
                            NSLog(@"Debug - Packet received OK");
                        }
                        else
                        {
                            /* else we have a error condition */
                            RetryCounter++;
                            
                            if(RetryCounter == PACKET_TRANSFER_TIMEOUT_COUNT)
                            {
                                /* Reset the time out counter */
                                RetryCounter = 0;
                                
                                /* Reset the state */
                                PacketState = PACKET_STATE_DATA_REALTIME;
                                
                                /* Clear the packet transfer flag */
                                PacketXferInProgress = false;
                                
                                /* Clear the packet transfer pause flag */
                                PacketXferPauseFlag = false;
                                
                                /* Notify the main activity that the run data file transfer failed */
                                NSString *ctrlString = [NSString stringWithFormat:@"%d", CTRL_INT_PACKET_ERROR];
                                NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
                                
                                NSLog(@"Debug - Error Packet not received (2) (Retries timed out)");
                            }
                            else if([RunDataPacket count] + [RunDataNonPacket count] >= NumSamples)
                            {
                                /*
                                 * In this section of code we are attempting to rebuild the packet
                                 * from packet data that was received during the realtime transfer
                                 * and packet data that was received from a request to resent any
                                 * missing data that was lost due to a disconnect during the realtime
                                 * transfer.
                                 */
                                
                                NSLog(@"Debug - Packet Rebuild (Packet size=%d NumSamplesSent=%d RunDataPacket count=%ld RunDataNonPacket count=%ld)",
                                      NumSamples, NumSamplesSent, [RunDataPacket count], [RunDataNonPacket count]);
                                
                                /* Copy the header sample to the beginning of realtime packet xfer arraylist */
                                [RunDataNonPacket insertObject:[RunDataPacket objectAtIndex:0] atIndex:0];
                                
                                /* Calculate where in the new partial array to start copying data from */
                                int startpoint = [RunDataPacket count] - (NumSamples - [RunDataNonPacket count]);
                                
                                /* Copy all the elements packet into the realtime packet xfer array */
                                for(int i = startpoint; i < [RunDataPacket count]; i++)
                                {
                                    [RunDataNonPacket addObject:[RunDataPacket objectAtIndex:i]];
                                }
                                
                                NSLog(@"Debug - Packet Rebuilt (Packet size=%d New array size RunDataNonPacket count=%ld)",
                                      NumSamples, [RunDataNonPacket count]);
                                
                                /* Create a new ride data file */
                                [[DeviceRWData sharedDeviceRWData] createRideDataFile];
                                
                                /*
                                 * After the packet is rebuilt write it to the run data file
                                 * minus the packet footer.
                                 */
                                for(int i = 0; i < ([RunDataNonPacket count] - 1); i++)
                                {
                                    [[DeviceRWData sharedDeviceRWData] writeLineRideDataFile:[RunDataNonPacket objectAtIndex:i]];
                                }
                                
                                /* Close the ride data file */
                                //[[DeviceRWData sharedDeviceRWData] closeRideDataFile];
                                
                                /* Clear the RunDataPacket array list */
                                [RunDataNonPacket removeAllObjects];
                                [RunDataPacket removeAllObjects];
                                
                                /* Reset the num samples sent */
                                NumSamplesSent = 0;
                                
                                /* Reset the total sample count */
                                SampleCount = 0;
                                
                                /* Send the command to notify the server that the packet was received */
                                [self writeValueForCTRL:CTRL_RX_PACKETRECEIVED With:^(BOOL success, NSError *error)
                                {
                                    if(success)
                                    {
                                        //NSLog(@"Log = Write success");
                                    }
                                }];
                                
                                /* Notify the main activity that the run data file is ready to process */
                                NSString *ctrlString = [NSString stringWithFormat:@"%d", CTRL_INT_PACKET_COMPLETE];
                                NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
                                
                                /*
                                 * After the packet is rebuilt and written to the run data file reset
                                 * the packet state to watch for the next run packet.
                                 */
                                PacketState = PACKET_STATE_DATA_REALTIME;
                                
                                /* Clear the packet transfer pause flag */
                                PacketXferPauseFlag = false;
                                
                                NSLog(@"Debug - Packet received and rebuilt OK");
                            }
                            else
                            {
                                /* Clear the RunDataPacket array list */
                                [RunDataPacket removeAllObjects];
                                
                                /* Reset the number of samples sent */
                                NumSamplesSent = 0;
                                
                                /* Send the command to resend the run packet */
                                [self writeValueForCTRL:CTRL_RX_PACKETRESEND With:^(BOOL success, NSError *error)
                                {
                                    if(success)
                                    {
                                        //NSLog(@"Log = Write success");
                                    }
                                }];
                                
                                XferPercentOffset = 0;
                                
                                /* Reset the state to watch for the packet header again */
                                PacketState = PACKET_STATE_GET_HEADER;
                                
                                NSLog(@"Debug - Error Packet not received (2) (Retry count = %d)", RetryCounter);
                            }
                        }
                    }
                    else if(NumSamplesSent == NumSamples)
                    {
                        /*
                         * Test to see if we have received all the samples from the packet. If we
                         * got here this means the end of packet was not seen. Handle the error.
                         */
                        
                        RetryCounter++;
                        
                        if(RetryCounter == PACKET_TRANSFER_TIMEOUT_COUNT)
                        {
                            /* Reset the time out counter */
                            RetryCounter = 0;
                            
                            /* Reset the state */
                            PacketState = PACKET_STATE_DATA_REALTIME;
                            
                            /* Clear the packet transfer flag */
                            PacketXferInProgress = false;
                            
                            /* Notify the main activity that the run data file transfer failed */
                            NSString *ctrlString = [NSString stringWithFormat:@"%d", CTRL_INT_PACKET_ERROR];
                            NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
                            
                            NSLog(@"Debug - Error Packet not received (3) (Retries timed out)");
                        }
                        else
                        {
                            /* Clear the RunDataPacket array list */
                            [RunDataPacket removeAllObjects];
                            
                            /* Reset the number of samples sent */
                            NumSamplesSent = 0;
                            
                            /* Send the command to resend the run packet */
                            [self writeValueForCTRL:CTRL_RX_PACKETRESEND With:^(BOOL success, NSError *error)
                            {
                                if(success)
                                {
                                    //NSLog(@"Log = Write success");
                                }
                            }];
                            
                            XferPercentOffset = 0;
                            
                            /* Reset the state to watch for the packet header again */
                            PacketState = PACKET_STATE_GET_HEADER;
                            
                            NSLog(@"Debug - Error Packet not received (3) (Retry count = %d)", RetryCounter);
                        }
                    }
                    else
                    {
                        int percentreceived = (NumSamplesSent * 100 / NumSamples) + XferPercentOffset;
                        
                        if(percentreceived > 99)
                        {
                            percentreceived = 99;
                        }
                        
                        /* Notify the main activity the percent of the current run packet transfer received */
                        NSString *ctrlString = [NSString stringWithFormat:@"%d %d", CTRL_INT_PACKET_TRANSFER, percentreceived];
                        NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
                        
                        //intent.putExtra(EXTRA_DATA_TYPE, CTRL_TYPE.toString());
                        //intent.putExtra(EXTRA_DATA, String.valueOf(DeviceControlActivity.CTRL_INT_PACKET_TRANSFER));
                        //intent.putExtra("transferpercent", String.valueOf(percentreceived));
                        
                        NSLog(@"Debug - Transfer percent = %d)", percentreceived);
                    }
                    
                break;
                    
                case PACKET_STATE_DATA_RECEIVED:
                    
                break;
                    
                case PACKET_STATE_DATA_RESEND:
                    
                break;
                    
                default:
                
                break;
            }
            
            
            /* Send the xyzlf data to the main view controller */
            NSDictionary *xyzlfdata = [NSDictionary dictionaryWithObject:xyzlfString forKey:@"xyzlfvalue"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"XYZLF_TYPE" object:self userInfo:xyzlfdata];
            
            //NSLog(@"Log - XYZLF Notify Value = %@", xyzlfString);
            
            cbCharacteristicHandler(YES,nil);
        }
        else if(([characteristic.UUID isEqual:CTRL_DATA_CHAR_UUID]) && characteristic.value)
        {
            NSData *data = [characteristic value];
            const uint8_t *reportData = [data bytes];
            NSString *ctrlString = [NSString stringWithFormat:@"%d",reportData[0]];
            
            /* Send the ctrl data to the main view controller */
            NSDictionary *ctrldata = [NSDictionary dictionaryWithObject:ctrlString forKey:@"ctrlvalue"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CTRL_TYPE" object:self userInfo:ctrldata];
            
            //NSLog(@"Log - CTRL Notify Value = %@", ctrlString);
            
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
