/*
 * File Name:	InfoViewController.m
 *
 * Version      1.0.0
 *
 * Date:		07/13/2017
 *
 * Description:
 *   This is info view controller for the iOS Safetach2 project.
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


#import "InfoViewController.h"
#import "CBManager.h"
#import "DevieInformationModel.h"
#import "Constants.h"

@interface InfoViewController ()
{
    DevieInformationModel *deviceInfoModel;
}

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.AppNameLabel.text = APP_NAME;
    self.SoftwareVersionLabel.text = APP_VERSION;
    
    [self initDeviceInfoModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*!
 *  @method initDeviceInfoModel
 *
 *  @discussion Method to Discover the specified characteristic of a service.
 *
 */
-(void) initDeviceInfoModel
{
    CBService *myService;
    
    /* Find the device info service */
    for (CBService *service in [[CBManager sharedManager] foundServices])
    {
        if([service.UUID isEqual:DEVICE_INFO_SERVICE_UUID])
        {
            myService = service;
            break;
        }
    }
    
    /* If we find the service get the characteristic values for it */
    if(myService != nil)
    {
        [[CBManager sharedManager] setMyService:myService] ;
        
        deviceInfoModel = [[DevieInformationModel alloc] init];
        [deviceInfoModel startDiscoverChar:^(BOOL success, NSError *error)
         {
             if (success)
             {
                 @synchronized(deviceInfoModel)
                 {
                     /* Get the characteristic value if the required characteristic is found */
                     [deviceInfoModel discoverCharacteristicValues:^(BOOL success, NSError *error)
                      {
                          if (success)
                          {
                              
                              for(NSString *key in deviceInfoModel.deviceInfoCharValueDictionary.allKeys)
                              {
                                  if([key isEqualToString:MODEL_NUMBER])
                                  {
                                      self.ModelNumberLabel.text = [deviceInfoModel.deviceInfoCharValueDictionary objectForKey:key];
                                  }
                                  else if([key isEqualToString:SERIAL_NUMBER])
                                  {
                                      self.SerialNumberLabel.text = [deviceInfoModel.deviceInfoCharValueDictionary objectForKey:key];
                                  }
                                  else if([key isEqualToString:HARDWARE_REVISION])
                                  {
                                      self.HardwareLabel.text = [deviceInfoModel.deviceInfoCharValueDictionary objectForKey:key];
                                  }
                                  else if([key isEqualToString:FIRMWARE_REVISION])
                                  {
                                      self.FirmwareLabel.text = [deviceInfoModel.deviceInfoCharValueDictionary objectForKey:key];
                                  }
                              }
                                  
                              for(NSString *value in deviceInfoModel.deviceInfoCharValueDictionary.allValues)
                              {
                                  NSLog(@"Log - Device info values %@", value);
                              }
                              
                          }
                      }];
                 }
             }
         }];
    }
}


@end
