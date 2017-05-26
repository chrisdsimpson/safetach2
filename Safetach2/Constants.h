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
#define MENU_STATE_HOME             1
#define MENU_STATE_GRAPH            2
#define MENU_STATE_AUDIO            3

#define SUB_MENU_STATE_VELOCITY     1
#define SUB_MENU_STATE_ACCELERATION 2
#define SUB_MENU_STATE_JERK         3
#define SUB_MENU_STATE_AUDIO_LEVEL  4
#define SUB_MENU_STATE_AUDIOFREQ    5


/* Color defines */
#define ColorYellow                 colorWithRed:(250.0/255.0) green:(217.0/255.0) blue:(5.0/255.0) alpha:(1.0)
#define ColorBlue                   colorWithRed:(27.0/255.0) green:(120.0/255.0) blue:(250.0/255.0) alpha:(1.0)
#define ColorRed                    colorWithRed:(255.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:(1.0)
#define ColorGreen                  colorWithRed:(1.0/255.0) green:(161.0/255.0) blue:(1.0/255.0) alpha:(1.0)
#define ColorGrey                   colorWithRed:(167.0/255.0) green:(166.0/255.0) blue:(166.0/255.0) alpha:(1.0)
#define ColorMagenta                colorWithRed:(225.0/255.0) green:(0.0/255.0) blue:(255.0/255.0) alpha:(1.0)
#define ColorLightGrey              colorWithRed:(217.0/255.0) green:(217.0/255.0) blue:(217.0/255.0) alpha:(1.0)
#define ColorOrange                 colorWithRed:(255.0/255.0) green:(153.0/255.0) blue:(51.0/255.0) alpha:(1.0)



#endif /* Constants_h */
