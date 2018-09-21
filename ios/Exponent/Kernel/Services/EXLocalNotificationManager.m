// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXLocalNotificationManager.h"
#import "EXKernel.h"

@interface EXLocalNotificationManager()
@property (atomic) UNUserNotificationCenter *center;
@property NSDictionary *Categories;
@end

@implementation EXLocalNotificationManager
static NSString * delimeter = @"7624679807";

+ (instancetype)sharedInstance
{
  static EXLocalNotificationManager *theManager;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    if (!theManager) {
      theManager = [EXLocalNotificationManager new];
    }
  });
  return theManager;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
  NSLog(@"malpa did received notification");
  NSDictionary *payload = response.notification.request.content.userInfo;
  
  if (payload) {
    NSDictionary *body = [payload objectForKey:@"body"];
    NSString *experienceId = [payload objectForKey:@"experienceId"];
    if (body && experienceId) {
      [[EXKernel sharedInstance] sendNotification:body
                               toExperienceWithId:experienceId
                                   fromBackground:NO
                                         isRemote:NO];
    }
  }
  completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
  NSLog(@"notification will present");
  completionHandler(UNAuthorizationOptionAlert + UNAuthorizationOptionSound);
}


- (void)autorizeAndInit: (NSDictionary *) launchOptions
{
  _center = [UNUserNotificationCenter currentNotificationCenter];
  _center.delegate = self;
  
  UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
  [_center requestAuthorizationWithOptions:options
    completionHandler:^(BOOL granted, NSError * _Nullable error) {
      if (!granted) {
        NSLog(@"Something went wrong");
      }
    }
  ];
}

-(bool) isPermissionGranted // todo
{
  [_center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
      // Notifications not allowed
    }
  }];
  return YES;
}

@end
