//
//  Device.h
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (readonly, strong, nonatomic) NSString *deviceType;
@property (readonly, strong, nonatomic) NSString *iosVersion;
@property (readonly, strong, nonatomic) NSString *language;
@property (readonly, strong, nonatomic) NSString *appVersion;

+ (Device *)currentDeviceInfo;

- (instancetype)initWithJSON:(NSDictionary *)dict;

- (instancetype)initWithType:(NSString *)deviceType withIosVersion:(NSString *)iosVersion withLanguage:(NSString *)language withAppVersion:(NSString *)appVersion;

@end
