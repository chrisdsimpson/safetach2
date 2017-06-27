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


@interface ViewController ()

@end

@implementation ViewController


/* Do any additional setup after loading the view, typically from a nib */
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    /* Debug display the application version */
    if(DEBUG_VERSION_INFO)
    {
        [self.view makeToast:[NSString stringWithFormat:@" Application Version : %@", APP_VERSION]];
    }
    
    
    /* Create the DeviceRWData class */
    RWData = [[DeviceRWData alloc] init];
    
    /* Add a new button */
    //Button01 = [UIButton buttonWithType:UIButtonTypeSystem];
    //Button01.frame = CGRectMake(80, 55, 51, 42);
    //[Button01 setBackgroundColor:[UIColor ColorYellow]];
    //[Button01 addTarget:self action:@selector(didTouchUp:)forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:Button01];
    
    
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

    
    //self.lineChartView.delegate = self;
    
    self.lineChartView.chartDescription.enabled = YES;
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
    //xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    //xAxis.labelTextColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:56/255.0 alpha:1.0];
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.centerAxisLabelsEnabled = YES;
    xAxis.axisMinimum = 0.0;
    xAxis.axisMaximum = 100.0;
    xAxis.granularity = 10.0;
    //xAxis.valueFormatter = [[DateValueFormatter alloc] init];
    
    ChartYAxis *leftAxis = self.lineChartView.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    //leftAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    //leftAxis.labelTextColor = [UIColor colorWithRed:51/255.0 green:181/255.0 blue:229/255.0 alpha:1.0];
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.granularityEnabled = YES;
    leftAxis.axisMinimum = 0.0;
    leftAxis.axisMaximum = 30.0;
    leftAxis.yOffset = 0.0;
    //leftAxis.labelTextColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:56/255.0 alpha:1.0];
    
    self.lineChartView.rightAxis.enabled = NO;
    self.lineChartView.legend.form = ChartLegendFormLine;
    
    
    
    NSMutableArray *xvalues = [[NSMutableArray alloc] init];
    NSMutableArray *yvalues = [[NSMutableArray alloc] init];
    NSMutableArray *zvalues = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 100; i++)
    {
        double val = arc4random_uniform(10) + 3;
        [xvalues addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }

    
    for (int i = 0; i < 100; i++)
    {
        double val = arc4random_uniform(10) + 3;
        [yvalues addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }

    
    for (int i = 0; i < 100; i++)
    {
        double val = arc4random_uniform(20) + 3;
        [zvalues addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }

    
    
    LineChartDataSet *set1 = nil;
    LineChartDataSet *set2 = nil;
    LineChartDataSet *set3 = nil;
    
    set1 = [[LineChartDataSet alloc] initWithValues:zvalues label:@"Z Axis"];
    set2 = [[LineChartDataSet alloc] initWithValues:xvalues label:@"X Axis"];
    set3 = [[LineChartDataSet alloc] initWithValues:yvalues label:@"Y Axis"];
    
    //set1.lineDashLengths = @[@5.f, @2.5f];
    //set1.highlightLineDashLengths = @[@5.f, @2.5f];
    
    [set1 setColor:[UIColor ColorBlue]];
    [set2 setColor:[UIColor ColorRed]];
    [set3 setColor:[UIColor ColorGreen]];
    
    [set1 setCircleColor:[UIColor ColorBlue]];
    [set2 setCircleColor:[UIColor ColorRed]];
    [set3 setCircleColor:[UIColor ColorGreen]];

    
    set1.lineWidth = 1.0;
    set2.lineWidth = 1.0;
    set3.lineWidth = 1.0;
    
    set1.circleRadius = 1.0;
    set2.circleRadius = 1.0;
    set3.circleRadius = 1.0;
    
    set1.drawCircleHoleEnabled = NO;
    set2.drawCircleHoleEnabled = NO;
    set3.drawCircleHoleEnabled = NO;
    
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set2.valueFont = [UIFont systemFontOfSize:9.f];
    set3.valueFont = [UIFont systemFontOfSize:9.f];
    
    //set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set2.formLineWidth = 1.0;
    set3.formLineWidth = 1.0;
   
    set1.formSize = 15.0;
    set2.formSize = 15.0;
    set3.formSize = 15.0;
    
    NSArray *gradientColors = @[
                                (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                               ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set1.fillAlpha = 1.f;
    set2.fillAlpha = 1.f;
    set3.fillAlpha = 1.f;
    
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set2.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set3.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    
    set1.drawFilledEnabled = NO;
    set2.drawFilledEnabled = NO;
    set3.drawFilledEnabled = NO;
    
    CGGradientRelease(gradient);
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    [dataSets addObject:set3];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    
    self.lineChartView.data = data;
    self.lineChartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    //NSArray *seconds = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    //NSArray *levels = [NSArray arrayWithObjects:@"10", @"15", @"2", @"13", @"41", @"25", @"6", @"72", @"18", @"19", nil];
    
    //self.lineChartView.noDataText = @"No data for chart";
    //self.lineChartView.noDataTextColor = [UIColor ColorRed];
    
    
    
    /* Set the button colors */
    Button01.backgroundColor = [UIColor ColorYellow];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorBlue];
    Button04.backgroundColor = [UIColor ColorBlue];
    Button05.backgroundColor = [UIColor ColorBlue];
    Button06.backgroundColor = [UIColor ColorGreen];
   
    /* Set the startup meny state */
    MenuState = MENU_STATE_HOME;
    
    [self onHomePressed];
    
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
            
    }
}

- (void) onHomePressed
{
    
    MenuState = MENU_STATE_HOME;
    
    Button01.backgroundColor = [UIColor ColorYellow];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorBlue];
    
    NSLog(@"Home Button Pressed");
    
    self.lineChartView.hidden = YES;
    self.MainScreen1.hidden = NO;
    
}

- (void) onGraphPressed
{
    
    MenuState = MENU_STATE_GRAPH;
    
    Button01.backgroundColor = [UIColor ColorBlue];
    Button02.backgroundColor = [UIColor ColorYellow];
    Button03.backgroundColor = [UIColor ColorBlue];
    
    NSLog(@"Grahp Button Pressed");
    
    self.lineChartView.hidden = NO;
    self.MainScreen1.hidden = YES;
    
    //self.lineChartView.noDataText = @"No data for chart";
    //self.lineChartView.noDataTextColor = [UIColor ColorRed];
    
}

- (void) onAudioPressed
{
    
    MenuState = MENU_STATE_AUDIO;
    
    Button01.backgroundColor = [UIColor ColorBlue];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorYellow];
    
    NSLog(@"Audio Button Pressed");
    
    self.lineChartView.hidden = NO;
    self.MainScreen1.hidden = YES;
    
    
    
    
    
    
    
}

- (void) onReportPressed
{
    
    FileListingMode = FILE_LISTING_MODE_REPORT;
    //NSLog(@"Report Button Pressed");
    
    //if(RWData != nil)
    //{
    //    NSArray *lines = [RWData readLineRideDataFile];
        
        
    //    for(int i = 0; i < ([lines count] - 1); i++)
    //    {
    //        NSLog(@"Ride Data Line = %@", [lines objectAtIndex:i]);
    //    }
    //}
    
}


- (void) onFilePressed
{
    FileListingMode = FILE_LISTING_MODE_EDIT;
    //NSLog(@"File Button Pressed");
    
    //DeviceRWData *RWData = [[DeviceRWData alloc] init];
     
    /* Temp test ride data file */
    [RWData createRideDataFile];
    [RWData writeLineRideDataFile:(NSString *)@"00085, 00016, 00425, 01000, 00037, Parking, Hydro, Car 20, Test User, Test Notes"]; /* Header sample */
    [RWData writeLineRideDataFile:(NSString *)@"16383, 16383, 16383, 10500, 00067"]; /* Calibration sample */
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"]; /* Data */
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    [RWData writeLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00000"];
    
}

- (void) onResetPressed
{
    
    
    NSLog(@"Reset Button Pressed");

}


- (void)addItem1ViewController:(FileSelectionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    
    //NSLog(@"Log - Selected file = %@", item);
    [self.view makeToast:[NSString stringWithFormat:@" File (%@) selected", item]];
    
}


@end
