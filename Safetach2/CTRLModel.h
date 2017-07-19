

#import <Foundation/Foundation.h>

@interface CTRLModel : NSObject


/*!
 *  @property InstantaneousSpeed
 *
 *  @discussion Speed at a particular moment, Unit is in m/s with a resolution of 1/256 s.
    Converted to km/hr  ( m/s *3.6)
 *
 */
@property(nonatomic ,assign )float InstantaneousSpeed;


/*!
 *  @property InstantaneousCadence
 *
 *  @discussion  Unit is in 1/minute (or RPM) with a resolutions of 1 1/min (or 1 RPM)
 *
 */
@property(nonatomic ,assign )float InstantaneousCadence;


/*!
 *  @property InstantaneousStrideLength
 *
 *  @discussion   Unit is in meter with a resolution of 1/100 m (or centimeter).
 *
 */
@property(nonatomic ,assign )float InstantaneousStrideLength;


/*!
 *  @property TotalDistance
 *
 *  @discussion   Unit is in meter with a resolution of 1/10 m (or decimeter).
 *
 */
@property(nonatomic ,assign )float TotalDistance;


/*!
 *  @property IsWalking
 *
 *  @discussion   Walking or Running Status .
 *
 */
@property(nonatomic ,assign )BOOL  IsWalking;


/*!
 *  @method startDiscoverChar:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */
-(void)startDiscoverChar:(void (^) (BOOL success, NSError *error))handler;


/*!
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */
-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler;


/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */
-(void)stopUpdate;


/*!
 *  @method writeValueForCTRLChar: ctrlvalue:
 *
 *  @discussion Method to write CTRL value to the node.
 *
 */
-(void) writeValueForCTRLchar:(int)ctrlvalue;

@end
