/*
 * File Name:	FileSelectionTableTvewCell.h
 *
 * Version      1.0.0
 *
 * Date:		06/21/2017
 *
 * Description:
 *   This is table view cell format class for run file selection viewcontroller for the iOS Safetach2 project.
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


#import "FileSelectionTableViewCell.h"

@implementation FileSelectionTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#if 1
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        /* Helpers */
        CGSize size = self.contentView.frame.size;
        
        /* Initialize lables */
        //self.DateTime = [[UILabel alloc] init];
        //self.Direction = [[UILabel alloc] init];
        //self.Jobref = [[UILabel alloc] init];
        //self.ElevatorName = [[UILabel alloc] init];
        
        self.DateTime = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, size.width - 16.0, size.height - 16.0)];
        self.Direction = [[UILabel alloc] initWithFrame:CGRectMake(197.0, 8.0, size.width - 16.0, size.height - 16.0)];
        self.Jobref = [[UILabel alloc] initWithFrame:CGRectMake(284.0, 8.0, size.width - 16.0, size.height - 16.0)];
        self.ElevatorName = [[UILabel alloc] initWithFrame:CGRectMake(479.0, 8.0, size.width - 16.0, size.height - 16.0)];
        
        /* Configure Labels */
        //[self.DateTime setFont:[UIFont boldSystemFontOfSize:24.0]];
        //[self.DateTime setTextAlignment:NSTextAlignmentCenter];
        //[self.DateTime setTextColor:[UIColor orangeColor]];
        
        [self.DateTime setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.Direction setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.Jobref setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.ElevatorName setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        
        /* Add the Labels to Content View */
        [self.contentView addSubview:self.DateTime];
        [self.contentView addSubview:self.Direction];
        [self.contentView addSubview:self.Jobref];
        [self.contentView addSubview:self.ElevatorName];
    }

    return self;
}
#endif

- (void) setCellValues
{
    self.DateTime.text = @"Date Time";
    self.Direction.text = @"Direction";
    self.Jobref.text = @"Job Reference";
    self.ElevatorName.text = @"Elevator Name";
}

@end
