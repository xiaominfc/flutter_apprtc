#import "ARDVideoCallViewController.h"
#import "AppRTCMobile/ARDSettingsModel.h"
#import "FlutterApprtcPlugin.h"
#import "ARDSettingsViewController.h"

@interface FlutterApprtcPlugin()<ARDVideoCallViewControllerDelegate>


@end

@implementation FlutterApprtcPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_apprtc"
            binaryMessenger:[registrar messenger]];
  FlutterApprtcPlugin* instance = [[FlutterApprtcPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)connectToRoom:(NSString*) room{
    ARDSettingsModel *settingsModel = [[ARDSettingsModel alloc] init];
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    session.useManualAudio = [settingsModel currentUseManualAudioConfigSettingFromStore];
    session.isAudioEnabled = NO;
    
    // Kick off the video call.
    ARDVideoCallViewController *videoCallViewController =
    [[ARDVideoCallViewController alloc] initForRoom:room
                                         isLoopback:false
                                           delegate:self];
    videoCallViewController.modalTransitionStyle =
    UIModalTransitionStyleCrossDissolve;
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController presentViewController:videoCallViewController
                           animated:YES
                         completion:nil];
    
//    [self presentViewController:videoCallViewController
//                       animated:YES
//                     completion:nil];
}

- (void)configureAudioSession {
    RTCAudioSessionConfiguration *configuration =
    [[RTCAudioSessionConfiguration alloc] init];
    configuration.category = AVAudioSessionCategoryAmbient;
    configuration.categoryOptions = AVAudioSessionCategoryOptionDuckOthers;
    configuration.mode = AVAudioSessionModeDefault;
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    [session lockForConfiguration];
    BOOL hasSucceeded = NO;
    NSError *error = nil;
    if (session.isActive) {
        hasSucceeded = [session setConfiguration:configuration error:&error];
    } else {
        hasSucceeded = [session setConfiguration:configuration
                                          active:YES
                                           error:&error];
    }
    if (!hasSucceeded) {
        RTCLogError(@"Error setting configuration: %@", error.localizedDescription);
    }
    [session unlockForConfiguration];
}

- (void)restartAudioPlayerIfNeeded {
    [self configureAudioSession];
    //  if (_mainView.isAudioLoopPlaying && !self.presentedViewController) {
    //    RTCLog(@"Starting audio loop due to WebRTC end.");
    //    [_audioPlayer play];
    //  }
}

#pragma mark - ARDVideoCallViewControllerDelegate

- (void)viewControllerDidFinish:(ARDVideoCallViewController *)viewController {
    
    if (![viewController isBeingDismissed]) {
        RTCLog(@"Dismissing VC");
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootViewController dismissViewControllerAnimated:YES completion:^{
            [self restartAudioPlayerIfNeeded];
        }];
    }
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    session.isAudioEnabled = NO;
}

- (void)configSetting{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    ARDSettingsViewController *settingsController =
    [[ARDSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped
                                       settingsModel:[[ARDSettingsModel alloc] init]];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:settingsController];
    [rootViewController presentViewController:navigationController animated:YES completion:nil];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  
  if([@"startRoom" isEqualToString:call.method]){
    NSString *room = [[call arguments] valueForKey:@"room"];
    NSLog(@"room:%@",room);
    [self connectToRoom:room];
  }else if([@"configSetting" isEqualToString:call.method]){
    [self configSetting];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}



@end
