//
//  ApiManager.m
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import "ApiManager.h"

@interface ApiManager ()

@property (strong, nonatomic) NSString *authToken;

@end

@implementation ApiManager

+(instancetype)getInstance {
    // the 'static' keyword causes this line to only be executed once, ever.
    static ApiManager *instance = nil;
    
    if (!instance) {
        NSLog(@"initializing ApiManager");
        instance = [[ApiManager alloc] init];
    }
    
    return instance;
}

-(void)authenticateUser:(NSString *)username withPassword:(NSString *)password completion:(void (^)(NSString *))completion failure:(void (^)(void))failure {
    
    // TODO: remove this code so that it's empty for students -- will project
    // this snippet in class and we can go through it together
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5000/auth?username=%@&password=%@", username, password]];
    
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];
    r.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:r completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSString *authToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            self.authToken = authToken;
            if (completion) {
                completion(authToken);
            }
            
        } else {
            failure();
        }
    }];
    [task resume];
}

-(void)fetchAllUserDataWithCompletion:(void (^)(NSArray<User *> *))completion failure:(void (^)(void))failure {
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5000/user?auth=%@", self.authToken]];
    
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];
    r.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:r completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            
            NSArray<User *> *users = [User usersFromData:data];
            if (completion) {
                completion(users);
            }
            
        } else {
            failure();
        }
    }];
    [task resume];
}

-(BOOL)isAuthenticated {
    return self.authToken;
}

@end
