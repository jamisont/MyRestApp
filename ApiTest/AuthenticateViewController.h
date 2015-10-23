//
//  Challenge1ViewController.h
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthToken;
@property (weak, nonatomic) IBOutlet UILabel *labelError;

@end
