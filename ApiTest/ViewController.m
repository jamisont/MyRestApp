//
//  ViewController.m
//  ApiTest
//
//  Created by ios on 10/20/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonCreateUserPressed:(id)sender {
    
    NSDictionary *json = @{
        @"username": self.textFieldUsername.text,
        @"password": self.textFieldPassword.text
    };
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5000/auth?username=%@&password=%@", self.textFieldUsername.text, self.textFieldPassword.text]];
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];
    r.HTTPMethod = @"POST";
    [r addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    r.HTTPBody = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:r completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSString *authToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"got auth token: %@", authToken);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelAuthToken.text = authToken;
            });
        } else {
            NSLog(@"i need to create a user first!");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelAuthToken.text = nil;
            });
        }
    }];
    [task resume];
}

@end
