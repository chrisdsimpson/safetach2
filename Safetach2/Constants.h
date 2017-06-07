/*
 * File Name:	Constants.h
 *
 * Version      1.0.0
 *
 * Date:		05/24/2017
 *
 * Description:
 *   All the constant values used in the iOS Safetach2 project.
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


#ifndef Constants_h
#define Constants_h

/* State defines */
#define MENU_STATE_HOME                 1
#define MENU_STATE_GRAPH                2
#define MENU_STATE_AUDIO                3

#define SUB_MENU_STATE_VELOCITY         1
#define SUB_MENU_STATE_ACCELERATION     2
#define SUB_MENU_STATE_JERK             3
#define SUB_MENU_STATE_AUDIO_LEVEL      4
#define SUB_MENU_STATE_AUDIOFREQ        5


/* Color defines */
#define ColorYellow                     colorWithRed:(250.0/255.0) green:(217.0/255.0) blue:(5.0/255.0) alpha:(1.0)
#define ColorBlue                       colorWithRed:(27.0/255.0) green:(120.0/255.0) blue:(250.0/255.0) alpha:(1.0)
#define ColorRed                        colorWithRed:(255.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:(1.0)
#define ColorGreen                      colorWithRed:(1.0/255.0) green:(161.0/255.0) blue:(1.0/255.0) alpha:(1.0)
#define ColorGrey                       colorWithRed:(167.0/255.0) green:(166.0/255.0) blue:(166.0/255.0) alpha:(1.0)
#define ColorMagenta                    colorWithRed:(225.0/255.0) green:(0.0/255.0) blue:(255.0/255.0) alpha:(1.0)
#define ColorLightGrey                  colorWithRed:(217.0/255.0) green:(217.0/255.0) blue:(217.0/255.0) alpha:(1.0)
#define ColorOrange                     colorWithRed:(255.0/255.0) green:(153.0/255.0) blue:(51.0/255.0) alpha:(1.0)


/* BLE service and char defines */
#define TRANSFER_SERVICE_UUID           @"FB694B90-F49E-4597-8306-171BBA78F846"
#define TRANSFER_CHARACTERISTIC_UUID    @"EB6727C4-F184-497A-A656-76B0CDAC633A"

#define NOTIFY_MTU                      20


/* User default keys and default values */
#define SETUP_RUNTYPE_KEY               @"runtype"
#define SETUP_RUNTYPE_HYDRO_VALUE       @"hydro"
#define SETUP_RUNTYPE_TRACTION_VALUE    @"traction"
#define SETUP_RUNTYPE_DEFAULT_VALUE     SETUP_RUNTYPE_HYDRO_VALUE

#define SETUP_RUNMODE_KEY               @"runmode"
#define SETIP_RUNMODE_TRIGGERED_VALUE   @"triggered"
#define SETUP_RUNMODE_FREERUN_VALUE     @"freerun"
#define SETUP_RUNMODE_DEFAULT_VALUE     SETUP_RUNMODE_TRIGGERED_VALUE

#define SETUP_UNITS_KEY                 @"units"
#define SETUP_UNITS_IMPERIAL_VALUE      @"imperial"
#define SETUP_UNITS_METRIC_VALUE        @"metric"
#define SETUP_UNITS_DEFAULT_VALUE       SETUP_UNITS_IMPERIAL_VALUE

#define SETUP_SCALE_KEY                 @"scale"
#define SETUP_SCALE_MG_VALUE            @"mg"
#define SETUP_SCALE_G_VALUE             @"g"
#define SETUP_SCALE_DEFAULT_VALUE       SETUP_SCALE_MG_VALUE

#define SETUP_DEVICE_NAME_KEY           @"devicename"
#define SETUP_DEVICE_ADDRESS_KEY        @"deviceaddress"





#endif /* Constants_h */
