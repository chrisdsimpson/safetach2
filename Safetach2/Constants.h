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


#define APP_NAME                          @"Safetach2"
#define APP_VERSION                       @"1.0.0"
#define CANCEL                            @"Cancel"
#define OK                                @"OK"

#define FIRMWARE_FILE_VERSION             @"1.0.5"

/* State defines */
#define MENU_STATE_HOME                   1
#define MENU_STATE_GRAPH                  2
#define MENU_STATE_AUDIO                  3

#define SUB_MENU_STATE_VELOCITY           1
#define SUB_MENU_STATE_ACCELERATION       2
#define SUB_MENU_STATE_JERK               3
#define SUB_MENU_STATE_AUDIO_LEVEL        4
#define SUB_MENU_STATE_AUDIOFREQ          5


/* BLE device connection/scan time out */
#define DEVICE_CONNECTION_TIMEOUT         10.0
#define SEARCH_BAR_TAG                    101

/* Color defines */
#define ColorYellow                       colorWithRed:(250.0/255.0) green:(217.0/255.0) blue:(5.0/255.0) alpha:(1.0)
#define ColorBlue                         colorWithRed:(27.0/255.0) green:(120.0/255.0) blue:(250.0/255.0) alpha:(1.0)
#define ColorRed                          colorWithRed:(255.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:(1.0)
#define ColorGreen                        colorWithRed:(1.0/255.0) green:(161.0/255.0) blue:(1.0/255.0) alpha:(1.0)
#define ColorGrey                         colorWithRed:(167.0/255.0) green:(166.0/255.0) blue:(166.0/255.0) alpha:(1.0)
#define ColorMagenta                      colorWithRed:(225.0/255.0) green:(0.0/255.0) blue:(255.0/255.0) alpha:(1.0)
#define ColorLightGrey                    colorWithRed:(217.0/255.0) green:(217.0/255.0) blue:(217.0/255.0) alpha:(1.0)
#define ColorOrange                       colorWithRed:(255.0/255.0) green:(153.0/255.0) blue:(51.0/255.0) alpha:(1.0)


/* BLE service and char defines */
#define TRANSFER_SERVICE_UUID             @"FB694B90-F49E-4597-8306-171BBA78F846"
#define TRANSFER_CHARACTERISTIC_UUID      @"EB6727C4-F184-497A-A656-76B0CDAC633A"


/* Device info UUIDs */
#define DEVICEINFO_SERVICE_UUID           [CBUUID UUIDWithString:@"0000180A-0000-1000-8000-00805f9b34fb"]
#define DEVICEINFO_MANUFACTURE_UUID       [CBUUID UUIDWithString:@"00002A29-0000-1000-8000-00805f9b34fb"]
#define DEVICEINFO_MODEL_UUID             [CBUUID UUIDWithString:@"00002A24-0000-1000-8000-00805f9b34fb"]
#define DEVICEINFO_SERIAL_UUID            [CBUUID UUIDWithString:@"00002A25-0000-1000-8000-00805f9b34fb"]
#define DEVICEINFO_HARDWARE_VERSION_UUID  [CBUUID UUIDWithString:@"00002A27-0000-1000-8000-00805f9b34fb"]
#define DEVICEINFO_FIRMWARE_VERSION_UUID  [CBUUID UUIDWithString:@"00002A26-0000-1000-8000-00805f9b34fb"]

/* Battery service UUIDs */
#define BATTERY_SERVICE_UUID              [CBUUID UUIDWithString:@"0000180F-0000-1000-8000-00805f9b34fb"]
#define BATTERY_LEVEL_UUID                [CBUUID UUIDWithString:@"00002a19-0000-1000-8000-00805f9b34fb"]

/* Ride Quality Data Service custom UUIDs */
#define RIDE_QUALITY_DATA_SERVICE_UUID    [CBUUID UUIDWithString:@"A1A20000-0000-1000-8000-00805F9BA1A2"]
#define CTRL_DATA_CHAR_UUID               [CBUUID UUIDWithString:@"A1A20004-0000-1000-8000-00805F9BA1A2"]
#define XYZLF_DATA_CHAR_UUID              [CBUUID UUIDWithString:@"A1A20005-0000-1000-8000-00805F9BA1A2"]

/* OTA UUIDs */
#define CUSTOM_BOOT_LOADER_SERVICE_UUID   [CBUUID UUIDWithString:@"00060000-F8CE-11E4-ABF4-0002A5D5C51B"]
#define BOOT_LOADER_CHARACTERISTIC_UUID   [CBUUID UUIDWithString:@"00060001-F8CE-11E4-ABF4-0002A5D5C51B"]



/* User default keys and default values */
#define SETUP_RUNTYPE_KEY                 @"runtype"
#define SETUP_RUNTYPE_HYDRO_VALUE         @"hydro"
#define SETUP_RUNTYPE_TRACTION_VALUE      @"traction"
#define SETUP_RUNTYPE_DEFAULT_VALUE       SETUP_RUNTYPE_HYDRO_VALUE

#define SETUP_RUNMODE_KEY                 @"runmode"
#define SETIP_RUNMODE_TRIGGERED_VALUE     @"triggered"
#define SETUP_RUNMODE_FREERUN_VALUE       @"freerun"
#define SETUP_RUNMODE_DEFAULT_VALUE       SETUP_RUNMODE_TRIGGERED_VALUE

#define SETUP_UNITS_KEY                   @"units"
#define SETUP_UNITS_IMPERIAL_VALUE        @"imperial"
#define SETUP_UNITS_METRIC_VALUE          @"metric"
#define SETUP_UNITS_DEFAULT_VALUE         SETUP_UNITS_IMPERIAL_VALUE

#define SETUP_SCALE_KEY                   @"scale"
#define SETUP_SCALE_MG_VALUE              @"mg"
#define SETUP_SCALE_G_VALUE               @"g"
#define SETUP_SCALE_DEFAULT_VALUE         SETUP_SCALE_MG_VALUE

#define SETUP_DEVICE_NAME_KEY             @"devicename"
#define SETUP_DEVICE_ADDRESS_KEY          @"deviceaddress"


/* GATT DB*/
#define CELL_BG_IMAGE                     @"list_bg"
#define CELL_BG_IMAGE_SMALL               @"list_bg_small"


/* Device information strings */
#define MANUFACTURER_NAME                 @"Manufacturer Name"
#define MODEL_NUMBER                      @"Model Number"
#define SERIAL_NUMBER                     @"Serial Number"
#define HARDWARE_REVISION                 @"Hardware Revision"
#define FIRMWARE_REVISION                 @"Firmware Revision"
#define SOFTWARE_REVISION                 @"Software Revision"
#define SYSTEM_ID                         @"System ID"
#define REGULATORY_CERTIFICATION_DATA_LIST  @"Regulatory Certification Data List"
#define PNP_ID                            @"PnP ID"

/* Characteristic properties*/
#define READ                              @"Read"
#define WRITE                             @"Write"
#define NOTIFY                            @"Notify"
#define INDICATE                          @"Indicate"

/* Log strings */
#define CONNECTION_REQUEST                @"Connection request sent"
#define CONNECTION_ESTABLISH              @"Connection established"
#define PAIRING_REQUEST                   @"Pairing request sent"
#define PAIRING_RQUEST_RECEIVED           @"Pairing request received"
#define PAIRED                            @"Paired"
#define UNPAIRED                          @"Unpaired"
#define SERVICE_DISCOVERY_REQUEST         @"Service discovery request sent"
#define SERVICE_DISCOVERY_STATUS          @"Service discovery status "
#define DISCONNECTION_REQUEST             @"Disconnection request sent"
#define DISCONNECTED                      @"Disconnected"

#define SERVICE_DISCOVERED                @"Success"
#define SERVICE_DISCOVERY_ERROR           @"Service discovery request failed with error : "

/* BLE operations strings */
#define WRITE_REQUEST                     @"Write request sent with value "
#define WRITE_REQUEST_STATUS              @"Write request status "
#define WRITE_SUCCESS                     @"Success"
#define WRITE_ERROR                       @"Failed with error : "

#define START_NOTIFY                      @"Start notification request sent"
#define STOP_NOTIFY                       @"Stop notification request sent"
#define NOTIFY_RESPONSE                   @"Notification received with value "

#define READ_REQUEST                      @"Read request sent"
#define READ_RESPONSE                     @"Read response received with value "
#define READ_ERROR                        @"Failed with error : "


#define START_INDICATE                    @"Start indicate request sent"
#define STOP_INDICATE                     @"Stop indicate request sent"
#define INDICATE_RESPONSE                 @"Indicate response received with value "



/* Bootloader command codes */
#define COMMAND_START_BYTE                0x01
#define COMMAND_END_BYTE                  0x17
#define VERIFY_CHECKSUM                   0x31
#define GET_FLASH_SIZE                    0x32
#define SEND_DATA                         0x37
#define ENTER_BOOTLOADER                  0x38
#define PROGRAM_ROW                       0x39
#define VERIFY_ROW                        0x3A
#define EXIT_BOOTLOADER                   0x3B

/* Bootloader status/Error codes */
#define SUCCESS                           @"0x00"
#define ERROR_FILE                        @"0x01"
#define ERROR_EOF                         @"0x02"
#define ERROR_LENGTH                      @"0x03"
#define ERROR_DATA                        @"0x04"
#define ERROR_COMMAND                     @"0x05"
#define ERROR_DEVICE                      @"0x06"
#define ERROR_VERSION                     @"0x07"
#define ERROR_CHECKSUM                    @"0x08"
#define ERROR_ARRAY                       @"0x09"
#define ERROR_ROW                         @"0x0A"
#define ERROR_BOOTLOADER                  @"0x0B"
#define ERROR_APPLICATION                 @"0x0C"
#define ERROR_ACTIVE                      @"0x0D"
#define ERROR_UNKNOWN                     @"0x0F"
#define ERROR_ABORT                       @"0xFF"

/* Bootloader defines */
#define FLASH_ARRAY_ID                    @"flashArrayID"
#define FLASH_ROW_NUMBER                  @"flashRowNumber"

#define CHECK_SUM                         @"checkSum"
#define CRC_16                            @"crc_16"
#define ROW_DATA                          @"rowData"

#define LOCALIZEDSTRING(string)           NSLocalizedString(string, nil)

#endif /* Constants_h */
