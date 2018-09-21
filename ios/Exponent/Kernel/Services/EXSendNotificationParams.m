//
//  EXSendNotificationParams.m
//  Exponent
//
//  Created by smszymon on 21.09.2018.
//  Copyright © 2018 650 Industries. All rights reserved.
//

#import "EXSendNotificationParams.h"

@implementation EXSendNotificationParams
- (id)initWithExpId:(NSString *)expId notificationBody: (NSDictionary *)dic isRemote: (NSNumber *) isRemote isFromBackground: (NSNumber *)isFromBackground {
  if (self = [super init]) {
    _isRemote = isRemote;
    _isFromBackground = isFromBackground;
    _expId = expId;
    _dic = dic;
    return self;
  }
  return nil;
}
@end
