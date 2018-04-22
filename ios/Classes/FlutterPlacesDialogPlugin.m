#import <Flutter/Flutter.h>
#import "FlutterPlacesDialogPlugin.h"
#import <flutter_places_dialog/flutter_places_dialog-Swift.h>

@implementation FlutterPlacesDialogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPlacesDialogPlugin registerWithRegistrar:registrar];
}
@end
