//
//  EXSendNotificationParams.h
//  Exponent
//
//  Created by smszymon on 21.09.2018.
//  Copyright © 2018 650 Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXSendNotificationParams : NSObject
@property (atomic, strong) NSString *expId;
@property (atomic, strong) NSDictionary * dic;
@property (atomic, strong) NSNumber * isRemote;
@property (atomic, strong) NSNumber * isFromBackground;
@property (atomic, strong) NSString *actionId;
@property (atomic, strong) NSString *userText;
- (id)initWithExpId:(NSString *)expId
   notificationBody: (NSDictionary *)dic
           isRemote: (NSNumber *) isRemote
   isFromBackground: (NSNumber *)isFromBackground
           actionId: (NSString *)actionId
           userText: (NSString *)userText;
@end
