#import "Helpscout.h"

#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <Beacon/HSBeacon.h>
#import <Beacon/HSBeaconSettings.h>
#import <Beacon/HSBeaconUser.h>

@implementation Helpscout
RCT_EXPORT_MODULE()


+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


NSString *helpscoutBeaconID;
HSBeaconUser *beaconUser;

RCT_EXPORT_METHOD(init:(NSString *)beaconID)
{
    if (beaconID == nil) {
        NSLog(@"[init] missing parameter: beaconID");
        return;
    }

    helpscoutBeaconID = beaconID;
}

RCT_EXPORT_METHOD(identify:(NSDictionary *)identity)
{
    HSBeaconUser *user = [[HSBeaconUser alloc] init];

    if ([identity objectForKey:@"email"] != NULL) {
        user.email = [RCTConvert NSString:identity[@"email"]];
    }

    if ([identity objectForKey:@"name"] != NULL) {
        user.name = [RCTConvert NSString:identity[@"name"]];
    }
    
    for (NSString *key in identity) {
        if ([key isEqual:@"email"] || [key isEqual:@"name"]) continue;
        id value = identity[key];
        [user addAttributeWithKey:key value:[RCTConvert NSString:value]];
    }
    
    beaconUser = user;
    [HSBeacon identify:user];
}

RCT_EXPORT_METHOD(addAttributeWithKey:(NSString *)key valueParameter:(NSString *)value)
{
    if (helpscoutBeaconID == nil || beaconUser == nil || key == nil || value == nil) {
        if (helpscoutBeaconID == nil) {
            NSLog(@"[addAttributeWithKey] Not initialized - did you forget to call 'init'?");
        }
        if (beaconUser == nil) {
            NSLog(@"[addAttributeWithKey] Not initialized - did you forget to call 'identify' or 'login'?");
        }
        if (key == nil) {
            NSLog(@"[addAttributeWithKey] missing parameter: key");
        }
        if (value == nil) {
            NSLog(@"[addAttributeWithKey] missing parameter: value");
        }
        return;
    }

    [beaconUser addAttributeWithKey:key value:value];
}

RCT_EXPORT_METHOD(open:(NSString *)signatureKey)
{
    if (helpscoutBeaconID == nil || beaconUser == nil) {
        if (helpscoutBeaconID == nil) {
            NSLog(@"[open] Not initialized - did you forget to call 'init'?");
        }
        if (beaconUser == nil) {
            NSLog(@"[open] Not initialized - did you forget to call 'identify' or 'login'?");
        }
        return;
    }

    HSBeaconSettings *settings = [[HSBeaconSettings alloc] initWithBeaconId:helpscoutBeaconID];
    if (signatureKey == nil) {
        [HSBeacon openBeacon:settings];
    } else {
        [HSBeacon openBeacon:settings signature:signatureKey];
    }
}


@end
