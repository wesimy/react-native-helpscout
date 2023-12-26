
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNHelpscoutSpec.h"

@interface Helpscout : NSObject <NativeHelpscoutSpec>
#else
#import <React/RCTBridgeModule.h>

@interface Helpscout : NSObject <RCTBridgeModule>
#endif

@end
