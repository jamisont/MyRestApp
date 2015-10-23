//
//  UserDetailViewController.h
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserDetailViewController : UIViewController

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UILabel *labelUsername;

@property (weak, nonatomic) IBOutlet UILabel *labelDeviceType;
@property (weak, nonatomic) IBOutlet UILabel *labeliosVersion;
@property (weak, nonatomic) IBOutlet UILabel *labelLanguage;
@property (weak, nonatomic) IBOutlet UILabel *labelAppVersion;

@end
