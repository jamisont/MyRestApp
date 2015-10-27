//
//  User.h
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@interface User : NSObject

@property (readonly, strong, nonatomic) NSString *username;
@property (strong, nonatomic) Device *device;
@property (readonly, strong, nonatomic) NSString *deviceSummary;

+ (NSArray<User *> *)usersFromData:(NSData *)data;

@end
