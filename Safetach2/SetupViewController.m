/*
 * File Name:	SetupViewController.m
 *
 * Version      1.0.0
 *
 * Date:		06/06/2017
 *
 * Description:
 *   This is setup view controller for the iOS Safetach2 project.
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


#import "SetupViewController.h"
#import "Constants.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* Get the user defaults */
    Defaults = [NSUserDefaults standardUserDefaults];
    
    /* Reterive the user data */
    DeviceName = [Defaults stringForKey:SETUP_DEVICE_NAME_KEY];
    DeviceAddress = [Defaults stringForKey:SETUP_DEVICE_ADDRESS_KEY];
    
    Units = [Defaults stringForKey:SETUP_UNITS_KEY];
    
    if([Units length] == 0)
    {
        Units = SETUP_UNITS_DEFAULT_VALUE;
        [Defaults setObject:Units forKey:SETUP_UNITS_KEY];
        [Defaults synchronize];
    }
    
    if([Units isEqualToString:SETUP_UNITS_DEFAULT_VALUE])
    {
        self.ImperialButton.backgroundColor = [UIColor ColorYellow];
        self.MetricButton.backgroundColor = [UIColor ColorLightGrey];
    }
    else
    {
        self.ImperialButton.backgroundColor = [UIColor ColorLightGrey];
        self.MetricButton.backgroundColor = [UIColor ColorYellow];
    }
    
    //NSString *units = @"mg";
    
    /* Save the user data */
    //[Defaults setObject:units forKey:SETUP_UNITS_KEY];
    //[Defaults synchronize];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTouchUp:(id)sender {

    UIButton *button = sender;
    
    switch(button.tag)
    {
        case 1:
            //NSLog(@"Button 1 Pressed");
        break;
            
        case 2:
            //NSLog(@"Button 2 Pressed");
        break;
            
        case 3:
            //NSLog(@"Button 3 Pressed");
        break;
            
        case 4:
            [self onUnitsImperialPressed];
        break;
            
        case 5:
            [self onUnitsMetricPressed];
        break;
            
        case 6:
            [self onScaleMGPressed];
        break;
            
        case 7:
            [self onScaleGPressed];
        break;
    
        case 8:
            //NSLog(@"Button 8 Pressed");
        break;

        case 9:
            [self onRunTypeHydroPressed];
        break;

        case 10:
            [self onRunTypeTractionPressed];
        break;
    }

}


- (void)onUnitsImperialPressed {
    
    self.ImperialButton.backgroundColor = [UIColor ColorYellow];
    self.MetricButton.backgroundColor = [UIColor ColorLightGrey];
    
    Units = SETUP_UNITS_DEFAULT_VALUE;
    [Defaults setObject:Units forKey:SETUP_UNITS_KEY];
    [Defaults synchronize];
    
}


- (void)onUnitsMetricPressed {
    
    self.ImperialButton.backgroundColor = [UIColor ColorLightGrey];
    self.MetricButton.backgroundColor = [UIColor ColorYellow];
    
    Units = @"metric";
    [Defaults setObject:Units forKey:SETUP_UNITS_KEY];
    [Defaults synchronize];
    
}

- (void)onScaleMGPressed {
    
    self.MGButton.backgroundColor = [UIColor ColorYellow];
    self.GButton.backgroundColor = [UIColor ColorLightGrey];
    
    
    
}


- (void)onScaleGPressed {
    
    self.MGButton.backgroundColor = [UIColor ColorLightGrey];
    self.GButton.backgroundColor = [UIColor ColorYellow];
    
    
}

- (void)onRunTypeHydroPressed {
    
    self.HydroButton.backgroundColor = [UIColor ColorYellow];
    self.TractionButton.backgroundColor = [UIColor ColorLightGrey];
    
    
    
}


- (void)onRunTypeTractionPressed {
    
    self.HydroButton.backgroundColor = [UIColor ColorLightGrey];
    self.TractionButton.backgroundColor = [UIColor ColorYellow];
    
    
}


@end
