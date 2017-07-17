

#import <Foundation/Foundation.h>
#import "CBManager.h"


@protocol BatteryCharacteristicDelegate <NSObject>

-(void)updateBatteryUI;

@end

@interface BatteryServiceModel : NSObject

/*!
 *  @property batteryServiceDict
 *
 *  @discussion Dictionary to store battery level value against battery service
 *
 */

@property(nonatomic,retain)NSMutableDictionary *batteryServiceDict;

@property (strong,nonatomic) id <BatteryCharacteristicDelegate> delegate;

/*!
 *  @property batteryCharacterisic
 *
 *  @discussion characteristic that represent battery level
 *
 */

@property (strong, nonatomic) CBCharacteristic *batteryCharacterisic;

/*!
 *  @method startDiscoverCharacteristicsWithCompletionHandler:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */

-(void)startDiscoverCharacteristicsWithCompletionHandler:(void (^)(BOOL success,NSError *error))handler;

/*!
 *  @method startUpdateCharacteristic
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */

-(void)startUpdateCharacteristic;

/*!
 *  @method readBatteryLevel
 *
 *  @discussion Method to read battery level value from characteristic
 *
 */
-(void) readBatteryLevel;

/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */

-(void)stopUpdate;

/*!
 *  @method handleBatteryCharacteristicValueWithChar:
 *
 *  @discussion Method to handle the characteristic value
 *
 */
-(void) handleBatteryCharacteristicValueWithChar:(CBCharacteristic *) characteristic;


@end
