//
//  UserDetailViewController.m
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.labelUsername.text = self.user.username;
    
    if (self.user.device) {
        self.labelDeviceType.text = self.user.device.deviceType;
        self.labeliosVersion.text = self.user.device.iosVersion;
        self.labelLanguage.text = self.user.device.language;
        self.labelAppVersion.text = self.user.device.appVersion;
    }
    
}

@end
