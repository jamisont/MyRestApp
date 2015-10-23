//
//  RegisterUserViewController.m
//  ApiTest
//
//  Created by ios on 10/22/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import "RegisterUserViewController.h"

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonPressedRegister:(id)sender {
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:5000/user"];
    
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];
    r.HTTPMethod = @"POST";
    [r addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    r.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{
        @"username": self.textFieldUsername.text,
        @"password": self.textFieldPassword.text
    } options:0 error:nil];
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:r completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSString *authToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"created new user, got auth token: %@", authToken);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelAuthToken.text = authToken;
            });
        } else {
            NSLog(@"oh no! unrecoverable error :(");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelAuthToken.text = @"ERROR";
            });
        }
    }];
    [task resume];
}

@end
