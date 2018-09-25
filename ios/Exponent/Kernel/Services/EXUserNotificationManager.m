// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXUserNotificationManager.h"
#import "EXKernel.h"
#import "EXRemoteNotificationManager.h"

@interface EXUserNotificationManager()
@property (atomic) UNUserNotificationCenter *center;
@property NSDictionary *Categories;
@end

@implementation EXUserNotificationManager
+ (instancetype)sharedInstance
{
  static EXUserNotificationManager *theManager;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    if (!theManager) {
      theManager = [EXUserNotificationManager new];
    }
  });
  return theManager;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
  if (![[EXKernel sharedInstance].serviceRegistry.remoteNotificationManager supportsCurrentRuntimeEnvironment]) {
    DDLogWarn(@"Expo Remote Notification services won't work in an ExpoKit app because Expo cannot manage your APNS certificates.");
  }
  BOOL isFromBackground = !([UIApplication sharedApplication].applicationState == UIApplicationStateActive);
  NSLog(@"malpa did received notification isFromBackground:%@", (isFromBackground)?@"Yes" : @"No");
  NSDictionary *payload = response.notification.request.content.userInfo;
  if (payload) {
    NSDictionary *body = (payload[@"body"])?[payload objectForKey:@"body"]:@{};
    NSString *experienceId = [payload objectForKey:@"experienceId"];
    NSString * userText = @"";
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
      userText = ((UNTextInputNotificationResponse *) response).userText;
    }
    
    BOOL isRemote = (payload[@"metadata-remote"])? YES : NO;
    if (body && experienceId) {
      [[EXKernel sharedInstance] sendNotification:body
                               toExperienceWithId:experienceId
                                   fromBackground:isFromBackground
                                         isRemote:isRemote
                                         actionId: response.actionIdentifier
                                         userText: userText];
    }
  }
  completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
  NSLog(@"notification will present");
  NSDictionary *payload = notification.request.content.userInfo;
  if (payload) {
    NSDictionary *body = (payload[@"body"])?[payload objectForKey:@"body"]:@{};
    NSString *experienceId = [payload objectForKey:@"experienceId"];
    NSString * userText = @"";
    
    BOOL isRemote = (payload[@"metadata-remote"])? YES : NO;
    if (body && experienceId) {
      [[EXKernel sharedInstance] sendNotification:body
                               toExperienceWithId:experienceId
                                   fromBackground:NO
                                         isRemote:isRemote
                                         actionId: @"will_present"
                                         userText: userText];
    }
  }
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

@end
