

#import <Foundation/Foundation.h>

@interface RideServiceModel : NSObject

/*!
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */
-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler;


/*!
 *  @method writeValueForCTRL:
 *
 *  @discussion Method to write value for ctrl characteristic
 *
 */
-(void) writeValueForCTRL:(NSInteger)ctrlvalue;


/*!
 *  @method writeValueForCTRL:ctrlvalue:With
 *
 *  @discussion Write value to specified characteristic.
 */
-(void)writeValueForCTRL:(NSInteger)ctrlvalue With:(void (^) (BOOL success, NSError *error))handler;


/*!
 *  @method startUpdate
 *
 *  @discussion Starts notifications or indications for the value of a specified characteristic.
 */
-(void)startUpdate;


/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */
-(void)stopUpdate;


/*!
 *  @property redColor
 *
 *  @discussion // 1.0, 0.0, 0.0 RGB
 *
 */
@property (nonatomic , assign ) NSInteger redColor;


/*!
 *  @property greenColor
 *
 *  @discussion // 0.0, 1.0, 0.0 RGB
 *
 */
@property (nonatomic , assign ) NSInteger greenColor;


/*!
 *  @property blueColor
 *
 *  @discussion // 0.0, 0.0, 1.0 RGB
 *
 */
@property (nonatomic , assign ) NSInteger blueColor;


/*!
 *  @property intensity
 *
 *  @discussion // intensity of the light
 *
 */
@property (nonatomic , assign ) NSInteger intensity;


@end
