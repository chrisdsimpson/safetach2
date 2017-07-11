

#import <Foundation/Foundation.h>

@interface DevieInformationModel : NSObject

/*!
 *  @method startDiscoverChar:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */

-(void)startDiscoverChar:(void (^) (BOOL success, NSError *error))handler;

/*!
 *  @method discoverCharacteristicValues:
 *
 *  @discussion Read values for the various characteristics in the service
 */

-(void) discoverCharacteristicValues:(void(^)(BOOL success, NSError *error))handler;

/*!
 *  @property deviceInfoCharValueDictionary
 *
 *  @discussion Dictionary contains the basic informations of service characteristic
 *
 */
@property(nonatomic,retain) NSMutableDictionary *deviceInfoCharValueDictionary;

@end
