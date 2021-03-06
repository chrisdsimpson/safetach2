/*
 * File Name:	ViewController.m
 *
 * Version      1.0.0
 *
 * Date:		05/22/2017
 *
 * Description:
 *   This is main view controller for the iOS Safetach2 project.
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


#import "ViewController.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "DeviceRWData.h"
#import "DateValueFormatter.h"
#import "DevieInformationModel.h"
#import "BatteryServiceModel.h"
#import "RideServiceModel.h"

@interface ViewController ()
{
    int SignalStrengthCount;
    BOOL isDeviceConnected;
    BOOL isBluetoothON;
    DevieInformationModel *deviceInfoModel;
    BatteryServiceModel *batteryModel;
    RideServiceModel *rideserviceModel;
    int RunState;
    NSTimer *TransferRunTimer;
    BOOL HeaderMessageSendFlag;
    BOOL ReadDataFlag;
}

@end

@implementation ViewController


/*!
 *  @method receiveNotifications
 *
 *  @discussion Method to receive notifications from the different BLE models.
 *
 */
-(void)receiveNotifications:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"RSSI_TYPE"])
    {
        NSDictionary *data = notification.userInfo;
        NSString *line = [data objectForKey:@"rssilevel"];
        
        int db = (int)[line integerValue];
        int percent;
        
        /* Get the signal level percent from the RSSI value */
        if(db <= SIGNAL_STRENGTH_MIN)
        {
            percent = 0;
        }
        else if(db >= SIGNAL_STRENGTH_MAX)
        {
            percent = 100;
        }
        else
        {
            percent = 2 * (db + 100);
        }
        
        //NSLog(@"Log - RSSI Level = %@", line);
        NSLog(@"log - Signal Strenght = %d%%", percent);
        
        /* If the signa strength falls low for a set numner of samples report it to the user */
        if(db < SIGNAL_STRENGTH_LEVEL)
        {
            SignalStrengthCount++;
            
            if(SignalStrengthCount > SIGNAL_STRENGTH_TIMEOUT)
            {
                SignalStrengthCount = 0;
                [self.view makeToast:[NSString stringWithFormat:@"%@ %@dB", LOCALIZEDSTRING(@"connection_weak"), line]];
            }
        }
        else
        {
            SignalStrengthCount = 0;
        }
    }
    else if([[notification name] isEqualToString:@"BATTERY_TYPE"])
    {
        NSDictionary *data = notification.userInfo;
        NSString *line = [data objectForKey:@"batterylevel"];
        NSLog(@"Log - Battery Level = %@%%", line);
        
        /* If the battery level falls below a set level report battery low to the user */
        if([line integerValue] < BATTERY_WARNING_LEVEL)
        {
            /* Display the battery low message to the user */
            [self.view makeToast:[NSString stringWithFormat:@"%@ %@%%", LOCALIZEDSTRING(@"battery_low"), line]];
        }
    }
    else if([[notification name] isEqualToString:@"CTRL_TYPE"])
    {
        NSDictionary *data = notification.userInfo;
        NSString *line = [data objectForKey:@"ctrlvalue"];
        NSLog(@"Log - CTRL Notify Value = %@", line);
        
        /* Switch on the CTRL data command responses and messages */
        switch([line integerValue])
        {
            /* Response from the node (server) that the CTRL_RX_PROGRAM command was received */
            case CTRL_RX_PROGRAM:
                
                NSLog(@"Debug - Program command response received from server");
                
            break;
                
            /* Message from the node (server) that the unit is in warm up mode */
            case CTRL_TX_WARMUP:
                /* During this state the node (server) can NOT request that a run be started */
             break;
                
            /* Message from the node (server) that the unit isn in idle mode */
            case CTRL_TX_IDLE:
                
            break;
                
            /* Message from the node (server) that it is waiting for a trigger event */
            case CTRL_TX_ARMED:
                
                if(RunState != RUN_STATE_IDLE)
                {
                    
                    
                }
                
            break;
                
            /* Message from the node (server) that a run trigger event was fired */
            case CTRL_TX_TRIGGERED:
                
                //Toast.makeText(getApplicationContext(), "CTRL_TX_TRIGGERED message received", Toast.LENGTH_SHORT).show();
                
                RunState = RUN_STATE_CAPTURE;
                //showUpDownCall(false);
                //FadeSpinnerView(true);
                
                /* Start the packet capture watchdog timer */
                [self resetPacketTransferWatchdog:WATCHDOG_CAPTURE_TIMEOUT];
                
            break;
                
            /* Message from the node (server) that the packet is ready to send */
            case CTRL_TX_PACKETREADY:
                
                /*
                 * If the client was in the middle of a run and connection was lost and the regained
                 * and the node state was packet ready then request that it be resent.
                 */
                if(RunState != RUN_STATE_IDLE && RunState != RUN_STATE_ERROR)
                {
                    /* Send the command to resend the run packet */
                    if(HeaderMessageSendFlag == false)
                    {
                        [rideserviceModel writeValueForCTRL:CTRL_RX_PACKETHEADERSEND With:^(BOOL success, NSError *error)
                        {
                            if(success)
                            {
                                //NSLog(@"Log = Write success");
                            }
                        }];
                        
                        HeaderMessageSendFlag = true;
                    }
                }
                else if(RunState == RUN_STATE_ERROR /* || RunState == RUN_STATE_IDLE */)
                {
                    /* Hide the run type label text */
                    //showRunType(false);
                    
                    /* If there is a valid packet on the node make it available for download */
                    //ImageButtonPacketDownload.setVisibility(View.VISIBLE);
                }
                
                
            break;
                
            /* Message from the node (server) that the packet was sent correctly */
            case CTRL_TX_PACKETSENT:
                
            break;
                
            /* Response from the node (Server) that the CTRL_RX_FREERUN command was received */
            case CTRL_RX_FREERUN:
                
                //Toast.makeText(getApplicationContext(), "CTRL_RX_FREERUN command received", Toast.LENGTH_SHORT).show();
                
                RunState = RUN_STATE_CAPTURE;
                
                //ImageButton6.setBackgroundColor(ColorRed);
                //blinkImage(ImageButton6, false);
                
                /* Show the cancel button */
                //ImageButtonCancel.setVisibility(View.VISIBLE);
                
                /* Disable the menu buttons */
                //ImageButton1.setEnabled(false);
                //ImageButton2.setEnabled(false);
                //ImageButton3.setEnabled(false);
                //ImageButton4.setEnabled(false);
                //ImageButton5.setEnabled(false);
                
                //ImageButtonPacketDownload.setVisibility(View.GONE);
                
                //showErrorIco(false);
                [self onHomePressed];
                
                //showMeasuredValues(false);
                //clearGraph();
                //FadeSpinnerView(true);
                
                /* Show the run type label text */
                //showRunType(true);
                
                ReadDataFlag = true;
                
            break;
                
            /* Response from the node (server) that the CTRL_RX_TRIGGER command was received */
            case CTRL_RX_TRIGGER:
                
                //Toast.makeText(getApplicationContext(), "CTRL_RX_TRIGGER command received", Toast.LENGTH_SHORT).show();
                
                RunState = RUN_STATE_TRIGGER;
                
                
                //ImageButton6.setBackgroundColor(ColorRed);
                //blinkImage(ImageButton6, false);
                
                /* Show the cancel button */
                //ImageButtonCancel.setVisibility(View.VISIBLE);
                
                /* Disable the menu buttons */
                //ImageButton1.setEnabled(false);
                //ImageButton2.setEnabled(false);
                //ImageButton3.setEnabled(false);
                //ImageButton4.setEnabled(false);
                //ImageButton5.setEnabled(false);
                
                //ImageButtonPacketDownload.setVisibility(View.GONE);
                
                //showErrorIco(false);
                [self onHomePressed];
                //showMeasuredValues(false);
                //clearGraph();
                //showUpDownCall(true);
                
                /* Show the run type label text */
                //showRunType(true);
                
                ReadDataFlag = false;
                
                /* Start the packet transfer watchdog timer */
                [self resetPacketTransferWatchdog:WATCHDOG_TRIGGER_TIMEOUT];
                
                HeaderMessageSendFlag = false;
                
            break;
                
            /* Response from the node (Server) that the CTRL_RX_STOP command was received */
            case CTRL_RX_STOP:
                
                //Toast.makeText(getApplicationContext(), "CTRL_RX_STOP command received", Toast.LENGTH_SHORT).show();
                
                ReadDataFlag = false;
                RunState = RUN_STATE_TRANSFER;
                //ImageButton6.setBackgroundColor(ColorGrey);
                //ImageButton6.setEnabled(false);
                
                /* Hide the cancel button */
                //ImageButtonCancel.setVisibility(View.GONE);
                
                /* Start the packet transfer watchdog timer */
                [self resetPacketTransferWatchdog:WATCHDOG_TRANSFER_TIMEOUT];
                
            break;
                
            /* Response from node (server) that the CTRL_RX_PACKETRESEND command was received */
            case CTRL_RX_PACKETRESEND:
                
                if(RunState == RUN_STATE_IDLE)
                {
                    /* Set the state to transferring the packet */
                    RunState = RUN_STATE_TRANSFER;
                    
                    //showMeasuredValues(false);
                    //clearGraph();
                    //FadeSpinnerView(true);
                }
                
                /* Once the resend request is received hide the button */
                //ImageButtonPacketDownload.setVisibility(View.GONE);
                
                /* Show the run type label text */
                //showRunType(true);
                
            break;
                
            /* Response from node (server) that the CTRL_RX_REPORT command was received */
            case CTRL_RX_REPORT:
                
                //NSLog(@"Debug - Report message received from server");
                
            break;
                
            /* Response from the node that the capture/transfer was canceled */
            case CTRL_RX_CANCEL:
                
                //Toast.makeText(getApplicationContext(), "CTRL_RX_CANCEL received", Toast.LENGTH_SHORT).show();
                
                /* Reset the packet transfer state */
                [rideserviceModel resetPacketTransfer];
                
                //NSLog(@"Debug - Cancel message received from server");
                
            break;
                
            /* Message from the node (server) that the capture had an error */
            case CTRL_TX_CAPTUREERROR:
                
                if(RunState != RUN_STATE_IDLE)
                {
                    [self.view makeToast:[NSString stringWithFormat:@"%@", LOCALIZEDSTRING(@"capture_error")]];
                    
                    RunState = RUN_STATE_ERROR;
                    
                    /* Cancel the packet transfer watchdog timer */
                    [self cancelPacketTransferWatchdog];
                    
                    //showUpDownCall(false);
                    //FadeSpinnerView(false);
                    //showErrorIco(true);
                    
                    //ImageButton6.setEnabled(true);
                    //ImageButton6.setBackgroundColor(ColorRed);
                    
                    /* Hide the cancel button */
                    //ImageButtonCancel.setVisibility(View.GONE);
                    
                    /* Re enable the menu buttons */
                    //ImageButton1.setEnabled(true);
                    //ImageButton2.setEnabled(true);
                    //ImageButton3.setEnabled(true);
                    //ImageButton4.setEnabled(true);
                    //ImageButton5.setEnabled(true);
                    
                    NSLog(@"Error - Node unable to capture run packet data");
                }
                
            break;
                
            /* Internal response from the BluetoothLeService service that the packet was received and processed correctly */
            case CTRL_INT_PACKET_COMPLETE:
                
                //Toast.makeText(getApplicationContext(), "CTRL_INT_PACKET_COMPLETE received", Toast.LENGTH_SHORT).show();
                
                /* Cancel the packet transfer watchdog timer */
                [self cancelPacketTransferWatchdog];
                
                //FadeSpinnerView(false);
                //showErrorIco(false);
                //showUpDownCall(false);
                //clearDisplayValues();
                //ImageButton6.setEnabled(true);
                
                
                //ImageButton6.setBackgroundColor(ColorGreen);
                
                /* Hide the cancel button */
                //ImageButtonCancel.setVisibility(View.GONE);
                
                /* Re enable the menu buttons */
                //ImageButton1.setEnabled(true);
                //ImageButton2.setEnabled(true);
                //ImageButton3.setEnabled(true);
                //ImageButton4.setEnabled(true);
                //ImageButton5.setEnabled(true);
                
                /* Only process the run if we are in a active run state */
                if(RunState != RUN_STATE_IDLE)
                {
                    RunState = RUN_STATE_IDLE;
                    /* Get the current ride data */
                    //RideData = new ProcessRideData(getApplicationContext());
                    
                    [self onHomePressed];
                    
                    //showMeasuredValues(true);
                    
                    /* Update the action menu title */
                    //getActionBar().setTitle(getResources().getString(R.string.title_activity_run_name) + DeviceRWData.getRideDataFileDateTime(DeviceRWData.getRideDataFileName()));
                    
                    /* Build the file list and load up the newest run file at startup */
                    //String filename = DeviceRWData.getNextRideDataFile(DeviceRWData.FILE_MODE_NEW, DeviceRWData.RECORD_RESET);
                }
                
            break;
                
            /* Internal response from the RideServiceModel service that the packet was not processed correctly */
            case CTRL_INT_PACKET_ERROR:
                
                //Toast.makeText(getApplicationContext(), "CTRL_INT_PACKET_ERROR received", Toast.LENGTH_SHORT).show();
                
                RunState = RUN_STATE_ERROR;
                
                /* Cancel the packet transfer watchdog timer */
                [self cancelPacketTransferWatchdog];
                
                //showUpDownCall(false);
                //FadeSpinnerView(false);
                //showErrorIco(true);
                
                //ImageButton6.setEnabled(true);
                //ImageButton6.setBackgroundColor(ColorRed);
                
                /* Hide the cancel button */
                //ImageButtonCancel.setVisibility(View.GONE);
                
                /* Re enable the menu buttons */
                //ImageButton1.setEnabled(true);
                //ImageButton2.setEnabled(true);
                //ImageButton3.setEnabled(true);
                //ImageButton4.setEnabled(true);
                //ImageButton5.setEnabled(true);
                
                NSLog(@"Error - Unable to retrieve node run packet data");
                
            break;
                
            /* Internal response from from BluetoothLeService to reset the packet transfer watchdog */
            case CTRL_INT_PACKET_WD_RESET:
                
                [self resetPacketTransferWatchdog:WATCHDOG_TRANSFER_TIMEOUT];
            
            break;
                
            /* Internal response from from BluetoothLeService to cancel the packet transfer watchdog */
            case CTRL_INT_PACKET_WD_CANCEL:
                
                [self cancelPacketTransferWatchdog];
            
            break;
                
            /* Internal message for the BluetoothLeServcie to report packet transfer status */
            case CTRL_INT_PACKET_TRANSFER:
                
                //NSString *percent = intent.getStringExtra("transferpercent");
                //XferPercent.setText(percent + "%");
                
            break;
        }
     
    }
    else if([[notification name] isEqualToString:@"XYZLF_TYPE"])
    {
        NSDictionary *data = notification.userInfo;
        NSString *line = [data objectForKey:@"xyzlfvalue"];
        
        if(DEBUG_DISPLAY_INFO)
        {
            NSLog(@"Log - XYZLF Notify Value = %@", line);
        }
        
        
        
    }

}


-(void)bluetoothStateUpdatedToState:(BOOL)state
{
    NSLog(@"Log - BLE is On = %@", state ? @"Yes" : @"No");
    isBluetoothON = state;
}


-(void)discoveryDidRefresh
{
    /* Stop the BLE device scan */
    [[CBManager sharedManager] stopScanning];
    
    /* Get the device name from the default values */
    NSString *devicename = [DefaultValues stringForKey:SETUP_DEVICE_NAME_KEY];
    
    if(devicename != nil && isBluetoothON)
    {
        /* Connect to the device/node */
        [self connectPeripheral:devicename];
    }
}


/* Do any additional setup after loading the view, typically from a nib */
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    /* Debug display the application version */
    if(DEBUG_VERSION_INFO)
    {
        [self.view makeToast:[NSString stringWithFormat:@" Application Version : %@", APP_VERSION]];
    }
    
    /* Register the notification receiver for all BLE notifications */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifications:) name:nil object:nil];
    
    /* Create the DeviceRWData class */
    //RWData = [[DeviceRWData alloc] init];
    
    
    /* Get handles to all the objects in the view */
    NSArray *arrSubviews = [self.view subviews];
    
    for(UIView *tmpView in arrSubviews)
    {
        if([tmpView isMemberOfClass:[UIButton class]])
        {
            switch(tmpView.tag)
            {
                case 1:
                    Button01 = (UIButton *)tmpView;
                break;
            
                case 2:
                    Button02 = (UIButton *)tmpView;
                break;
            
                case 3:
                    Button03 = (UIButton *)tmpView;
                break;
                    
                case 4:
                    Button04 = (UIButton *)tmpView;
                break;
                    
                case 5:
                    Button05 = (UIButton *)tmpView;
                break;
                    
                case 6:
                    Button06 = (UIButton *)tmpView;
                break;
            }
        }
    }

    
    /* Set the button colors */
    Button01.backgroundColor = [UIColor ColorYellow];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorBlue];
    Button04.backgroundColor = [UIColor ColorBlue];
    Button05.backgroundColor = [UIColor ColorBlue];
    
    /* Disable the reset button */
    Button06.enabled = NO;
    Button06.backgroundColor = [UIColor ColorLightGrey];
    
    /* Hide the battery button */
    self.BatteryMenuButton.enabled = NO;
    self.BatteryMenuButton.tintColor = [UIColor clearColor];
   
    /* Set the bluetooth button to disconnected */
    self.BluetoothMenuButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_bluetooth_disabled_black_24pt"]];
    
    /* Set the inital run state vars and flags */
    RunState = RUN_STATE_IDLE;
    HeaderMessageSendFlag = false;
    ReadDataFlag = false;
    
    /* Set the startup screen to the home screen */
    [self onHomePressed];
    
    /* Get the user defaults */
    DefaultValues = [NSUserDefaults standardUserDefaults];
    
    /* Connect to device if available and get the device info */
    [[CBManager sharedManager] setCbDiscoveryDelegate:self];
    
    // Start scanning for devices
    [[CBManager sharedManager] startScanning];
    
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
}


/* Dispose of any resources that can be recreated */
- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /* Test to see which view controller we are headed to */
    if([segue.identifier isEqualToString:@"FileSelectionViewController"])
    {
        /* Tell the child view controller that this is its delegate */
        FileSelectionViewController *controller = [segue destinationViewController];
        controller.FileListingMode = FileListingMode;
        controller.delegate = self;
    }
}


- (IBAction) didTouchUp:(id)sender
{
    UIButton *button = sender;
    
    switch(button.tag)
    {
        case 1:
            [self onHomePressed];
        break;
         
        case 2:
            [self onGraphPressed];
        break;
            
        case 3:
            [self onAudioPressed];
        break;
        
        case 4:
            [self onReportPressed];
        break;
            
        case 5:
            [self onFilePressed];
        break;
            
        case 6:
            [self onResetPressed];
        break;
            
        case 7:
            
            NSLog(@"Bluetooth Connection Button Pressed");
            
            if(isDeviceConnected)
            {
                isDeviceConnected = false;
                
                /* Kill the rssi timer */
                if(RSSITimer)
                {
                    [RSSITimer invalidate];
                    RSSITimer = nil;
                }
                
                
                /* Kill the battery timer */
                if(BatteryTimer)
                {
                    [BatteryTimer invalidate];
                    BatteryTimer = nil;
                }
                
                /* Disconnect from the device */
                [[CBManager sharedManager] disconnectPeripheral:[[CBManager sharedManager] myPeripheral]];
                
                /* Hide the battery button */
                self.BatteryMenuButton.enabled = NO;
                self.BatteryMenuButton.tintColor = [UIColor clearColor];
                
                /* Set the bluetooth button to disconnected */
                self.BluetoothMenuButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_bluetooth_disabled_black_24pt"]];
                
                
            }
            else
            {
                // Start scanning for devices
                [[CBManager sharedManager] startScanning];
            }
            

        break;
    }
}


- (void) onHomePressed
{
    NSLog(@"Home Button Pressed");
    MenuState = MENU_STATE_HOME;
    
    Button01.backgroundColor = [UIColor ColorYellow];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorBlue];
    
    self.lineChartView.hidden = YES;
    self.MainScreen1.hidden = NO;
    
}


- (void) onGraphPressed
{
    NSLog(@"Grahp Button Pressed");
    MenuState = MENU_STATE_GRAPH;
    SubMenuState = SUB_MENU_STATE_ACCELERATION;
    
    Button01.backgroundColor = [UIColor ColorBlue];
    Button02.backgroundColor = [UIColor ColorYellow];
    Button03.backgroundColor = [UIColor ColorBlue];
    
    self.lineChartView.hidden = NO;
    self.MainScreen1.hidden = YES;
    
    
    [self.lineChartView fitScreen];
    
    if(SubMenuState == SUB_MENU_STATE_ACCELERATION)
    {
        self.lineChartView.chartDescription.enabled = YES;
        //self.lineChartView.chartDescription.xOffset = 225.0;
        //self.lineChartView.chartDescription.yOffset = 215.0;
        self.lineChartView.chartDescription.font = [UIFont systemFontOfSize:16.f];
        self.lineChartView.chartDescription.text = @"Acceleration";
    
        self.lineChartView.dragEnabled = YES;
        [self.lineChartView setScaleEnabled:YES];
        self.lineChartView.pinchZoomEnabled = NO;
        self.lineChartView.drawGridBackgroundEnabled = NO;
        self.lineChartView.highlightPerDragEnabled = YES;
    
        self.lineChartView.backgroundColor = UIColor.whiteColor;
    
        self.lineChartView.legend.enabled = NO;
    
        ChartXAxis *xAxis = self.lineChartView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.drawAxisLineEnabled = YES;
        xAxis.drawGridLinesEnabled = YES;
        xAxis.centerAxisLabelsEnabled = YES;
        xAxis.axisMinimum = 0.0;
        xAxis.axisMaximum = 500.0;
        xAxis.granularity = 10.0;
        xAxis.valueFormatter = [[DateValueFormatter alloc] init];
    
        ChartYAxis *leftAxis = self.lineChartView.leftAxis;
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.granularityEnabled = YES;
        leftAxis.axisMinimum = 0.0;
        leftAxis.axisMaximum = 30.0;
        leftAxis.yOffset = 0.0;
        
        self.lineChartView.rightAxis.enabled = NO;
        self.lineChartView.legend.form = ChartLegendFormLine;

        
        LineChartDataSet *set1 = nil;
        set1 = [[LineChartDataSet alloc] init];
        [set1 setColor:[UIColor ColorRed]];
        [set1 setCircleColor:[UIColor ColorRed]];
        set1.lineWidth = 1.0;
        set1.circleRadius = 1.0;
        set1.drawCircleHoleEnabled = NO;
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        set1.label = @"X Axis";

        LineChartDataSet *set2 = nil;
        set2 = [[LineChartDataSet alloc] init];
        [set2 setColor:[UIColor ColorGreen]];
        [set2 setCircleColor:[UIColor ColorGreen]];
        set2.lineWidth = 1.0;
        set2.circleRadius = 1.0;
        set2.drawCircleHoleEnabled = NO;
        set2.formLineWidth = 1.0;
        set2.formSize = 15.0;
        set2.label = @"Y Axis";

        LineChartDataSet *set3 = nil;
        set3 = [[LineChartDataSet alloc] init];
        [set3 setColor:[UIColor ColorBlue]];
        [set3 setCircleColor:[UIColor ColorBlue]];
        set3.lineWidth = 1.0;
        set3.circleRadius = 1.0;
        set3.drawCircleHoleEnabled = NO;
        set3.formLineWidth = 1.0;
        set3.formSize = 15.0;
        set3.label = @"Z Axis";
   
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        
        /* Handles the case of no data. This is necessary because we need to generate data blank data to draw the graph */
        if(XAxisData == nil && YAxisData == nil && ZAxisData == nil)
        {
            [set1 setColor:[UIColor clearColor]];
            [set1 setCircleColor:[UIColor clearColor]];
        
            NSMutableArray *blankData = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < 500; i++)
            {
                double val = 0.0;
                [blankData addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
            }
            
            /* Set the graph X axis maximun scale value */
            xAxis.axisMaximum = blankData.count;
            
            /* Load the the data to the graph set */
            set1.values = blankData;
            
            [dataSets addObject:set1];
        }
        
        
        if(XAxisData != nil)
        {
            /* Set the graph X axis maximun scale value */
            xAxis.axisMaximum = XAxisData.count;
            
            /* Load the the data to the graph set */
            set1.values = XAxisData;
            
            [dataSets addObject:set1];
        }
        
        if(YAxisData != nil)
        {
            /* Set the graph X axis maximun scale value */
            xAxis.axisMaximum = YAxisData.count;
            
            /* Load the the data to the graph set */
            set2.values = YAxisData;
            
            [dataSets addObject:set2];
        }

        if(ZAxisData != nil)
        {
            /* Set the graph X axis maximun scale value */
            xAxis.axisMaximum = ZAxisData.count;
            
            /* Load the the data to the graph set */
            set3.values = ZAxisData;
            
            [dataSets addObject:set3];
        }
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        self.lineChartView.data = data;
    
    }
    else if(SubMenuState == SUB_MENU_STATE_VELOCITY)
    {
    
        
        
        
    }
    else if(SubMenuState == SUB_MENU_STATE_JERK)
    {
        
    
        
        
    }
    
}


- (void) onAudioPressed
{
    NSLog(@"Audio Button Pressed");
    MenuState = MENU_STATE_AUDIO;
    
    Button01.backgroundColor = [UIColor ColorBlue];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorYellow];
    
    self.lineChartView.hidden = NO;
    self.MainScreen1.hidden = YES;
    
    
    [self.lineChartView fitScreen];
    self.lineChartView.chartDescription.enabled = YES;
    //self.lineChartView.chartDescription.xOffset = 195.0;
    //self.lineChartView.chartDescription.yOffset = 215.0;
    self.lineChartView.chartDescription.font = [UIFont systemFontOfSize:16.f];
    self.lineChartView.chartDescription.text = @"Sound Pressure Level";
    
    self.lineChartView.dragEnabled = YES;
    [self.lineChartView setScaleEnabled:YES];
    self.lineChartView.pinchZoomEnabled = NO;
    self.lineChartView.drawGridBackgroundEnabled = NO;
    self.lineChartView.highlightPerDragEnabled = YES;
    
    self.lineChartView.backgroundColor = UIColor.whiteColor;
    self.lineChartView.legend.enabled = NO;
    
    ChartXAxis *xAxis = self.lineChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.centerAxisLabelsEnabled = YES;
    xAxis.axisMinimum = 0.0;
    xAxis.axisMaximum = 500.0;
    xAxis.granularity = 10.0;
    xAxis.valueFormatter = [[DateValueFormatter alloc] init];
    
    ChartYAxis *leftAxis = self.lineChartView.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.granularityEnabled = YES;
    leftAxis.axisMinimum = 0.0;
    leftAxis.axisMaximum = 140.0;
    leftAxis.yOffset = 0.0;
    
    self.lineChartView.rightAxis.enabled = NO;
    self.lineChartView.legend.form = ChartLegendFormLine;
    
    LineChartDataSet *set1 = nil;
    set1 = [[LineChartDataSet alloc] init];
    [set1 setColor:[UIColor ColorMagenta]];
    [set1 setCircleColor:[UIColor ColorMagenta]];
    set1.lineWidth = 1.0;
    set1.circleRadius = 1.0;
    set1.drawCircleHoleEnabled = NO;
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;
    set1.label = @"SPL";
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    /* Handles the case of no data. This is necessary because we need to generate data blank data to draw the graph */
    if(AudioSPLData == nil)
    {
        [set1 setColor:[UIColor clearColor]];
        [set1 setCircleColor:[UIColor clearColor]];
        
        NSMutableArray *blankData = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 500; i++)
        {
            double val = 0.0;
            [blankData addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
        }
        
        /* Set the graph X axis maximun scale value */
        xAxis.axisMaximum = blankData.count;
        
        /* Load the the data to the graph set */
        set1.values = blankData;
        
        [dataSets addObject:set1];
    }
    
    
    if(AudioSPLData != nil)
    {
        /* Set the graph X axis maximun scale value */
        xAxis.axisMaximum = AudioSPLData.count;
    
        /* Load the the data to the graph set */
        set1.values = AudioSPLData;
        
        [dataSets addObject:set1];
    }
        
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    self.lineChartView.data = data;
    
    
}


- (void) onReportPressed
{
    //NSLog(@"Report Button Pressed");
    FileListingMode = FILE_LISTING_MODE_REPORT;
    
    [self onHomePressed];
}


- (void) onFilePressed
{
    //NSLog(@"File Button Pressed");
    FileListingMode = FILE_LISTING_MODE_EDIT;
    
    /* Temp test ride data file */
    //[RWData createRideDataFile];
    //[RWData writeLineRideDataFile:(NSString *)@"00085, 00016, 00425, 01000, 00037, Parking, Hydro, Car 20, Test User, Test Notes"]; /* Header sample */
    //[RWData writeLineRideDataFile:(NSString *)@"16383, 16383, 16383, 10500, 00067"]; /* Calibration sample */
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"]; /* Data */
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    //[RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    
    [self onHomePressed];
}


- (void) onResetPressed
{
    NSLog(@"Reset Button Pressed");
    [self clearGraphData];
    [self onHomePressed];
    
    //[self initDeviceInfoModel];
    
    //[rideserviceModel writeValueForCTRL:CTRL_RX_REPORT];
    
    [rideserviceModel writeValueForCTRL:CTRL_RX_TRIGGER With:^(BOOL success, NSError *error)
    {
        if(success)
        {
            //NSLog(@"Log = Write success");
        }
    }];
    
}


- (void)addItem1ViewController:(FileSelectionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    //NSLog(@"Log - Selected file = %@", item);
    [self.view makeToast:[NSString stringWithFormat:@" File (%@) selected", item]];
    
    [self initGraphData];
    [self onHomePressed];
}


- (void)initGraphData
{
    XAxisData = [[NSMutableArray alloc] init];
    YAxisData = [[NSMutableArray alloc] init];
    ZAxisData = [[NSMutableArray alloc] init];
    AudioSPLData = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 500; i++)
    {
        double xval = arc4random_uniform(10) + 3;
        [XAxisData addObject:[[ChartDataEntry alloc] initWithX:i y:xval]];

        double yval = arc4random_uniform(10) + 3;
        [YAxisData addObject:[[ChartDataEntry alloc] initWithX:i y:yval]];
        
        double zval = arc4random_uniform(20) + 3;
        [ZAxisData addObject:[[ChartDataEntry alloc] initWithX:i y:zval]];
        
        double audioval = arc4random_uniform(10) + 40;
        [AudioSPLData addObject:[[ChartDataEntry alloc] initWithX:i y:audioval]];
    }
}


- (void) clearGraphData
{
    XAxisData = nil;
    YAxisData = nil;
    ZAxisData = nil;
    AudioSPLData = nil;
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



/*!
 *  @method readRSSILevel
 *
 *  @discussion Method to read the peripheral RSSI
 *
 */
-(void)readRSSILevel:(NSTimer *)timer
{
    [[CBManager sharedManager] readRSSI];
}


/*!
 *  @method initBatteryModel
 *
 *  @discussion Method to Initialize model
 *
 */
-(void)initBatteryModel:(NSTimer *)timer
{
    //[self initBatteryUI];
    
    CBService *myService;
    
    /* Find the device info service */
    for (CBService *service in [[CBManager sharedManager] foundServices])
    {
        if([service.UUID isEqual:BATTERY_SERVICE_UUID])
        {
            myService = service;
            break;
        }
    }
    
    /* If we find the service get the characteristic values for it */
    if(myService != nil)
    {
        [[CBManager sharedManager] setMyService:myService] ;

        batteryModel = [[BatteryServiceModel alloc] init];
        batteryModel.delegate = self;
    
        [batteryModel startDiscoverCharacteristicsWithCompletionHandler:^(BOOL success, NSError *error)
        {
            if(success)
            {
                [batteryModel readBatteryLevel];
            }
        }];
    }
}


/*!
 *  @method initRideServiceModel
 *
 *  @discussion Method to Discover the specified characteristics of a service.
 *
 */
-(void)initRideServiceModel
{
    rideserviceModel = [[RideServiceModel alloc] init];
    [rideserviceModel updateCharacteristicWithHandler:^(BOOL success, NSError *error)
    {
    
    }];
}


/*!
 *  @method connectPeripheral:name
 *
 *  @discussion Method to Discover to connect to the node.
 *
 */
-(void)connectPeripheral:(NSString *)name
{
    CBPeripheralExt *selectedBLE;
    
    if ([[CBManager sharedManager] foundPeripherals].count != 0)
    {
        
        for(CBPeripheralExt *selecteddevice in [[CBManager sharedManager] foundPeripherals])
        {
           if([selecteddevice.mPeripheral.name isEqualToString:name])
           {
               selectedBLE = selecteddevice;
           }
        }
        
        if(selectedBLE != nil)
        {
            [[CBManager sharedManager] connectPeripheral:selectedBLE.mPeripheral CompletionBlock:^(BOOL success, NSError *error)
            {
                if(success)
                {
                    isDeviceConnected = true;
                    
                    /* Display the connected message to the user */
                    [self.view makeToast:[NSString stringWithFormat:@"%@ %@", LOCALIZEDSTRING(@"bluetooth_connected"), selectedBLE.mPeripheral.name]];
                    
                    /* Set the bluetooth button to show connected */
                    self.BluetoothMenuButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_bluetooth_black_24pt"]];
                    
                    /* Show the battery button */
                    self.BatteryMenuButton.enabled = YES;
                    self.BatteryMenuButton.tintColor = [UIColor ColorBlack];
                    
                    /* Set the reset button to enabled */
                    Button06.enabled = YES;
                    Button06.backgroundColor = [UIColor ColorGreen];
                    
                    /* Read battery level every 60 seconds */
                    BatteryTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(initBatteryModel:) userInfo:nil repeats:YES];
                    
                    /* Read the battery level when first connected */
                    [BatteryTimer fire];
                    
                    /* Read the device RSSI every 10 seconds */
                    RSSITimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(readRSSILevel:) userInfo:nil repeats:YES];
                    
                    /* Read the RSSI level when first connected */
                    [RSSITimer fire];
                    
                    /* Start the ride service chars notifying */
                    [self initRideServiceModel];
                    
                    NSLog(@"Log - Conecting to : %@ %@", selectedBLE.mPeripheral.name, selectedBLE.mPeripheral.identifier);
                }
                else
                {
                    isDeviceConnected = false;
                    
                    /* Kill the rssi timer */
                    if(RSSITimer)
                    {
                        [RSSITimer invalidate];
                        RSSITimer = nil;
                    }
                    
                    /* Kill the battery timer */
                    if(BatteryTimer)
                    {
                        [BatteryTimer invalidate];
                        BatteryTimer = nil;
                    }
                                       
                    /* Display the dis-connected message to the user */
                    [self.view makeToast:[NSString stringWithFormat:@"%@ %@", LOCALIZEDSTRING(@"bluetooth_disconnected"), selectedBLE.mPeripheral.name]];
                    
                    /* Set the bluetooth button to disconnected */
                    self.BluetoothMenuButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_bluetooth_disabled_black_24pt"]];
                    
                    /* Hide the battery button */
                    self.BatteryMenuButton.enabled = NO;
                    self.BatteryMenuButton.tintColor = [UIColor clearColor];
                    
                    /* Disable the reset button */
                    Button06.enabled = NO;
                    Button06.backgroundColor = [UIColor ColorLightGrey];
                    
                    NSLog(@"Log - Disconnecting from : %@ %@", selectedBLE.mPeripheral.name, selectedBLE.mPeripheral.identifier);
                    
                    if(error)
                    {
                        NSString *errorString = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
                     
                        if(errorString.length)
                        {
                            NSLog(@"Log - %@", errorString);
                            [self.view makeToast:errorString];
                        }
                        else
                        {
                            NSLog(@"Log - Unknown Error");
                            [self.view makeToast:LOCALIZEDSTRING(@"Unknown Error")];
                        }
                    }
                }
            }];
        }
    }
}


/*!
 *  @method onWatchdogTimedout:timer
 *
 *  @discussion Method will be called when the watchdog timer fires.
 *
 */
-(void)onWatchdogTimedout:(NSTimer *)timer
{
    /* Cancel the packet transfer here */
    RunState = RUN_STATE_ERROR;
    
    //showUpDownCall(false);
    
    //FadeSpinnerView(false);
    
    //showErrorIco(true);
    
    //ImageButton6.setEnabled(true);
    //ImageButton6.setBackgroundColor(ColorRed);
    
    NSLog(@"Error - WatchDog timeout during retrieval of node run packet data");
}


/*!
 *  @method resetPacketTransferWatchdog:timeout
 *
 *  @discussion Method will start the packet transfer watchdog timer the given timeout period.
 *
 */
-(void)resetPacketTransferWatchdog:(long)timeout
{
    if(TransferRunTimer != nil)
    {
        [TransferRunTimer invalidate];
        TransferRunTimer = nil;
    }
    
    if(TransferRunTimer == nil)
    {
        TransferRunTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(onWatchdogTimedout) repeats:NO];
    }
}


/*!
 *  @method cancelPacketTransferWatchdog
 *
 *  @discussion Method will cencelthe packet transfer watchdog timer.
 *
 */
-(void)cancelPacketTransferWatchdog
{
    if(TransferRunTimer != nil)
    {
        [TransferRunTimer invalidate];
        TransferRunTimer = nil;
    }
}


@end
