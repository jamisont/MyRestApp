//
//  Device.m
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import "Device.h"

@implementation Device

-(instancetype)initWithJSON:(NSDictionary *)dict {
    self = [self init];
    
    _deviceType = [dict objectForKey:@"device_type"];
    _iosVersion = [dict objectForKey:@"ios_version"];
    _language = [dict objectForKey:@"language"];
    _appVersion = [dict objectForKey:@"app_version"];
    
    return self;
}

@end
