/*
 * File Name:	ProcessRideData.m
 *
 * Version      1.0.0
 *
 * Date:		07/24/2017
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


#import "ProcessRideData.h"
#import "Constants.h"


/*!
 *  @class ProcessRideData
 *
 *  @discussion Class to handle the the processing of the ride data and related operations.
 *
 */
@interface ProcessRideData()
{
    /* Leveling speed buffer */
    NSMutableArray *DataBuffer;
    int DataBufferSize;
    
    /* Vars to hold the calculated ride data */
    NSMutableArray *RawXGData;
    NSMutableArray *RawXMGData;
    NSMutableArray *RawYGData;
    NSMutableArray *RawYMGData;
    NSMutableArray *RawZGData;
    NSMutableArray *RawZMGData;
    NSMutableArray *RawSPLData;
    NSMutableArray *RawSPFData;
    NSMutableArray *VelocityDataIMP;
    NSMutableArray *VelocityDataMET;
    NSMutableArray *JerkData;
    NSMutableArray *JerkDataIMP;
    NSMutableArray *JerkDataMET;
    NSMutableArray *DataState;
    
    double HiSpeedVelocityIMP;
    double HiSpeedVelocityMET;
    double HiSpeedTime;
    double LvSpeedVelocityIMP;
    double LvSpeedVelocityMET;
    double LvSpeedTime;
    double StartAcceleration;
    double HiAcceleration;
    double DecelAcceleration;
    double StopAcceleration;
    double TotalRunTime;
    double JerkVelocityIMP;
    double JerkVelocityMET;
    double PeakStartJerkIMP;
    double MaxSPLdBValue;
    double MaxSPLFrequency;
    int RunLength;
    BOOL RunDirectionUp;
    double HiXAcceleration;
    double HiYAcceleration;
    int RideMode;
    int RideSize;
    int RideType;
    int RideDirection;
    int RideId;
    NSDate *RideDate;
    
    double XCalibrationVal;
    double YCalibrationVal;
    double ZCalibrationVal;
    double XStaticCalibrationVal;
    double YStaticCalibrationVal;
    double ZStaticCalibrationVal;
    
    double MinX;
    double MaxX;
    double MinY;
    double MaxY;
    double MinZ;
    double MaxZ;
    double MinZVelocityMET;
    double MaxZVelocityMET;
    double MinZVelocityIMP;
    double MaxZVelocityIMP;
    double MaxZJerk;
    double MinZJerk;
    double MaxZJerkIMP;
    double MinZJerkIMP;
    double MaxZJerkMET;
    double MinZJerkMET;
    
    UIColor *HiSpeedVelocityColor;
    UIColor *HiSpeedTimeColor;
    UIColor *LvSpeedVelocityColor;
    UIColor *LvSpeedTimeColor;
    UIColor *StartAccelerationColor;
    UIColor *HiAccelerationColor;
    UIColor *DecelAccelerationColor;
    UIColor *StopAccelerationColor;
    UIColor *TotalRunTimeColor;
    UIColor *JerkVelocityColor;
    UIColor *MaxSPLdBValueColor;
    UIColor *MaxSPLFrequencyColor;
    UIColor *HiXAccelerationColor;
    UIColor *HiYAccelerationColor;
    
    int HiSpeedVelocityRange;
    int HiSpeedTimeRange;
    int LvSpeedVelocityRange;
    int LvSpeedTimeRange;
    int StartAccelerationRange;
    int HiAccelerationRange;
    int DecelAccelerationRange;
    int StopAccelerationRange;
    int TotalRunTimeRange;
    int JerkVelocityRange;
    int MaxSPLdBValueRange;
    int MaxSPLFrequencyRange;
    int HiXAccelerationRange;
    int HiYAccelerationRange;
    
    UIColor *StartAccelerationMGColor;
    UIColor *HiAccelerationMGColor;
    UIColor *DecelAccelerationMGColor;
    UIColor *StopAccelerationMGColor;
    
    int StartAccelerationMGRange;
    int HiAccelerationMGRange;
    int DecelAccelerationMGRange;
    int StopAccelerationMGRange;
}

@end

@implementation ProcessRideData

@synthesize xData;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        /* Leveling speed buffer */
        DataBuffer = [[NSMutableArray alloc] init];
        DataBufferSize = 0;

        /* Vars to hold the calculated ride data */
        RawXGData = [[NSMutableArray alloc] init];
        RawXMGData = [[NSMutableArray alloc] init];
        RawYGData = [[NSMutableArray alloc] init];
        RawYMGData = [[NSMutableArray alloc] init];
        RawZGData = [[NSMutableArray alloc] init];
        RawZMGData = [[NSMutableArray alloc] init];
        RawSPLData = [[NSMutableArray alloc] init];
        RawSPFData = [[NSMutableArray alloc] init];
        VelocityDataIMP = [[NSMutableArray alloc] init];
        VelocityDataMET = [[NSMutableArray alloc] init];
        JerkData = [[NSMutableArray alloc] init];
        JerkDataIMP = [[NSMutableArray alloc] init];
        JerkDataMET = [[NSMutableArray alloc] init];
        DataState = [[NSMutableArray alloc] init];
        
        HiSpeedVelocityColor = [UIColor ColorBlack];
        HiSpeedTimeColor = [UIColor ColorBlack];
        LvSpeedVelocityColor = [UIColor ColorBlack];
        LvSpeedTimeColor = [UIColor ColorBlack];
        StartAccelerationColor = [UIColor ColorBlack];
        HiAccelerationColor = [UIColor ColorBlack];
        DecelAccelerationColor = [UIColor ColorBlack];
        StopAccelerationColor = [UIColor ColorBlack];
        TotalRunTimeColor = [UIColor ColorBlack];
        JerkVelocityColor = [UIColor ColorBlack];
        MaxSPLdBValueColor = [UIColor ColorBlack];
        MaxSPLFrequencyColor = [UIColor ColorBlack];
        HiXAccelerationColor = [UIColor ColorBlack];
        HiYAccelerationColor = [UIColor ColorBlack];

        HiSpeedVelocityRange = RANGE_OK;
        HiSpeedTimeRange = RANGE_OK;
        LvSpeedVelocityRange = RANGE_OK;
        LvSpeedTimeRange = RANGE_OK;
        StartAccelerationRange = RANGE_OK;
        HiAccelerationRange = RANGE_OK;
        DecelAccelerationRange = RANGE_OK;
        StopAccelerationRange = RANGE_OK;
        TotalRunTimeRange = RANGE_OK;
        JerkVelocityRange = RANGE_OK;
        MaxSPLdBValueRange = RANGE_OK;
        MaxSPLFrequencyRange = RANGE_OK;
        HiXAccelerationRange = RANGE_OK;
        HiYAccelerationRange = RANGE_OK;

        StartAccelerationMGColor = [UIColor ColorBlack];
        HiAccelerationMGColor = [UIColor ColorBlack];
        DecelAccelerationMGColor = [UIColor ColorBlack];
        StopAccelerationMGColor = [UIColor ColorBlack];

        StartAccelerationMGRange = RANGE_OK;
        HiAccelerationMGRange = RANGE_OK;
        DecelAccelerationMGRange = RANGE_OK;
        StopAccelerationMGRange = RANGE_OK;
    }
    
    return self;
}



/* Getters and setters for necessary class vars */
-(NSArray *) getRawXGData
{
    return RawXGData;
}

-(NSArray *) getRawXMGData
{
    return RawXMGData;
}

-(NSArray *) getRawYGData
{
    return RawYGData;
}

-(NSArray *) getRawYMGData
{
    return RawYMGData;
}

-(NSArray *) getRawZGData
{
    return RawZGData;
}

-(NSArray *) getRawZMGData
{
    return RawZMGData;
}

-(NSArray *) getRawSPLData
{
    return RawSPLData;
}

-(NSArray *) getRawSPFData
{
    return RawSPFData;
}

-(NSArray *) getVelocityDataIMP
{
    return VelocityDataIMP;
}

-(NSArray *) getVelocityDataMET
{
    return VelocityDataMET;
}

-(NSArray *) getJerkData
{
    return JerkData;
}

-(NSArray *) getJerkDataIMP
{
    return JerkDataIMP;
}

-(NSArray *) getJerkDataMET
{
    return JerkDataMET;
}

-(NSString *) getHiSpeedVelocityIMPStr
{
    return [NSString stringWithFormat:@"%.0f", HiSpeedVelocityIMP];
}

-(double) getHiSpeedVelocityIMP
{
    return HiSpeedVelocityIMP;
}

-(NSString *) getHiSpeedVelocityMETStr
{
    return [NSString stringWithFormat:@"%.03f", HiSpeedVelocityMET];
}

-(double) getHiSpeedVelocityMET
{
    return HiSpeedVelocityMET;
}

-(NSString *) getHiSpeedTimeStr
{
    return [NSString stringWithFormat:@"%.01f", HiSpeedTime];
}

-(double) getHiSpeedTime
{
    return HiSpeedTime;
}

-(NSString *) getLvSpeedVelocityIMPStr
{
    return [NSString stringWithFormat:@"%.0f", LvSpeedVelocityIMP];
}

-(double) getLvSpeedVelocityIMP
{
    return LvSpeedVelocityIMP;
}

-(NSString *) getLvSpeedVelocityMETStr
{
    /* Return leveling speed in cm/sec and NOT m/sec */
    return [NSString stringWithFormat:@"%.02f", LvSpeedVelocityMET * 100];
}

-(double) getLvSpeedVelocityMET
{
    return LvSpeedVelocityMET;
}

-(NSString *) getLvSpeedTimeStr
{
    return [NSString stringWithFormat:@"%.01f", LvSpeedTime];
}

-(double) getLvSpeedTime
{
    return LvSpeedTime;
}

-(NSString *) getStartAccelerationStr
{
    return [NSString stringWithFormat:@"%.02f", StartAcceleration];
}

-(NSString *) getStartAccelerationMGStr
{
    return [NSString stringWithFormat:@"%.0f", StartAcceleration * 1000];
}

-(double) getStartAcceleration
{
    return StartAcceleration;
}

-(NSString *) getHiAccelerationStr
{
    return [NSString stringWithFormat:@"%.02f", HiAcceleration];
}

-(NSString *) getHiAccelerationMGStr
{
    return [NSString stringWithFormat:@"%.0f", HiAcceleration * 1000];
}

-(double) getHiAcceleration
{
    return HiAcceleration;
}

    public String getDecelAccelerationStr()
    {
        return String.format("%.02f", DecelAcceleration);
    }

    public String getDecelAccelerationMGStr()
    {
        return String.format("%.0f", DecelAcceleration * 1000);
    }

    public double getDecelAcceleration()
    {
        return DecelAcceleration;
    }

    public void setDecelAcceleration(double Acceleration)
    {
        DecelAcceleration = Acceleration;
    }

    public String getStopAccelerationStr()
    {
        return String.format("%.02f", StopAcceleration);
    }

    public String getStopAccelerationMGStr()
    {
        return String.format("%.0f", StopAcceleration * 1000);
    }

    public double getStopAcceleration()
    {
        return StopAcceleration;
    }

    public void setStopAcceleration(double Acceleration)
    {
        StopAcceleration = Acceleration;
    }

    public String getTotalRunTimeStr()
    {
        return String.format("%.01f", TotalRunTime);
    }

    public double getTotalRunTime()
    {
        return TotalRunTime;
    }

    public void setTotalRunTime(double Time)
    {
        TotalRunTime = Time;
    }

    public String getJerkVelocityIMPStr()
    {
        return String.format("%.02f", JerkVelocityIMP);
    }

    public double getJerkVelocityIMP()
    {
        return JerkVelocityIMP;
    }

    public void setJerkVelocityIMP(double Velocity)
    {
        JerkVelocityIMP = Velocity;
    }

    public String getJerkVelocityMETStr()
    {
        return String.format("%.02f", JerkVelocityMET);
    }

    public double getJerkVelocityMET()
    {
        return JerkVelocityMET;
    }

    public void setJerkVelocityMET(double Velocity)
    {
        JerkVelocityMET = Velocity;
    }

    public void setPeakStartJerkIMP(double Jerk)
    {
        PeakStartJerkIMP = Jerk;
    }

    public double getPeakStartJerkIMP()
    {
        return PeakStartJerkIMP;
    }

    public String getPeakStartJerkIMPStr()
    {
        return String.format("%.02f", PeakStartJerkIMP);
    }

    public double getMaxZJerk()
    {
        return MaxZJerk;
    }

    public String getMaxZJerkStr()
    {
        return String.format("%.02f", MaxZJerk);
    }

    public double getMinZJerk()
    {
        return MinZJerk;
    }

    public String getMinZJerkStr()
    {
        return String.format("%.02f", MinZJerk);
    }

    public void setMaxZJerk(double Jerk)
    {
       MaxZJerk = Jerk;
    }

    public String getHiXAccelerationStr()
    {
        return String.format("%.02f", HiXAcceleration * 0.001);
    }

    public String getHiXAccelerationMGStr()
    {
        return String.format("%.0f", HiXAcceleration);
    }

    public double getHiXAcceleration()
    {
        return HiXAcceleration;
    }

    public void setHiXAcceleration(double Acceleration)
    {
        HiXAcceleration = Acceleration;
    }

    public String getHiYAccelerationStr()
    {
        return String.format("%.02f", HiYAcceleration * 0.001);
    }

    public String getHiYAccelerationMGStr()
    {
        return String.format("%.0f", HiYAcceleration);
    }

    public double getHiYAcceleration()
    {
        return HiYAcceleration;
    }

    public void setHiYAcceleration(double Acceleration)
    {
        HiYAcceleration = Acceleration;
    }

    public double getMaxSPLdBValue()
    {
        return MaxSPLdBValue;
    }

    public String getMaxSPLdBValueStr()
    {
        return String.format("%.0f", MaxSPLdBValue);
    }

    public void setMaxSPLdBValue(double SPLdBValue)
    {
        MaxSPLdBValue = SPLdBValue;
    }

    public double getMaxSPLFrequency()
    {
        return MaxSPLFrequency;
    }

    public String getMaxSPLFrequencyStr()
    {
        return String.format("%.0f", MaxSPLFrequency);
    }

    public void setMaxSPLFrequency(double SPLFrequency)
    {
        MaxSPLFrequency = SPLFrequency;
    }

    public int getRunLength()
    {
        return RunLength;
    }

    public boolean getRunDirectionUp()
    {
        return RunDirectionUp;
    }

    public int getRideMode()
    {
        return RideMode;
    }

    public int getRideDirection()
    {
        return RideDirection;
    }

    public int getRideSize()
    {
        return RideSize;
    }

    public int getRideType()
    {
        return RideType;
    }

    public int getRideId()
    {
        return RideId;
    }

    public Date getRideDate()
    {
        return RideDate;
    }

    public double getXCalibrationVal()
    {
        return XCalibrationVal;
    }

    public double getYCalibrationVal()
    {
        return YCalibrationVal;
    }

    public double getZCalibrationVal()
    {
        return ZCalibrationVal;
    }

    public double getMinX()
    {
        return MinX;
    }

    public double getMaxX()
    {
        return MaxX;
    }

    public double getMinY()
    {
        return MinY;
    }

    public double getMaxY()
    {
        return MaxY;
    }

    public double getMinZ()
    {
        return MinZ;
    }

    public double getMaxZ()
    {
        return MaxZ;
    }

    public double getMinZVelocityIMP()
    {
        return MinZVelocityIMP;
    }

    public double getMaxZVelocityIMP()
    {
        return MaxZVelocityIMP;
    }

    public double getMinZVelocityMET()
    {
        return MinZVelocityMET;
    }

    public double getMaxZVelocityMET()
    {
        return MaxZVelocityMET;
    }

    public String getJobRef()
    {
        return JobRef;
    }

    public void setJobRef(String str)
    {
        JobRef = str;
    }

    public String getElevatorNum()
    {
        return ElevatorNum;
    }

    public void setElevatorNum(String str)
    {
        ElevatorNum = str;
    }

    public String getElevatorType()
    {
        return ElevatorType;
    }

    public void setElevatorType(String str)
    {
        ElevatorType = str;
    }

    public String getUserName()
    {
        return UserName;
    }

    public void setUserName(String str)
    {
        UserName = str;
    }

    public String getNotes()
    {
        return Notes;
    }

    public void setNotes(String str)
    {
        Notes = str;
    }

    public int getHiSpeedVelocityColor()
    {
        return HiSpeedVelocityColor;
    }

    public int getHiSpeedTimeColor()
    {
        return HiSpeedTimeColor;
    }

    public int getLvSpeedVelocityColor()
    {
        return LvSpeedVelocityColor;
    }

    public int getLvSpeedTimeColor()
    {
        return LvSpeedTimeColor;
    }

    public int getStartAccelerationColor()
    {
        return StartAccelerationColor;
    }

    public int getStartAccelerationMGColor()
    {
        return StartAccelerationMGColor;
    }

    public int getHiAccelerationColor()
    {
        return HiAccelerationColor;
    }

    public int getHiAccelerationMGColor()
    {
        return HiAccelerationMGColor;
    }

    public int getDecelAccelerationColor()
    {
        return DecelAccelerationColor;
    }

    public int getDecelAccelerationMGColor()
    {
        return DecelAccelerationMGColor;
    }

    public int getStopAccelerationColor()
    {
        return StopAccelerationColor;
    }

    public int getStopAccelerationMGColor()
    {
        return StopAccelerationMGColor;
    }

    public int getTotalRunTimeColor()
    {
        return TotalRunTimeColor;
    }

    public int getJerkVelocityColor()
    {
        return JerkVelocityColor;
    }

    public int getMaxSPLdBValueColor()
    {
        return MaxSPLdBValueColor;
    }

    public int getMaxSPLFrequencyColor()
    {
        return MaxSPLFrequencyColor;
    }

    public int getHiXAccelerationColor()
    {
        return HiXAccelerationColor;
    }

    public int getHiYAccelerationColor()
    {
        return HiYAccelerationColor;
    }

    public int getHiSpeedVelocityRange()
    {
        return HiSpeedVelocityRange;
    }

    public int getHiSpeedTimeRange()
    {
        return HiSpeedTimeRange;
    }

    public int getLvSpeedVelocityRange()
    {
        return LvSpeedVelocityRange;
    }

    public int getLvSpeedTimeRange()
    {
        return LvSpeedTimeRange;
    }

    public int getStartAccelerationRange()
    {
        return StartAccelerationRange;
    }

    public int getStartAccelerationMGRange()
    {
        return StartAccelerationMGRange;
    }

    public int getHiAccelerationRange()
    {
        return HiAccelerationRange;
    }

    public int getHiAccelerationMGRange()
    {
        return HiAccelerationMGRange;
    }

    public int getDecelAccelerationRange()
    {
        return DecelAccelerationRange;
    }

    public int getDecelAccelerationMGRange()
    {
        return DecelAccelerationMGRange;
    }

    public int getStopAccelerationRange()
    {
        return StopAccelerationRange;
    }

    public int getStopAccelerationMGRange()
    {
        return StopAccelerationMGRange;
    }

    public int getTotalRunTimeRange()
    {
        return TotalRunTimeRange;
    }

    public int getJerkVelocityRange()
    {
        return JerkVelocityRange;
    }

    public int getMaxSPLdBValueRange()
    {
        return MaxSPLdBValueRange;
    }

    public int getMaxSPLFrequencyRange()
    {
        return MaxSPLFrequencyRange;
    }

    public int getHiXAccelerationRange()
    {
        return HiXAccelerationRange;
    }

    public int getHiYAccelerationRange()
    {
        return HiYAccelerationRange;
    }



    /* Class Constructor */
    public ProcessRideData(Context context)
    {
        this.context = context;

        /* Load the ride data */
        loadRideData();

        /* Set the color ranges for the run */
        setRideDataColor();

        /* Set the speed range for the run */
        setRideDataRange();
    }



    public void setRideDataColor()
    {
        int red = ContextCompat.getColor(context, R.color.red);
        int orange = ContextCompat.getColor(context, R.color.orange);
        int green = ContextCompat.getColor(context, R.color.green);
        double val = 0.0;

        if(RideType == RIDE_TYPE_HYDRO)
        {
            /* Get the rounded version of the number */
            val = new Double(getLvSpeedVelocityIMPStr());

            /* Set the color range for the leveling velocity */
            if((val > HYDRO_LV_ABOVE_TOP) || (val < HYDRO_LV_BELOW_BOTTOM))
            {
                LvSpeedVelocityColor = red;
            }
            else if((val > HYDRO_LV_BELOW_TOP) && (val < HYDRO_LV_ABOVE_BOTTOM))
            {
                LvSpeedVelocityColor = green;
            }
            else
            {
                LvSpeedVelocityColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getLvSpeedTimeStr());

            /* Set the color range for the leveling time */
            if((val > HYDRO_LT_ABOVE_TOP) || (val < HYDRO_LT_BELOW_BOTTOM))
            {
                LvSpeedTimeColor = red;
            }
            else if((val > HYDRO_LT_BELOW_TOP) && (val < HYDRO_LT_ABOVE_BOTTOM))
            {
                LvSpeedTimeColor = green;
            }
            else
            {
                LvSpeedTimeColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getJerkVelocityIMPStr());

            /* Set the color range for the jerk */
            if(val > HYDRO_JERK_ABOVE)
            {
                JerkVelocityColor = red;
            }
            else if(val < HYDRO_JERK_BELOW)
            {
                JerkVelocityColor = green;
            }
            else
            {
                JerkVelocityColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getStartAccelerationStr());

            /* Set the color range for the start acceleration */
            if((val > HYDRO_SA_ABOVE_TOP) || (val < HYDRO_SA_BELOW_BOTTOM))
            {
                StartAccelerationColor = red;
            }
            else if((val > HYDRO_SA_BELOW_TOP) && (val < HYDRO_SA_ABOVE_BOTTOM))
            {
                StartAccelerationColor = green;
            }
            else
            {
                StartAccelerationColor = orange;
            }

            /* Get the rounded version of the number */
            val = new Double(getStartAccelerationMGStr());

            /* Set the color range for the start acceleration */
            if((val > HYDRO_SA_ABOVE_TOP * 1000) || (val < HYDRO_SA_BELOW_BOTTOM * 1000))
            {
                StartAccelerationMGColor = red;
            }
            else if((val > HYDRO_SA_BELOW_TOP * 1000) && (val < HYDRO_SA_ABOVE_BOTTOM * 1000))
            {
                StartAccelerationMGColor = green;
            }
            else
            {
                StartAccelerationMGColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getHiAccelerationStr());

            /* Set the color range for the high acceleration */
            if((val > HYDRO_HA_ABOVE_TOP) || (val < HYDRO_HA_BELOW_BOTTOM))
            {
                HiAccelerationColor = red;
            }
            else if((val > HYDRO_HA_BELOW_TOP) && (val < HYDRO_HA_ABOVE_BOTTOM))
            {
                HiAccelerationColor = green;
            }
            else
            {
                HiAccelerationColor = orange;
            }

            /* Get the rounded version of the number */
            val = new Double(getHiAccelerationMGStr());

            /* Set the color range for the high acceleration */
            if((val > HYDRO_HA_ABOVE_TOP * 1000) || (val < HYDRO_HA_BELOW_BOTTOM * 1000))
            {
                HiAccelerationMGColor = red;
            }
            else if((val > HYDRO_HA_BELOW_TOP * 1000) && (val < HYDRO_HA_ABOVE_BOTTOM * 1000))
            {
                HiAccelerationMGColor = green;
            }
            else
            {
                HiAccelerationMGColor = orange;
            }



            /* Get the rounded version of the number */
            val = new Double(getDecelAccelerationStr());

            /* Set the color range for the decel acceleration */
            if((val > HYDRO_DA_ABOVE_TOP) || (val < HYDRO_DA_BELOW_BOTTOM))
            {
                DecelAccelerationColor = red;
            }
            else if((val > HYDRO_DA_BELOW_TOP) && (val < HYDRO_DA_ABOVE_BOTTOM))
            {
                DecelAccelerationColor = green;
            }
            else
            {
                DecelAccelerationColor = orange;
            }

            /* Get the rounded version of the number */
            val = new Double(getDecelAccelerationMGStr());

            /* Set the color range for the decel acceleration */
            if((val > HYDRO_DA_ABOVE_TOP * 1000) || (val < HYDRO_DA_BELOW_BOTTOM * 1000))
            {
                DecelAccelerationMGColor = red;
            }
            else if((val > HYDRO_DA_BELOW_TOP * 1000) && (val < HYDRO_DA_ABOVE_BOTTOM * 1000))
            {
                DecelAccelerationMGColor = green;
            }
            else
            {
                DecelAccelerationMGColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getStopAccelerationStr());

            /* Set the color range for the stop acceleration */
            if((val > HYDRO_LA_ABOVE_TOP) || (val < HYDRO_LA_BELOW_BOTTOM))
            {
                StopAccelerationColor = red;
            }
            else if((val > HYDRO_LA_BELOW_TOP) && (val < HYDRO_LA_ABOVE_BOTTOM))
            {
                StopAccelerationColor = green;
            }
            else
            {
                StopAccelerationColor = orange;
            }

            /* Get the rounded version of the number */
            val = new Double(getStopAccelerationMGStr());

            /* Set the color range for the stop acceleration */
            if((val > HYDRO_LA_ABOVE_TOP * 1000) || (val < HYDRO_LA_BELOW_BOTTOM * 1000))
            {
                StopAccelerationMGColor = red;
            }
            else if((val > HYDRO_LA_BELOW_TOP * 1000) && (val < HYDRO_LA_ABOVE_BOTTOM * 1000))
            {
                StopAccelerationMGColor = green;
            }
            else
            {
                StopAccelerationMGColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getHiXAccelerationStr());

            /* Set the color range for the X axis vibration */
            if(val > HYDRO_XA_ABOVE)
            {
                HiXAccelerationColor = red;
            }
            else if(val < HYDRO_XA_BELOW)
            {
                HiXAccelerationColor = green;
            }
            else
            {
                HiXAccelerationColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getHiYAccelerationStr());

            /* Set the color range for the Y axis vibration */
            if(val > HYDRO_YA_ABOVE)
            {
                HiYAccelerationColor = red;
            }
            else if(val < HYDRO_YA_BELOW)
            {
                HiYAccelerationColor = green;
            }
            else
            {
                HiYAccelerationColor = orange;
            }


            /* Get the rounded version of the number */
            val = new Double(getMaxSPLdBValueStr());

            /* Set the color range for the audio SPL */
            if(val > HYDRO_SPL_ABOVE)
            {
                MaxSPLdBValueColor = red;
            }
            else if(val < HYDRO_SPL_BELOW)
            {
                MaxSPLdBValueColor = green;
            }
            else
            {
                MaxSPLdBValueColor = orange;
            }

        }
        else if(RideType == RIDE_TYPE_TRACTION)
        {
            HiSpeedVelocityColor = Color.BLACK;
            HiSpeedTimeColor = Color.BLACK;
            LvSpeedVelocityColor = Color.BLACK;
            LvSpeedTimeColor = Color.BLACK;
            StartAccelerationColor = Color.BLACK;
            StartAccelerationMGColor = Color.BLACK;
            HiAccelerationColor = Color.BLACK;
            HiAccelerationMGColor = Color.BLACK;
            DecelAccelerationColor = Color.BLACK;
            DecelAccelerationMGColor = Color.BLACK;
            StopAccelerationColor = Color.BLACK;
            StopAccelerationMGColor = Color.BLACK;
            TotalRunTimeColor = Color.BLACK;
            JerkVelocityColor = Color.BLACK;
            MaxSPLdBValueColor = Color.BLACK;
            MaxSPLFrequencyColor = Color.BLACK;
            HiXAccelerationColor = Color.BLACK;
            HiYAccelerationColor = Color.BLACK;
        }
        else if(RideType == RIDE_TYPE_SLOWSPEED)
        {
            HiSpeedVelocityColor = Color.BLACK;
            HiSpeedTimeColor = Color.BLACK;
            LvSpeedVelocityColor = Color.BLACK;
            LvSpeedTimeColor = Color.BLACK;
            StartAccelerationColor = Color.BLACK;
            StartAccelerationMGColor = Color.BLACK;
            HiAccelerationColor = Color.BLACK;
            HiAccelerationMGColor = Color.BLACK;
            DecelAccelerationColor = Color.BLACK;
            DecelAccelerationMGColor = Color.BLACK;
            StopAccelerationColor = Color.BLACK;
            StopAccelerationMGColor = Color.BLACK;
            TotalRunTimeColor = Color.BLACK;
            JerkVelocityColor = Color.BLACK;
            MaxSPLdBValueColor = Color.BLACK;
            MaxSPLFrequencyColor = Color.BLACK;
            HiXAccelerationColor = Color.BLACK;
            HiYAccelerationColor = Color.BLACK;
        }
        else
        {
            HiSpeedVelocityColor = Color.BLACK;
            HiSpeedTimeColor = Color.BLACK;
            LvSpeedVelocityColor = Color.BLACK;
            LvSpeedTimeColor = Color.BLACK;
            StartAccelerationColor = Color.BLACK;
            StartAccelerationMGColor = Color.BLACK;
            HiAccelerationColor = Color.BLACK;
            HiAccelerationMGColor = Color.BLACK;
            DecelAccelerationColor = Color.BLACK;
            DecelAccelerationMGColor = Color.BLACK;
            StopAccelerationColor = Color.BLACK;
            StopAccelerationMGColor = Color.BLACK;
            TotalRunTimeColor = Color.BLACK;
            JerkVelocityColor = Color.BLACK;
            MaxSPLdBValueColor = Color.BLACK;
            MaxSPLFrequencyColor = Color.BLACK;
            HiXAccelerationColor = Color.BLACK;
            HiYAccelerationColor = Color.BLACK;
        }
    }


    public void setRideDataRange()
    {
        double val = 0.0;

        if(RideType == RIDE_TYPE_HYDRO)
        {
            /* Get the rounded version of the number */
            val = new Double(getLvSpeedVelocityIMPStr());

            /* Set the hi/low range for the leveling velocity */
            if(val >= HYDRO_LV_ABOVE_BOTTOM)
            {
                LvSpeedVelocityRange = RANGE_HI;
            }
            else if(val <= HYDRO_LV_BELOW_TOP)
            {
                LvSpeedVelocityRange = RANGE_LOW;
            }
            else
            {
                LvSpeedVelocityRange = RANGE_OK;
            }


            /* Get the rounded version of the number */
            val = new Double(getLvSpeedTimeStr());

            /* Set the hi/low range for the leveling time */
            if(val >= HYDRO_LT_ABOVE_BOTTOM)
            {
                LvSpeedTimeRange = RANGE_HI;
            }
            else if(val <= HYDRO_LT_BELOW_TOP)
            {
                LvSpeedTimeRange = RANGE_LOW;
            }
            else
            {
                LvSpeedTimeRange = RANGE_OK;
            }


            /* Set the hi/low range for the jerk */
            JerkVelocityRange = RANGE_OK;


            /* Get the rounded version of the number */
            val = new Double(getStartAccelerationStr());

            /* Set the hi/low range for the start acceleration */
            if(val >= HYDRO_SA_ABOVE_BOTTOM)
            {
                StartAccelerationRange = RANGE_HI;
            }
            else if(val <= HYDRO_SA_BELOW_TOP)
            {
                StartAccelerationRange = RANGE_LOW;
            }
            else
            {
                StartAccelerationRange = RANGE_OK;
            }

            /* Get the rounded version of the number */
            val = new Double(getStartAccelerationMGStr());

            /* Set the hi/low range for the start acceleration */
            if(val >= HYDRO_SA_ABOVE_BOTTOM * 1000)
            {
                StartAccelerationMGRange = RANGE_HI;
            }
            else if(val <= HYDRO_SA_BELOW_TOP * 1000)
            {
                StartAccelerationMGRange = RANGE_LOW;
            }
            else
            {
                StartAccelerationMGRange = RANGE_OK;
            }


            /* Get the rounded version of the number */
            val = new Double(getHiAccelerationStr());

            /* Set the hi/low range for the high acceleration */
            if(val >= HYDRO_HA_ABOVE_BOTTOM)
            {
                HiAccelerationRange = RANGE_HI;
            }
            else if(val <= HYDRO_HA_BELOW_TOP)
            {
                HiAccelerationRange = RANGE_LOW;
            }
            else
            {
                HiAccelerationRange = RANGE_OK;
            }

            /* Get the rounded version of the number */
            val = new Double(getHiAccelerationMGStr());

            /* Set the hi/low range for the high acceleration */
            if(val >= HYDRO_HA_ABOVE_BOTTOM * 1000)
            {
                HiAccelerationMGRange = RANGE_HI;
            }
            else if(val <= HYDRO_HA_BELOW_TOP * 1000)
            {
                HiAccelerationMGRange = RANGE_LOW;
            }
            else
            {
                HiAccelerationMGRange = RANGE_OK;
            }


            /* Get the rounded version of the number */
            val = new Double(getDecelAccelerationStr());

            /* Set the hi/low  range for the decel acceleration */
            if(val >= HYDRO_DA_ABOVE_BOTTOM)
            {
                DecelAccelerationRange = RANGE_HI;
            }
            else if(val <= HYDRO_DA_BELOW_TOP)
            {
                DecelAccelerationRange = RANGE_LOW;
            }
            else
            {
                DecelAccelerationRange = RANGE_OK;
            }

            /* Get the rounded version of the number */
            val = new Double(getDecelAccelerationMGStr());

            /* Set the hi/low  range for the decel acceleration */
            if(val >= HYDRO_DA_ABOVE_BOTTOM * 1000)
            {
                DecelAccelerationMGRange = RANGE_HI;
            }
            else if(val <= HYDRO_DA_BELOW_TOP * 1000)
            {
                DecelAccelerationMGRange = RANGE_LOW;
            }
            else
            {
                DecelAccelerationMGRange = RANGE_OK;
            }


            /* Get the rounded version of the number */
            val = new Double(getStopAccelerationStr());

            /* Set the hi/low range for the stop acceleration */
            if(val >= HYDRO_LA_ABOVE_BOTTOM)
            {
                StopAccelerationRange = RANGE_HI;
            }
            else if(val <= HYDRO_LA_BELOW_TOP)
            {
                StopAccelerationRange = RANGE_LOW;
            }
            else
            {
                StopAccelerationRange = RANGE_OK;
            }

            /* Get the rounded version of the number */
            val = new Double(getStopAccelerationMGStr());

            /* Set the hi/low range for the stop acceleration */
            if(val >= HYDRO_LA_ABOVE_BOTTOM * 1000)
            {
                StopAccelerationMGRange = RANGE_HI;
            }
            else if(val <= HYDRO_LA_BELOW_TOP * 1000)
            {
                StopAccelerationMGRange = RANGE_LOW;
            }
            else
            {
                StopAccelerationMGRange = RANGE_OK;
            }


            /* Get the rounded version of the number */
            val = new Double(getHiXAccelerationStr());

            /* Set the range for the X axis vibration */
            if(val >= HYDRO_XA_BELOW)
            {
                HiXAccelerationRange = RANGE_HI;
            }


            /* Get the rounded version of the number */
            val = new Double(getHiYAccelerationStr());

            /* Set the range for the Y axis vibration */
            if(val >= HYDRO_YA_BELOW)
            {
                HiYAccelerationRange = RANGE_HI;
            }

            /* Set the range for the audio SPL */
            MaxSPLdBValueRange = RANGE_OK;
            MaxSPLFrequencyRange = RANGE_OK;

        }
        else if(RideType == RIDE_TYPE_TRACTION)
        {
            HiSpeedVelocityRange = RANGE_OK;
            HiSpeedTimeRange = RANGE_OK;
            LvSpeedVelocityRange = RANGE_OK;
            LvSpeedTimeRange = RANGE_OK;
            StartAccelerationRange = RANGE_OK;
            StartAccelerationMGRange = RANGE_OK;
            HiAccelerationRange = RANGE_OK;
            HiAccelerationMGRange = RANGE_OK;
            DecelAccelerationRange = RANGE_OK;
            DecelAccelerationMGRange = RANGE_OK;
            StopAccelerationRange = RANGE_OK;
            StopAccelerationMGRange = RANGE_OK;
            TotalRunTimeRange = RANGE_OK;
            JerkVelocityRange = RANGE_OK;
            MaxSPLdBValueRange = RANGE_OK;
            MaxSPLFrequencyRange = RANGE_OK;
            HiXAccelerationRange = RANGE_OK;
            HiYAccelerationRange = RANGE_OK;
        }
        else if(RideType == RIDE_TYPE_SLOWSPEED)
        {
            HiSpeedVelocityRange = RANGE_OK;
            HiSpeedTimeRange = RANGE_OK;
            LvSpeedVelocityRange = RANGE_OK;
            LvSpeedTimeRange = RANGE_OK;
            StartAccelerationRange = RANGE_OK;
            StartAccelerationMGRange = RANGE_OK;
            HiAccelerationRange = RANGE_OK;
            HiAccelerationMGRange = RANGE_OK;
            DecelAccelerationRange = RANGE_OK;
            DecelAccelerationMGRange = RANGE_OK;
            StopAccelerationRange = RANGE_OK;
            StopAccelerationMGRange = RANGE_OK;
            TotalRunTimeRange = RANGE_OK;
            JerkVelocityRange = RANGE_OK;
            MaxSPLdBValueRange = RANGE_OK;
            MaxSPLFrequencyRange = RANGE_OK;
            HiXAccelerationRange = RANGE_OK;
            HiYAccelerationRange = RANGE_OK;
        }
        else
        {
            HiSpeedVelocityRange = RANGE_OK;
            HiSpeedTimeRange = RANGE_OK;
            LvSpeedVelocityRange = RANGE_OK;
            LvSpeedTimeRange = RANGE_OK;
            StartAccelerationRange = RANGE_OK;
            StartAccelerationMGRange = RANGE_OK;
            HiAccelerationRange = RANGE_OK;
            HiAccelerationMGRange = RANGE_OK;
            DecelAccelerationRange = RANGE_OK;
            DecelAccelerationMGRange = RANGE_OK;
            StopAccelerationRange = RANGE_OK;
            StopAccelerationMGRange = RANGE_OK;
            TotalRunTimeRange = RANGE_OK;
            JerkVelocityRange = RANGE_OK;
            MaxSPLdBValueRange = RANGE_OK;
            MaxSPLFrequencyRange = RANGE_OK;
            HiXAccelerationRange = RANGE_OK;
            HiYAccelerationRange = RANGE_OK;
        }
    }


    /*
     *  This method reads the data from the ride data file one line at
     *  a time, parses the line to get the time and Z axis info which
     *  is used to create a ride profile and display it on the screen.
     *
     */
    protected void loadRideData()
    {
        int NumLines = 0;
        Date LastDate = new Date();
        double LastAccel = 0.0;
        double AccelDelta = 0.0;
        double Jerk = 0.0;
        long LastTime = 0;
        double LastVelocity = 0.0;
        double LastVelocityMetric = 0.0;

        double UVel = 0.0;
        double UVelMetric = 0.0;
        double HiVelocity = 0.0;
        double HiVelocityMetric = 0.0;
        long HiTime = 0;
        double LevelingVelocity = 0.0;
        double LevelingVelocityMetric = 0.0;
        long LevelingTime = 0;
        double HiJerk = 0.0;
        double HiJerkMetric = 0.0;

        long TotalTime = 0;
        long RunTime = 0;
        double Accelmg = 0;
        double Decelmg = 0;
        double Startmg = 0;
        double Stopmg = 0;
        boolean StartFlag = false;

        int SCount = 0;
        double SZSum = 0;
        int ACount = 0;
        double AZSum = 0;
        double ZmgSum = 0;
        int ZCount = 0;
        int HighSpeedCount = 0;
        int TriggerCount = 0;
        int Lasti = 0;
        int CurrentRunState = 0;
        int XOffset = 0;
        int YOffset = 0;
        int ZOffset = 0;


        /* Used to parse the date string */
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
        Date date = new Date();

        FilterAveraging FA = new FilterAveraging(9);
        FilterData FD = new FilterData(17);

        /* Open the ride data file */
        if(!DeviceRWData.openReadRideDataFile(DeviceRWData.getRideDataFileName()))
        {
            String tstr = "Unable to open file (" + DeviceRWData.getRideDataFileName() + ")";
            Log.e(TAG, "Error - " + tstr);
        }
        else
        {
            /* Get the number of lines from the ride data file minus the header line */
            try
            {
                NumLines = DeviceRWData.countFileLines(DeviceRWData.getRideDataFileName()) - 1;
            }
            catch(IOException err)
            {
                String tstr = "Unable to get number of lines in file (" + DeviceRWData.getRideDataFileName() + ")";
                Log.e(TAG, "Error - " + tstr);
            }
        }

        if(NumLines > 0)
        {
            /* Init all the arrays */
            DataBufferSize = NumLines;
            DataBuffer = new double[NumLines];

            RawXGData = new double[NumLines];
            RawXMGData = new double[NumLines];
            RawYGData = new double[NumLines];
            RawYMGData = new double[NumLines];
            RawZGData = new double[NumLines];
            RawZMGData = new double[NumLines];
            RawSPLData = new double[NumLines];
            RawSPFData = new double[NumLines];
            VelocityDataIMP = new double[NumLines];
            VelocityDataMET = new double[NumLines];
            JerkData = new double[NumLines];
            DataState = new int[NumLines];

            RunLength = NumLines;


            /* Get the header line from the file before we start */
            String header = DeviceRWData.readRideDataFile();

            /* Parse out the header details for later use */
            String headerparts[] = header.split(",");

            try
            {
                RideDate = format.parse(headerparts[0]);
            }
            catch(Exception err)
            {
                err.printStackTrace();
                Log.e(TAG, "Error - Unable to parse the date field");
            }

            RideSize = Integer.valueOf(headerparts[3].trim());
            RideId = Integer.valueOf(headerparts[4].trim());
            int ridedata = Integer.valueOf(headerparts[5].trim());

            /* Strip out the ride mode */
            if((ridedata & 0x03) == 0x01)
            {
                RideMode = RIDE_MODE_TRIGGERED;
            }
            else
            {
                RideMode = RIDE_MODE_FREERUN;
            }

            /* Strip out the ride direction */
            if((ridedata & 0x30) == 0x10)
            {
                RideDirection = RIDE_DIRECTION_UP;
            }
            else
            {
                RideDirection = RIDE_DIRECTION_DOWN;
            }

            /* Strip out the ride type */
            if((ridedata & 0x0C) == 0x04)
            {
                RideType = RIDE_TYPE_HYDRO;
            }
            else if((ridedata & 0x0C) == 0x08)
            {
                RideType = RIDE_TYPE_TRACTION;
            }
            else
            {
                RideType = RIDE_TYPE_SLOWSPEED;
            }



            /* Test to see if job info is in the header file and if so load it */
            if(headerparts.length > 6)
            {
                JobRef = headerparts[6].trim();
                ElevatorType = headerparts[7].trim();
                ElevatorNum = headerparts[8].trim();
                UserName = headerparts[9].trim();
                Notes = headerparts[10].trim();
            }


            /* Loop through the lines to create the ride profile */
            for(int i = 0; i < NumLines; i++)
            {
                /* Split the lines from the run data file */
                String line = DeviceRWData.readRideDataFile();
                String lineparts[] = line.split(",");

                try
                {
                    date = format.parse(lineparts[0]);
                }
                catch(Exception err)
                {
                    err.printStackTrace();
                    Log.e(TAG, "Error - Unable to parse the date field");
                }

                /* Init the time value so we start with a 0 time */
                if(i == 0)
                {
                    //LastTime = date.getTime();
                    StartFlag = false;

                    /* Get the gravity offset value from the first line in the file */
                    XOffset = Integer.valueOf(lineparts[1].trim());
                    YOffset = Integer.valueOf(lineparts[2].trim());
                    ZOffset = Integer.valueOf(lineparts[3].trim());

                    XStaticCalibrationVal = 6555.0;
                    YStaticCalibrationVal = 6555.0;
                    ZStaticCalibrationVal = Integer.valueOf(lineparts[4].trim());

                    if(ZStaticCalibrationVal == 0.0)
                    {
                        ZStaticCalibrationVal = 10533.0;
                    }

                    XCalibrationVal = XOffset;
                    YCalibrationVal = YOffset;
                    ZCalibrationVal = ZOffset;
                }

                /* Get the time between accel samples */
                //long ms = date.getTime() - LastTime;

                /* Save the last time for the next calculation */
                //LastTime = date.getTime();

                /* Samples per second from the node */
                int ms = Integer.parseInt(context.getString(R.string.samples_per_second));

                /* Get the X data from the split line */
                int xdata = Integer.valueOf(lineparts[1].trim());

                /* Get the Y data from the split line */
                int ydata = Integer.valueOf(lineparts[2].trim());

                /* Get the z data from the split line */
                int zdata = Integer.valueOf(lineparts[3].trim());

                /* Get the SPL data from the split line */
                int spldata = Integer.valueOf(lineparts[4].trim());

                /* Get the SPF data from the split line */
                int spfdata = Integer.valueOf(lineparts[5].trim());

                /* Remove the 1g gravity and calibration offset */
                xdata = xdata - XOffset;
                ydata = ydata - YOffset;
                zdata = zdata - ZOffset;

                /* Save the data in the storage arrays */
                RawXGData[i] = xdata / XStaticCalibrationVal;
                RawXMGData[i] = xdata / XStaticCalibrationVal * 1000;
                RawYGData[i] = ydata / YStaticCalibrationVal;
                RawYMGData[i] = ydata / YStaticCalibrationVal * 1000;

                /* Second proto board */
                RawZGData[i] = zdata / ZStaticCalibrationVal;
                RawZMGData[i] = zdata / ZStaticCalibrationVal * 1000;

                /* First proto board */
                //RawZGData[i] = zdata / 10587.0;
                //RawZMGData[i] = zdata / 10587.0 * 1000;

                /* Frankinboard */
                //RawZGData[i] = zdata / 12480.0;
                //RawZMGData[i] = zdata / 12480.0 * 1000;


                /* Get the rms value for the 20ms audio window and convert to dB */
                String rmststr = lineparts[4].replace('-', '0');
                double rms = Double.parseDouble("0." + rmststr.substring(1).trim());

                /* Convert rms to dB (SPL) */
                double dB = (20 * Math.log10(rms));

                /* Apply the reference level and save */
                RawSPLData[i] = dB + 120;

                /* Save the sound frequency data */
                RawSPFData[i] = (double)spfdata;

                /* The first sample (index 0) is XYZ calibration data only */
                if(i == 1)
                {
                    RawSPLData[0] = RawSPLData[i];
                    RawSPFData[0] = RawSPFData[i];
                }

                /* Get the max audio SPL db value for the run */
                if(RawSPLData[i] > MaxSPLdBValue)
                {
                    MaxSPLdBValue = RawSPLData[i];
                }


                /* Get the min and max values for each axis */
                if(RawXGData[i] < MinX)
                {
                    MinX = RawXGData[i];
                }

                if(RawXGData[i] > MaxX)
                {
                    MaxX = RawXGData[i];
                }

                if(RawYGData[i] < MinY)
                {
                    MinY = RawYGData[i];
                }

                if(RawYGData[i] > MaxY)
                {
                    MaxY = RawYGData[i];
                }

                if(RawZGData[i] < MinZ)
                {
                    MinZ = RawZGData[i];
                }

                if(RawZGData[i] > MaxZ)
                {
                    MaxZ = RawZGData[i];
                }


                /* Run the value through the low pass averaging filter */
                //double filteredzdata = FD.filter(zdata);
                //double filteredzdata = FA.Filter(zdata);
                double filteredzdata = zdata;

                /* Convert from raw data to mg */
                //double zmg = filteredzdata * Double.parseDouble(getString(R.string.mg_constant));

                /* Second proto board */
                double zmg = filteredzdata / ZStaticCalibrationVal * 1000;

                /* First proto board */
                //double zmg = filteredzdata / 10587.0 * 1000;

                /* Frankinboard */
                //double zmg = filteredzdata / 12480.0 * 1000;


                double xmg = RawXMGData[i];
                double ymg = RawYMGData[i];


                /* Don't use any acceleration values under 4 mg's */
                if (zmg < 4.0 && zmg > -4.0)
                {
                    zmg = 0.0;
                }

                /* Convert from mgs to gs */
                double zg = zmg * 0.001;

                /* Remove the Z sign */
                if(zmg < 0)
                {
                    zmg = -zmg;
                }

                /* Remove the X sign */
                if(xmg < 0)
                {
                    xmg = -xmg;
                }

                /* Get the max X acceleration */
                if(xmg > HiXAcceleration)
                {
                    HiXAcceleration = xmg;
                }

                /* Remove the Y sign */
                if(ymg < 0)
                {
                    ymg = -ymg;
                }

                /* Get the max Y acceleration */
                if(ymg > HiYAcceleration)
                {
                    HiYAcceleration = ymg;
                }

                /* Store the value for leveling speed calc */
                DataBuffer[i] = zg;

                /* Trigger the run start */
                if (StartFlag == false && CurrentRunState == READY_STATE && zmg > 7.5)
                {
                    if(i == Lasti + 1)
                    {
                        TriggerCount++;
                    }
                    else
                    {
                        TriggerCount = 0;
                    }

                    Lasti = i;

                    if(TriggerCount > 10)
                    {
                        CurrentRunState = START_STATE;
                        StartFlag = true;
                        Lasti = 0;
                        TriggerCount = 0;

                        /* Get the run direction */
                        if(zg > 0)
                        {
                            RunDirectionUp = true;
                        }
                        else
                        {
                            RunDirectionUp = false;
                        }
                    }
                }


                if(StartFlag == true)
                {
                    /* Sum up the run time */
                    RunTime += ms;

                    /* Sum the mg */
                    ZmgSum += zmg;


                    /* Save the Start mg */
                    if(CurrentRunState == START_STATE && RunTime <= 150)
                    {
                        if(zmg > Startmg)
                        {
                            Startmg = zmg;
                        }

                        /* Get the peak start jerk value */
                        if(HiJerk > PeakStartJerkIMP)
                        {
                            PeakStartJerkIMP = HiJerk;
                        }
                    }
                    else if(CurrentRunState == START_STATE && RunTime > 150)
                    {
                        CurrentRunState = ACCEL_STATE;
                    }

                    /* Save the Accel mg */
                    if(CurrentRunState == ACCEL_STATE)
                    {
                        if(zmg > Accelmg)
                        {
                            Accelmg = zmg;
                        }

                        /* Save the state of the data in the array */
                        DataState[i] = ACCEL_STATE;
                    }


                    if(CurrentRunState == ACCEL_STATE && zmg < 6.5)
                    {
                        if(i == Lasti + 1)
                        {
                            TriggerCount++;
                        }
                        else
                        {
                            TriggerCount = 0;
                        }

                        Lasti = i;

                        if(TriggerCount > 12)
                        {
                            CurrentRunState = HISPEED_STATE;
                            Lasti = 0;
                            TriggerCount = 0;
                        }
                    }

                    if(CurrentRunState == HISPEED_STATE)
                    {
                        HiTime += ms;

                        UVel = LastVelocity;
                        UVelMetric = LastVelocityMetric;

                        if(UVel < 0)
                        {
                            UVel = -UVel;
                        }

                        if(UVelMetric < 0)
                        {
                            UVelMetric = -UVelMetric;
                        }

                        if(UVel > HiVelocity)
                        {
                            HiVelocity = UVel;
                        }

                        if(UVelMetric > HiVelocityMetric)
                        {
                            HiVelocityMetric = UVelMetric;
                        }

                        /* Calculate hispeed velocity and if over the threshold set the run type to traction */
                        /* This is a simple hack to handle traction lift systems with no leveling */
                        //if(HiVelocity > Double.parseDouble(context.getString(R.string.traction_threshold)))
                        //{
                        //   RideType = RIDE_TYPE_TRACTION;
                        //}
                        //else if(HiVelocity < Double.parseDouble(context.getString(R.string.slowspeed_threshold)))
                        //{
                        //    RideType = RIDE_TYPE_SLOWSPEED;
                        //}
                        //else
                        //{
                        //    RideType = RIDE_TYPE_HYDRO;
                        //}

                        /* Save the state of the data in the array */
                        DataState[i] = HISPEED_STATE;

                    }

                    if(CurrentRunState == HISPEED_STATE && zmg > 7.0)
                    {
                        if(i == Lasti + 1)
                        {
                            TriggerCount++;
                        }
                        else
                        {
                            TriggerCount = 0;
                        }

                        Lasti = i;

                        if(TriggerCount > 8)
                        {
                            CurrentRunState = DECEL_STATE;

                            Lasti = 0;
                            TriggerCount = 0;
                        }
                    }

                    if(CurrentRunState == DECEL_STATE)
                    {
                        if(zmg > Decelmg)
                        {
                            Decelmg = zmg;
                        }

                        /* Save the state of the data in the array */
                        DataState[i] = DECEL_STATE;
                    }

                    if(CurrentRunState == DECEL_STATE && zmg < 5.0)
                    {
                        if(i == Lasti + 1)
                        {
                            TriggerCount++;
                        }
                        else
                        {
                            TriggerCount = 0;
                        }

                        Lasti = i;

                        if(TriggerCount > 12)
                        {
                            /* Test to see which type of run this is and change states accordingly */
                            if(RideType == RIDE_TYPE_SLOWSPEED || RideType == RIDE_TYPE_TRACTION)
                            {
                                CurrentRunState = STOP_STATE;
                            }
                            else
                            {
                                CurrentRunState = LVSPEED_STATE;
                            }

                            Lasti = 0;
                            TriggerCount = 0;

                            /* Back fill the state with the number of trigger counts */
                            //for(int k = i - 12; k < i; k++)
                            //{
                            //    DataState[k] = CurrentRunState;
                            //}
                        }
                    }

                    if(CurrentRunState == LVSPEED_STATE)
                    {
                        LevelingTime += ms;

                        UVel = LastVelocity;

                        if(UVel < 0)
                        {
                            UVel = -UVel;
                        }

                        if(UVel > LevelingVelocity)
                        {
                            LevelingVelocity = UVel;
                        }

                        /* Save the state of the data in the array */
                        DataState[i] = LVSPEED_STATE;
                    }

                    if(CurrentRunState == LVSPEED_STATE && zmg > 5.0)
                    {
                        if(i == Lasti + 1)
                        {
                            TriggerCount++;
                        }
                        else
                        {
                            TriggerCount = 0;
                        }

                        Lasti = i;

                        if(TriggerCount > 2)
                        {
                            CurrentRunState = STOP_STATE;
                            Lasti = 0;
                            TriggerCount = 0;
                        }
                    }

                    /* Time out if in leveling speed for more that 15 seconds */
                    //if(CurrentRunState == LVSPEED_STATE && LevelingTime > 300)
                    //{
                    //    CurrentRunState = STOP_STATE;
                    //    Lasti = 0;
                    //    TriggerCount = 0;
                    //}

                    if(CurrentRunState == STOP_STATE)
                    {
                        if(zmg > Stopmg)
                        {
                            Stopmg = zmg;
                        }

                        UVel = LastVelocity;

                        if(UVel < 0)
                        {
                            UVel = -UVel;
                        }

                        if(UVel > LevelingVelocity)
                        {
                            LevelingVelocity = UVel;
                        }

                        /* Save the state of the data in the array */
                        DataState[i] = STOP_STATE;
                    }

                    if(CurrentRunState == STOP_STATE && zmg < 3.0 /* 4.0 */)
                    {
                        if(i == Lasti + 1)
                        {
                            TriggerCount++;
                        }
                        else
                        {
                            TriggerCount = 0;
                        }

                        Lasti = i;

                        if(TriggerCount > 2 /* 10 */)
                        {
                            CurrentRunState = FINISH_STATE;
                            Lasti = 0;
                            TriggerCount = 0;
                            StartFlag = false;
                        }
                    }

                }

                /* Calculate the jerk for each sample */
                AccelDelta = zg - LastAccel;
                LastAccel = zg;
                Jerk = AccelDelta / (ms / 1000.0);

                /* --- CDS++ Not sure about this yet (taken from safetach1+ code) --- */
                //Jerk = Jerk * 1.85;

                /* Save all the jerk calculations in the data array for graphing */
                JerkData[i] = Jerk;

                /* Save the highest jerk value from the run for graph boundary's  */
                if(Jerk > MaxZJerk)
                {
                    MaxZJerk = Jerk;
                }

                if(Jerk < MinZJerk)
                {
                    MinZJerk = Jerk;
                }

                /* Remove the Jerk sign */
                if(Jerk < 0)
                {
                    Jerk = -Jerk;
                }

                /* Get the max Jerk velocity */
                if(Jerk > HiJerk)
                {
                    HiJerk = Jerk;

                    /* Note: Currently there is no metric jerk value so just use imperial for now */
                    HiJerkMetric = Jerk;
                }

                /* Convert g to feet per minute second */
                double fpms = zg * 60 * Double.parseDouble(context.getString(R.string.fpss_constant));

                /* Convert the g to meters per minute second */
                double mpms = zg * Double.parseDouble(context.getString(R.string.mpss_constant));

                /* Calculate the velocity */
                double velocity = LastVelocity + (fpms * (ms / 1000.0));
                double velocitymetric = LastVelocityMetric + (mpms * (ms / 1000.0));

                /* Save the last velocity for the next calculation */
                LastVelocity = velocity;
                LastVelocityMetric = velocitymetric;

                /* Save the velocity calculations in the data arrays for graphing */
                VelocityDataIMP[i] = LastVelocity;
                VelocityDataMET[i] = LastVelocityMetric;

                /* Get the velocity min and max values for imperial */
                if(VelocityDataIMP[i] < MinZVelocityIMP)
                {
                    MinZVelocityIMP = VelocityDataIMP[i];
                }

                if(VelocityDataIMP[i] > MaxZVelocityIMP)
                {
                    MaxZVelocityIMP = VelocityDataIMP[i];
                }

                /* Get the velocity min and max values for metric */
                if(VelocityDataMET[i] < MinZVelocityMET)
                {
                    MinZVelocityMET = VelocityDataMET[i];
                }

                if(VelocityDataMET[i] > MaxZVelocityMET)
                {
                    MaxZVelocityMET = VelocityDataMET[i];
                }

                /* Sum up the total time */
                TotalTime += ms;
            }
        }

        /* Close the file */
        DeviceRWData.closeRideDataFile();

        HiSpeedVelocityIMP = HiVelocity;
        HiSpeedVelocityMET = HiVelocityMetric;

        double ttime = HiTime / 1000.0;
        HiSpeedTime = ttime;

        getLevelingSpeedValues();

        double llvtime = LevelingTime / 1000.0;
        LvSpeedTime = llvtime;

        StartAcceleration = Startmg * 0.001;

        HiAcceleration = Accelmg * 0.001;

        DecelAcceleration = Decelmg * 0.001;

        double runtime = RunTime / 1000.0;
        TotalRunTime = runtime;

        JerkVelocityIMP = HiJerk;
        JerkVelocityMET = HiJerkMetric;

        //normalizeVelocityError();
        normalizeVelocityError2();
        //normalizeVelocityError3();

        /* If the min and max values are 0 set a default scale */
        if(MinZVelocityIMP == 0.0)
        {
            MinZVelocityIMP = -1.0;
        }

        if(MaxZVelocityIMP == 0.0)
        {
            MaxZVelocityIMP = 1.0;
        }

        if(MinZVelocityMET == 0.0)
        {
            MinZVelocityMET = -1.0;
        }

        if(MaxZVelocityMET == 0.0)
        {
            MaxZVelocityMET = 1.0;
        }

        if(MinZJerk == 0.0)
        {
            MinZJerk = -1.0;
        }

        if(MaxZJerk == 0.0)
        {
            MaxZJerk = 1.0;
        }

    }


    /*
     * This method uses data saved in the DataBuffer array to process acceleration
     * data from back to front to get the leveling speed and the stop acceleration.
     */
    public void getLevelingSpeedValues()
    {
        final int AVG_SIZE = 5;

        double lastvelocity = 0.0;
        double lastvelocitymetric = 0.0;
        double averagespeed = 0.0;
        double averagespeedmetric = 0.0;
        double[] speedarray = new double[AVG_SIZE];
        double[] speedarraymetric = new double[AVG_SIZE];
        int count = 0;
        double zg = 0.0;
        double fpms = 0.0;
        double mpms = 0.0;
        double velocity = 0.0;
        double velocitymetric = 0.0;
        int triggercount = 0;
        int lasti = 0;
        int numsamples = 0;
        int state = 0;
        int ms = 0;

        /* Samples per second from the node */
        ms = Integer.parseInt(context.getString(R.string.samples_per_second));

        for(int i = (DataBufferSize - 1); i >= 0; i--)
        {
            zg = DataBuffer[i];

            double zmg = zg * 1000;

            if(zmg < 0)
            {
                zmg = -zmg;
            }

            /* Start the trigger process for the leveling speed */
            if(state == 0 && zmg > 3.0)
            {
                if(i == lasti - 1)
                {
                    triggercount++;
                }
                else
                {
                    triggercount = 0;
                }

                lasti = i;

                if(triggercount > 2)
                {
                    state = 1;
                }
            }


            if(state == 1)
            {
                numsamples++;

                /* Only get 3/4 of a second of data */
                if(numsamples > 44 /*36*/)
                {
                    state = 2;
                }

                /* Convert gs to feet per minute second */
                fpms = zg * 60 * Double.parseDouble(context.getString(R.string.fpss_constant));
                mpms  = zg * Double.parseDouble(context.getString(R.string.mpss_constant));

                /* Calculate the velocity */
                velocity = lastvelocity + (fpms * ((ms + 4) / 1000.0));
                velocitymetric = lastvelocitymetric + (mpms * ((ms + 4) / 1000.0));

                /* Save the last velocity for the next calculation */
                lastvelocity = velocity;
                lastvelocitymetric = velocitymetric;

                /* Add the Velocity to the averaging array */
                speedarray[count] = lastvelocity;
                speedarraymetric[count] = lastvelocitymetric;

                count++;
                if(count >= AVG_SIZE)
                {
                    count = 0;
                }

                /* Remove the sign from the acceleration data */
                if (zg < 0)
                {
                    zg = -zg;
                }

                if(zg > StopAcceleration)
                {
                    /* Save the stop acceleration */
                    StopAcceleration = zg;
                }

            }
        }

        /* Get the average velocity */
        for(int i = 0; i < AVG_SIZE; i++)
        {
            averagespeed += speedarray[i];
            averagespeedmetric += speedarraymetric[i];
        }

        LvSpeedVelocityIMP = averagespeed / AVG_SIZE;
        LvSpeedVelocityMET = averagespeedmetric / AVG_SIZE;

        /* Remove the sign from the acceleration value */
        if(LvSpeedVelocityIMP < 0)
        {
            LvSpeedVelocityIMP = -LvSpeedVelocityIMP;
        }

        if(LvSpeedVelocityMET < 0)
        {
            LvSpeedVelocityMET = -LvSpeedVelocityMET;
        }

    }


    public void normalizeVelocityError()
    {
        double zaforward = 0.0;
        double zareverse = 0.0;
        double zvforward = 0.0;
        double zvreverse = 0.0;
        double lastzvforward = 0.0;
        double lastzvreverse = 0.0;
        double fpmsforward = 0.0;
        double fpmsreverse = 0.0;
        int ms = 0;
        double zvdatareverse = 0.0;

        /* Samples per second from the node */
        ms = Integer.parseInt(context.getString(R.string.samples_per_second));

        for(int i = 0, j = (DataBuffer.length - 1); i < (DataBuffer.length / 2); i++, j--)
        {
            zaforward = DataBuffer[i];
            zareverse = DataBuffer[j];

            /* Convert gs to feet per minute second */
            fpmsforward = zaforward * 60 * Double.parseDouble(context.getString(R.string.fpss_constant));
            fpmsreverse = zareverse * 60 * Double.parseDouble(context.getString(R.string.fpss_constant));

            /* Calculate the velocity */
            zvforward = lastzvforward + (fpmsforward * (ms / 1000.0));
            zvreverse = lastzvreverse + (fpmsreverse * (ms / 1000.0));

            /* Save the last velocity for the next calculation */
            lastzvforward = zvforward;
            lastzvreverse = zvreverse;

            VelocityDataIMP[i] = lastzvforward;
            VelocityDataIMP[j] = -lastzvreverse;

            if(false)
            {
                if(RunDirectionUp)
                {
                    if(-lastzvreverse < HiSpeedVelocityIMP)
                    {
                        VelocityDataIMP[j] = -lastzvreverse;

                    }
                }
                else
                {
                    if(-lastzvreverse > -HiSpeedVelocityIMP)
                    {
                        VelocityDataIMP[j] = -lastzvreverse;

                    }
                }
            }
        }
    }

    public void normalizeVelocityError2()
    {
        double zverror = 0.0;
        FilterAveraging FAImp = new FilterAveraging(9);
        FilterAveraging FAMet = new FilterAveraging(9);

        if(VelocityDataIMP != null)
        {
            zverror = VelocityDataIMP[VelocityDataIMP.length - 1];

            for(int i = 0; i < VelocityDataIMP.length; i++)
            {
                if(RunDirectionUp == true)
                {
                    if(VelocityDataIMP[i] <= zverror || VelocityDataIMP[i] < 0)
                    {
                        VelocityDataIMP[i] = 0;
                        VelocityDataMET[i] = 0;
                    }

                    if(RideType == RIDE_TYPE_HYDRO)
                    {
                        if(i + 31 < VelocityDataIMP.length)
                        {
                            if(DataState[i] == LVSPEED_STATE ||
                                    DataState[i + 1] == LVSPEED_STATE ||
                                    DataState[i + 2] == LVSPEED_STATE ||
                                    DataState[i + 3] == LVSPEED_STATE ||
                                    DataState[i + 4] == LVSPEED_STATE ||
                                    DataState[i + 5] == LVSPEED_STATE ||
                                    DataState[i + 6] == LVSPEED_STATE ||
                                    DataState[i + 7] == LVSPEED_STATE ||
                                    DataState[i + 8] == LVSPEED_STATE ||
                                    DataState[i + 9] == LVSPEED_STATE ||
                                    DataState[i + 10] == LVSPEED_STATE ||
                                    DataState[i + 11] == LVSPEED_STATE ||
                                    DataState[i + 12] == LVSPEED_STATE ||
                                    DataState[i + 13] == LVSPEED_STATE ||
                                    DataState[i + 14] == LVSPEED_STATE ||
                                    DataState[i + 15] == LVSPEED_STATE ||
                                    DataState[i + 16] == LVSPEED_STATE ||
                                    DataState[i + 17] == LVSPEED_STATE ||
                                    DataState[i + 18] == LVSPEED_STATE ||
                                    DataState[i + 19] == LVSPEED_STATE ||
                                    DataState[i + 20] == LVSPEED_STATE ||
                                    DataState[i + 21] == LVSPEED_STATE ||
                                    DataState[i + 22] == LVSPEED_STATE ||
                                    DataState[i + 23] == LVSPEED_STATE ||
                                    DataState[i + 24] == LVSPEED_STATE ||
                                    DataState[i + 25] == LVSPEED_STATE ||
                                    DataState[i + 26] == LVSPEED_STATE ||
                                    DataState[i + 27] == LVSPEED_STATE ||
                                    DataState[i + 28] == LVSPEED_STATE ||
                                    DataState[i + 29] == LVSPEED_STATE ||
                                    DataState[i + 30] == LVSPEED_STATE)
                            {
                                VelocityDataIMP[i] = LvSpeedVelocityIMP;
                                VelocityDataMET[i] = LvSpeedVelocityMET;
                            }
                        }
                    }
                }
                else
                {
                    if(VelocityDataIMP[i] >= zverror || VelocityDataIMP[i] > 0)
                    {
                        VelocityDataIMP[i] = 0;
                        VelocityDataMET[i] = 0;
                    }

                    if(RideType == RIDE_TYPE_HYDRO)
                    {
                        if(i + 31 < VelocityDataIMP.length)
                        {
                            if(DataState[i] == LVSPEED_STATE ||
                                    DataState[i + 1] == LVSPEED_STATE ||
                                    DataState[i + 2] == LVSPEED_STATE ||
                                    DataState[i + 3] == LVSPEED_STATE ||
                                    DataState[i + 4] == LVSPEED_STATE ||
                                    DataState[i + 5] == LVSPEED_STATE ||
                                    DataState[i + 6] == LVSPEED_STATE ||
                                    DataState[i + 7] == LVSPEED_STATE ||
                                    DataState[i + 8] == LVSPEED_STATE ||
                                    DataState[i + 9] == LVSPEED_STATE ||
                                    DataState[i + 10] == LVSPEED_STATE ||
                                    DataState[i + 11] == LVSPEED_STATE ||
                                    DataState[i + 12] == LVSPEED_STATE ||
                                    DataState[i + 13] == LVSPEED_STATE ||
                                    DataState[i + 14] == LVSPEED_STATE ||
                                    DataState[i + 15] == LVSPEED_STATE ||
                                    DataState[i + 16] == LVSPEED_STATE ||
                                    DataState[i + 17] == LVSPEED_STATE ||
                                    DataState[i + 18] == LVSPEED_STATE ||
                                    DataState[i + 19] == LVSPEED_STATE ||
                                    DataState[i + 20] == LVSPEED_STATE ||
                                    DataState[i + 21] == LVSPEED_STATE ||
                                    DataState[i + 22] == LVSPEED_STATE ||
                                    DataState[i + 23] == LVSPEED_STATE ||
                                    DataState[i + 24] == LVSPEED_STATE ||
                                    DataState[i + 25] == LVSPEED_STATE ||
                                    DataState[i + 26] == LVSPEED_STATE ||
                                    DataState[i + 27] == LVSPEED_STATE ||
                                    DataState[i + 28] == LVSPEED_STATE ||
                                    DataState[i + 29] == LVSPEED_STATE ||
                                    DataState[i + 30] == LVSPEED_STATE)
                            {
                                VelocityDataIMP[i] = -LvSpeedVelocityIMP;
                                VelocityDataMET[i] = -LvSpeedVelocityMET;
                            }
                        }
                    }
                }

                /* Run the value through the low pass averaging filter to smooth out the plot series */
                VelocityDataIMP[i] = FAImp.Filter(VelocityDataIMP[i]);
                VelocityDataMET[i] = FAMet.Filter(VelocityDataMET[i]);

                /* Get the velocity min and max values for imperial */
                if(VelocityDataIMP[i] < MinZVelocityIMP)
                {
                    MinZVelocityIMP = VelocityDataIMP[i];
                }

                if(VelocityDataIMP[i] > MaxZVelocityIMP)
                {
                    MaxZVelocityIMP = VelocityDataIMP[i];
                }

                /* Get the velocity min and max values for metric */
                if(VelocityDataMET[i] < MinZVelocityMET)
                {
                    MinZVelocityMET = VelocityDataMET[i];
                }

                if(VelocityDataMET[i] > MaxZVelocityMET)
                {
                    MaxZVelocityMET = VelocityDataMET[i];
                }
            }
        }
    }

    public void normalizeVelocityError3()
    {
        double zverror = 0.0;
        FilterAveraging FAImp = new FilterAveraging(9);
        FilterAveraging FAMet = new FilterAveraging(9);

        if(VelocityDataIMP != null)
        {
            zverror = VelocityDataIMP[VelocityDataIMP.length - 1];

            for(int i = 0; i < VelocityDataIMP.length; i++)
            {
                if(RunDirectionUp == true)
                {
                    if(VelocityDataIMP[i] <= zverror || VelocityDataIMP[i] < 0)
                    {
                        VelocityDataIMP[i] = 0;
                        VelocityDataMET[i] = 0;
                    }

                    if(RideType == RIDE_TYPE_HYDRO)
                    {
                        if(DataState[i] == LVSPEED_STATE)
                        {
                            VelocityDataIMP[i] = LvSpeedVelocityIMP;
                            VelocityDataMET[i] = LvSpeedVelocityMET;
                        }
                    }
                }
                else
                {
                    if(VelocityDataIMP[i] >= zverror || VelocityDataIMP[i] > 0)
                    {
                        VelocityDataIMP[i] = 0;
                        VelocityDataMET[i] = 0;
                    }

                    if(RideType == RIDE_TYPE_HYDRO)
                    {
                        if(DataState[i] == LVSPEED_STATE)
                        {
                            VelocityDataIMP[i] = -LvSpeedVelocityIMP;
                            VelocityDataMET[i] = -LvSpeedVelocityMET;
                        }
                    }
                }

                /* Run the value through the low pass averaging filter to smooth out the plot series */
                VelocityDataIMP[i] = FAImp.Filter(VelocityDataIMP[i]);
                VelocityDataMET[i] = FAMet.Filter(VelocityDataMET[i]);

                /* Get the velocity min and max values for imperial */
                if(VelocityDataIMP[i] < MinZVelocityIMP)
                {
                    MinZVelocityIMP = VelocityDataIMP[i];
                }

                if(VelocityDataIMP[i] > MaxZVelocityIMP)
                {
                    MaxZVelocityIMP = VelocityDataIMP[i];
                }

                /* Get the velocity min and max values for metric */
                if(VelocityDataMET[i] < MinZVelocityMET)
                {
                    MinZVelocityMET = VelocityDataMET[i];
                }

                if(VelocityDataMET[i] > MaxZVelocityMET)
                {
                    MaxZVelocityMET = VelocityDataMET[i];
                }
            }
        }
    }


    public double Round(double value, int places)
    {
        Double val = value;
        BigDecimal bd = new BigDecimal(val.toString());
        bd = bd.setScale(places, RoundingMode.HALF_UP);
        return bd.doubleValue();
    }


@end
