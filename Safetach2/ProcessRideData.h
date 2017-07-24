/*
 * File Name:	RideServiceModel.h
 *
 * Version      1.0.0
 *
 * Date:		07/21/2017
 *
 * Description:
 *   This is Bluetooth service model for ride data for the iOS Safetach2 project.
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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProcessRideData : NSObject


/*!
 *  @property xData
 *
 *  @discussion X axis accel data
 *
 */
@property (nonatomic , assign ) NSInteger xData;

@end

