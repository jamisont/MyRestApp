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

@property (weak, nonatomic) IBOutlet UITextField *textFieldDeviceType;

@property (weak, nonatomic) IBOutlet UITextField *textFieldiosVersion;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLanguage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAppVersion;
@property (weak, nonatomic) IBOutlet UIButton *buttonPopulateDeviceInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonSaveDeviceInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusMessage;

@end
