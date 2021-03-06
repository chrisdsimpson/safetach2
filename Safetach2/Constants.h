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


#define APP_NAME                               @"Safetach2"
#define APP_VERSION                            @"1.0.0.0031"
#define CANCEL                                 @"Cancel"
#define OK                                     @"OK"

#define FIRMWARE_FILE_VERSION                  @"1.0.5"

#define RIDE_DATA_FILE_DATE_TIME_FORMAT        @"yyyyMMdd_HHmmss"
#define RIDE_DATA_DATE_TIME_FORMAT             @"yyyy-MM-dd HH:mm:ss:SSS"
#define RIDE_DATA_FILE_LIST_FORMAT             @"MM-dd-yyyy HH:mm:ss"
#define REPORT_FILE_NAME                       @"Safetach2_Report.pdf"

/* Debug flags - Set to 1 or 0 */
#define DEBUG_DISPLAY_INFO                     1
#define DEBUG_VERSION_INFO                     1

/* State defines */
#define MENU_STATE_HOME                        1
#define MENU_STATE_GRAPH                       2
#define MENU_STATE_AUDIO                       3

#define SUB_MENU_STATE_VELOCITY                1
#define SUB_MENU_STATE_ACCELERATION            2
#define SUB_MENU_STATE_JERK                    3
#define SUB_MENU_STATE_AUDIO_LEVEL             4
#define SUB_MENU_STATE_AUDIOFREQ               5

#define FILE_LISTING_MODE_EDIT                 1
#define FILE_LISTING_MODE_REPORT               2

/* Application run state */
#define RUN_STATE_IDLE                         1
#define RUN_STATE_TRIGGER                      2
#define RUN_STATE_CAPTURE                      3
#define RUN_STATE_TRANSFER                     4
#define RUN_STATE_ERROR                        5

/* Node data capture and xfer watchdog timers */
#define WATCHDOG_TRIGGER_TIMEOUT               180000 /* 3 minutes */
#define WATCHDOG_CAPTURE_TIMEOUT               120000 /* 2 minutes */
#define WATCHDOG_TRANSFER_TIMEOUT              120000 /* 2 minutes */

/* Ride data packet transfer states */
#define PACKET_STATE_IDLE                      0
#define PACKET_STATE_GET_HEADER                1
#define PACKET_STATE_GET_DATA                  2
#define PACKET_STATE_DATA_RESEND               3
#define PACKET_STATE_DATA_RECEIVED             5
#define PACKET_STATE_DATA_REALTIME             6

#define PACKET_TRANSFER_TIMEOUT_COUNT          5

/* Levels status limits */
#define BATTERY_WARNING_LEVEL                  15
#define SIGNAL_STRENGTH_TIMEOUT                6
#define SIGNAL_STRENGTH_LEVEL                  -80
#define SIGNAL_STRENGTH_MIN                    -90
#define SIGNAL_STRENGTH_MAX                    -50


/* Packet transfer messages and node control commands */
#define CTRL_TX_IDLE                           0x00 /* Status message from the server that the device is in idle mode */
#define CTRL_RX_TRIGGER                        0x01 /* Command message from client to run in trigger mode */
#define CTRL_RX_FREERUN                        0x02 /* Command message from client to run in free run mode */
#define CTRL_RX_RESET                          0x03 /* Command message from client to reset the node */
#define CTRL_RX_REPORT                         0x04 /* Command message from client to report the node status */
#define CTRL_TX_WARMUP                         0x05 /* Status message from server that the device is warmed up */
#define CTRL_TX_PACKETREADY                    0x06 /* Status message from server that a run packet is ready to send */
#define CTRL_TX_PACKETSENT                     0x07 /* Status message from server that the run packet was sent */
#define CTRL_RX_STOP                           0x08 /* Command message from client to stop the run */
#define CTRL_RX_PACKETRESEND                   0x10 /* Command message from client to resend the packet */
#define CTRL_TX_TRIGGERED                      0x11 /* Status message from server that the device had a trigger event */
#define CTRL_TX_ARMED                          0x12 /* Status message from server that the device is waiting for a trigger */
#define CTRL_RX_PACKETRECEIVED                 0x13 /* Command message from client that the packet was received OK */
#define CTRL_RX_PACKETRESEND_25                0x14 /* Command message from client to resend 25% of the packet */
#define CTRL_RX_PACKETRESEND_50                0x15 /* Command message from client to resend 50% of the packet */
#define CTRL_RX_PACKETRESEND_75                0x16 /* Command message from client to resend 75% of the packet */
#define CTRL_RX_PACKETRESEND_99                0x17 /* Command message from client to resend 100% of the packet */
#define CTRL_RX_PACKETRESEND_100               0x18 /* Command message from client to resend 100% of the packet */
#define CTRL_RX_PACKETHEADERSEND               0x19 /* Command message from client to sent the packet header */
#define CTRL_RX_CANCEL                         0x20 /* Command message from client to cancel packet capture/transfer */
#define CTRL_RX_XFERPAUSE                      0x21 /* Command message from client to pause the packet transfer */
#define CTRL_RX_XFERRUN                        0x22 /* Command message from client to resume the packet transfer */
#define CTRL_TX_CAPTUREERROR                   0x23 /* Status message from server that the capture failed */
#define CTRL_RX_PROGRAM                        0x24 /* Command message from client to program the node with new firmware */
#define CTRL_RX_RUNTYPE_HYDRO                  0x25 /* Command message from client to capture data in hydro mode */
#define CTRL_RX_RUNTYPE_TRACTION               0x26 /* Command message from client to capture data in traction mode */

#define CTRL_INT_PACKET_ERROR                  0x30 /* Internal command indicating that the packet transfer had a error */
#define CTRL_INT_PACKET_WD_RESET               0x40 /* Internal command to reset the packet transfer watchdog timer */
#define CTRL_INT_PACKET_WD_CANCEL              0x45 /* Internal command to clear the packet transfer watchdog timer */
#define CTRL_INT_PACKET_TRANSFER               0x50 /* Internal command to report packet transfer status updates */
#define CTRL_INT_PACKET_COMPLETE               0x60 /* Internal command indicating that the packet transfer was completed */

/* Packet Identifers */
#define PACKET_ID                              0x55 /* The beginning of the packet */
#define PACKET_EOP                             0xAA /* The end of packet */

/* BLE device connection/scan time out */
#define DEVICE_CONNECTION_TIMEOUT              10.0
#define SEARCH_BAR_TAG                         101

/* String trim macro */
#define TRIM(string)                           [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

/* Color defines */
#define ColorYellow                            colorWithRed:(250.0/255.0) green:(217.0/255.0) blue:(5.0/255.0) alpha:(1.0)
#define ColorBlue                              colorWithRed:(27.0/255.0) green:(120.0/255.0) blue:(250.0/255.0) alpha:(1.0)
#define ColorRed                               colorWithRed:(255.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:(1.0)
#define ColorGreen                             colorWithRed:(1.0/255.0) green:(161.0/255.0) blue:(1.0/255.0) alpha:(1.0)
#define ColorGrey                              colorWithRed:(167.0/255.0) green:(166.0/255.0) blue:(166.0/255.0) alpha:(1.0)
#define ColorMagenta                           colorWithRed:(225.0/255.0) green:(0.0/255.0) blue:(255.0/255.0) alpha:(1.0)
#define ColorLightGrey                         colorWithRed:(217.0/255.0) green:(217.0/255.0) blue:(217.0/255.0) alpha:(1.0)
#define ColorOrange                            colorWithRed:(255.0/255.0) green:(153.0/255.0) blue:(51.0/255.0) alpha:(1.0)
#define ColorBlack                             colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:(1.0)

/* BLE service and char defines */
#define TRANSFER_SERVICE_UUID                  @"FB694B90-F49E-4597-8306-171BBA78F846"
#define TRANSFER_CHARACTERISTIC_UUID           @"EB6727C4-F184-497A-A656-76B0CDAC633A"


/* Device info UUIDs */
#define DEVICE_INFO_SERVICE_UUID               [CBUUID UUIDWithString:@"0000180A-0000-1000-8000-00805f9b34fb"]
#define DEVICE_INFO_MANUFACTURE_UUID           [CBUUID UUIDWithString:@"00002A29-0000-1000-8000-00805f9b34fb"]
#define DEVICE_INFO_MODEL_UUID                 [CBUUID UUIDWithString:@"00002A24-0000-1000-8000-00805f9b34fb"]
#define DEVICE_INFO_SERIAL_UUID                [CBUUID UUIDWithString:@"00002A25-0000-1000-8000-00805f9b34fb"]
#define DEVICE_INFO_HARDWARE_VERSION_UUID      [CBUUID UUIDWithString:@"00002A27-0000-1000-8000-00805f9b34fb"]
#define DEVICE_INFO_FIRMWARE_VERSION_UUID      [CBUUID UUIDWithString:@"00002A26-0000-1000-8000-00805f9b34fb"]

/* Battery service UUIDs */
#define BATTERY_SERVICE_UUID                   [CBUUID UUIDWithString:@"0000180F-0000-1000-8000-00805f9b34fb"]
#define BATTERY_LEVEL_UUID                     [CBUUID UUIDWithString:@"00002a19-0000-1000-8000-00805f9b34fb"]

/* Ride Quality Data Service custom UUIDs */
#define RIDE_QUALITY_DATA_SERVICE_UUID         [CBUUID UUIDWithString:@"A1A20000-0000-1000-8000-00805F9BA1A2"]
#define CTRL_DATA_CHAR_UUID                    [CBUUID UUIDWithString:@"A1A20004-0000-1000-8000-00805F9BA1A2"]
#define XYZLF_DATA_CHAR_UUID                   [CBUUID UUIDWithString:@"A1A20005-0000-1000-8000-00805F9BA1A2"]

/* OTA UUIDs */
#define CUSTOM_BOOT_LOADER_SERVICE_UUID        [CBUUID UUIDWithString:@"00060000-F8CE-11E4-ABF4-0002A5D5C51B"]
#define BOOT_LOADER_CHARACTERISTIC_UUID        [CBUUID UUIDWithString:@"00060001-F8CE-11E4-ABF4-0002A5D5C51B"]

/* Ride data file processing constants */
#define READY_STATE                            0
#define START_STATE                            1
#define ACCEL_STATE                            2
#define HISPEED_STATE                          3
#define DECEL_STATE                            4
#define LVSPEED_STATE                          5
#define STOP_STATE                             6
#define FINISH_STATE                           7

#define RIDE_TYPE_NONE                         0
#define RIDE_TYPE_HYDRO                        1
#define RIDE_TYPE_TRACTION                     2
#define RIDE_TYPE_SLOWSPEED                    3

#define RIDE_DIRECTION_UP                      1
#define RIDE_DIRECTION_DOWN                    0

#define RIDE_MODE_TRIGGERED                    0
#define RIDE_MODE_FREERUN                      1

/* Color ranges for the run */
#define HYDRO_LV_BELOW_BOTTOM                  8.0
#define HYDRO_LV_BELOW_TOP                     8.0
#define HYDRO_LV_ABOVE_BOTTOM                  12.0
#define HYDRO_LV_ABOVE_TOP                     12.0

#define HYDRO_LT_BELOW_BOTTOM                  2.0
#define HYDRO_LT_BELOW_TOP                     3.0
#define HYDRO_LT_ABOVE_BOTTOM                  4.0
#define HYDRO_LT_ABOVE_TOP                     5.0

#define HYDRO_JERK_ABOVE                       0.6
#define HYDRO_JERK_BELOW                       0.4

#define HYDRO_SA_BELOW_BOTTOM                  0.00
#define HYDRO_SA_BELOW_TOP                     0.01
#define HYDRO_SA_ABOVE_BOTTOM                  0.07
#define HYDRO_SA_ABOVE_TOP                     0.08

#define HYDRO_HA_BELOW_BOTTOM                  0.01
#define HYDRO_HA_BELOW_TOP                     0.02
#define HYDRO_HA_ABOVE_BOTTOM                  0.07
#define HYDRO_HA_ABOVE_TOP                     0.08

#define HYDRO_DA_BELOW_BOTTOM                  0.01
#define HYDRO_DA_BELOW_TOP                     0.02
#define HYDRO_DA_ABOVE_BOTTOM                  0.07
#define HYDRO_DA_ABOVE_TOP                     0.08

#define HYDRO_LA_BELOW_BOTTOM                  0.00
#define HYDRO_LA_BELOW_TOP                     0.01
#define HYDRO_LA_ABOVE_BOTTOM                  0.03
#define HYDRO_LA_ABOVE_TOP                     0.04

#define HYDRO_XA_ABOVE                         0.04
#define HYDRO_XA_BELOW                         0.03

#define HYDRO_YA_ABOVE                         0.04
#define HYDRO_YA_BELOW                         0.03

#define HYDRO_SPL_ABOVE                        85.0
#define HYDRO_SPL_BELOW                        80.0

#define RANGE_OK                               0
#define RANGE_LOW                              1
#define RANGE_HI                               2


/* User default keys and default values */
#define SETUP_RUNTYPE_KEY                      @"runtype"
#define SETUP_RUNTYPE_HYDRO_VALUE              @"hydro"
#define SETUP_RUNTYPE_TRACTION_VALUE           @"traction"
#define SETUP_RUNTYPE_DEFAULT_VALUE            SETUP_RUNTYPE_HYDRO_VALUE

#define SETUP_RUNMODE_KEY                      @"runmode"
#define SETIP_RUNMODE_TRIGGERED_VALUE          @"triggered"
#define SETUP_RUNMODE_FREERUN_VALUE            @"freerun"
#define SETUP_RUNMODE_DEFAULT_VALUE            SETUP_RUNMODE_TRIGGERED_VALUE

#define SETUP_UNITS_KEY                        @"units"
#define SETUP_UNITS_IMPERIAL_VALUE             @"imperial"
#define SETUP_UNITS_METRIC_VALUE               @"metric"
#define SETUP_UNITS_DEFAULT_VALUE              SETUP_UNITS_IMPERIAL_VALUE

#define SETUP_SCALE_KEY                        @"scale"
#define SETUP_SCALE_MG_VALUE                   @"mg"
#define SETUP_SCALE_G_VALUE                    @"g"
#define SETUP_SCALE_DEFAULT_VALUE              SETUP_SCALE_MG_VALUE

#define SETUP_DEVICE_NAME_KEY                  @"devicename"
#define SETUP_DEVICE_ADDRESS_KEY               @"deviceaddress"


/* GATT DB*/
#define CELL_BG_IMAGE                          @"list_bg"
#define CELL_BG_IMAGE_SMALL                    @"list_bg_small"


/* Device information strings */
#define MANUFACTURER_NAME                      @"Manufacturer Name"
#define MODEL_NUMBER                           @"Model Number"
#define SERIAL_NUMBER                          @"Serial Number"
#define HARDWARE_REVISION                      @"Hardware Revision"
#define FIRMWARE_REVISION                      @"Firmware Revision"
#define SOFTWARE_REVISION                      @"Software Revision"
#define SYSTEM_ID                              @"System ID"
#define REGULATORY_CERTIFICATION_DATA_LIST     @"Regulatory Certification Data List"
#define PNP_ID                                 @"PnP ID"

/* Characteristic properties*/
#define READ                                   @"Read"
#define WRITE                                  @"Write"
#define NOTIFY                                 @"Notify"
#define INDICATE                               @"Indicate"

/* Log strings */
#define CONNECTION_REQUEST                     @"Connection request sent"
#define CONNECTION_ESTABLISH                   @"Connection established"
#define PAIRING_REQUEST                        @"Pairing request sent"
#define PAIRING_RQUEST_RECEIVED                @"Pairing request received"
#define PAIRED                                 @"Paired"
#define UNPAIRED                               @"Unpaired"
#define SERVICE_DISCOVERY_REQUEST              @"Service discovery request sent"
#define SERVICE_DISCOVERY_STATUS               @"Service discovery status "
#define DISCONNECTION_REQUEST                  @"Disconnection request sent"
#define DISCONNECTED                           @"Disconnected"

#define SERVICE_DISCOVERED                     @"Success"
#define SERVICE_DISCOVERY_ERROR                @"Service discovery request failed with error : "

/* BLE operations strings */
#define WRITE_REQUEST                          @"Write request sent with value "
#define WRITE_REQUEST_STATUS                   @"Write request status "
#define WRITE_SUCCESS                          @"Success"
#define WRITE_ERROR                            @"Failed with error : "

#define START_NOTIFY                           @"Start notification request sent"
#define STOP_NOTIFY                            @"Stop notification request sent"
#define NOTIFY_RESPONSE                        @"Notification received with value "

#define READ_REQUEST                           @"Read request sent"
#define READ_RESPONSE                          @"Read response received with value "
#define READ_ERROR                             @"Failed with error : "


#define START_INDICATE                         @"Start indicate request sent"
#define STOP_INDICATE                          @"Stop indicate request sent"
#define INDICATE_RESPONSE                      @"Indicate response received with value "



/* Bootloader command codes */
#define COMMAND_START_BYTE                     0x01
#define COMMAND_END_BYTE                       0x17
#define VERIFY_CHECKSUM                        0x31
#define GET_FLASH_SIZE                         0x32
#define SEND_DATA                              0x37
#define ENTER_BOOTLOADER                       0x38
#define PROGRAM_ROW                            0x39
#define VERIFY_ROW                             0x3A
#define EXIT_BOOTLOADER                        0x3B

/* Bootloader status/Error codes */
#define SUCCESS                                @"0x00"
#define ERROR_FILE                             @"0x01"
#define ERROR_EOF                              @"0x02"
#define ERROR_LENGTH                           @"0x03"
#define ERROR_DATA                             @"0x04"
#define ERROR_COMMAND                          @"0x05"
#define ERROR_DEVICE                           @"0x06"
#define ERROR_VERSION                          @"0x07"
#define ERROR_CHECKSUM                         @"0x08"
#define ERROR_ARRAY                            @"0x09"
#define ERROR_ROW                              @"0x0A"
#define ERROR_BOOTLOADER                       @"0x0B"
#define ERROR_APPLICATION                      @"0x0C"
#define ERROR_ACTIVE                           @"0x0D"
#define ERROR_UNKNOWN                          @"0x0F"
#define ERROR_ABORT                            @"0xFF"

/* Bootloader defines */
#define FLASH_ARRAY_ID                         @"flashArrayID"
#define FLASH_ROW_NUMBER                       @"flashRowNumber"

#define CHECK_SUM                              @"checkSum"
#define CRC_16                                 @"crc_16"
#define ROW_DATA                               @"rowData"

#define LOCALIZEDSTRING(string)                NSLocalizedString(string, nil)

#endif /* Constants_h */
