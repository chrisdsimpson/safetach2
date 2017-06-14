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

    /* Set the button colors */
    Button01.backgroundColor = [UIColor ColorYellow];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorBlue];
    Button04.backgroundColor = [UIColor ColorBlue];
    Button05.backgroundColor = [UIColor ColorBlue];
    Button06.backgroundColor = [UIColor ColorGreen];
   
    /* Set the startup meny state */
    MenuState = MENU_STATE_HOME;
    
    
    
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
    
}

- (void) onGraphPressed
{
    
    MenuState = MENU_STATE_GRAPH;
    
    Button01.backgroundColor = [UIColor ColorBlue];
    Button02.backgroundColor = [UIColor ColorYellow];
    Button03.backgroundColor = [UIColor ColorBlue];
    
    NSLog(@"Grahp Button Pressed");
    
}

- (void) onAudioPressed
{
    
    MenuState = MENU_STATE_AUDIO;
    
    Button01.backgroundColor = [UIColor ColorBlue];
    Button02.backgroundColor = [UIColor ColorBlue];
    Button03.backgroundColor = [UIColor ColorYellow];
    
    NSLog(@"Audio Button Pressed");
    
}

- (void) onReportPressed
{
    
    
    NSLog(@"Report Button Pressed");
    
}


- (void) onFilePressed
{
    
    NSLog(@"File Button Pressed");
    
    //DeviceRWData *RWData = [[DeviceRWData alloc] init];
    
    [RWData CreateRideDataFile];
    [RWData WriteLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00001"];
    [RWData WriteLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00002"];
    [RWData WriteLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00003"];
    [RWData WriteLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00004"];
    [RWData WriteLineRideDataFile:(NSString *)@"00000, 00000, 00000, 00000, 00005"];
    
    
}

- (void) onResetPressed
{
    
    
    NSLog(@"Reset Button Pressed");

}

@end
