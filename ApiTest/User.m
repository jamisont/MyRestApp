//
//  User.m
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import "User.h"

@implementation User

+(NSArray<User *> *)usersFromData:(NSData *)data {
    NSMutableArray *result = [NSMutableArray array];
    
    NSDictionary *rawUsers = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *rawUsersArray = [rawUsers objectForKey:@"users"];
    
    for (NSDictionary *rawUser in rawUsersArray) {
        [result addObject:[[User alloc] initWithJSON:rawUser]];
    }
    
    return [NSArray arrayWithArray:result];
}

- (instancetype)initWithJSON:(NSDictionary *)dict {
    self = [self init];
    
    _username = [dict objectForKey:@"username"];

    id deviceJSON = [dict objectForKey:@"device"];
    _device = deviceJSON != [NSNull null]? [[Device alloc] initWithJSON:deviceJSON] : nil;
    
    return self;
}

-(NSString *)deviceSummary {
    if (!self.device) {
        return @"None";
    } else {
        return self.device.deviceType;
    }
}

@end
