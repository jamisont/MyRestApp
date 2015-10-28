//
//  ApiManager.m
//  ApiTest
//
//  Created by ios on 10/23/15.
//  Copyright © 2015 Brandon. All rights reserved.
//

#import "ApiManager.h"

NSString *SERVER_API_BASE_URL = @"http://localhost:5000";

@interface ApiManager ()

@property (readonly, strong, nonatomic) NSString *serverBase;
@property (strong, nonatomic) NSString *authToken;

@end

@implementation ApiManager

+(instancetype)getInstance {
    // the 'static' keyword causes this line to only be executed once, ever.
    static ApiManager *instance = nil;
    
    // what is this doing?
    if (!instance) {
        NSLog(@"initializing ApiManager");
        instance = [[ApiManager alloc] initWithServerBase:SERVER_API_BASE_URL];
    }
    
    return instance;
}

- (instancetype)initWithServerBase:(NSString *)serverBase {
    self = [self init];

    _serverBase = serverBase;
    
    return self;
}

/**
 * This is a convenience method that takes a url fragment like '/path/to/something'
 * and it makes an absolute url like 'http://myapi.com/path/to/something'
 * you can also add substitution values like this:
 * [self url:@"/my/path?auth%@", self.authToken], which produces 'http://myapi.com/my/path?auth=ABC123'
 */
- (NSString *)url:(NSString *)pathFormat, ... NS_FORMAT_FUNCTION(1, 2) {

    va_list args;
    va_start(args, pathFormat);
    pathFormat = [[NSString alloc] initWithFormat:pathFormat arguments:args];
    va_end(args);
    
    return [NSString stringWithFormat:@"%@%@", self.serverBase, pathFormat];
}

-(void)registerNewUsername:(NSString *)username withPassword:(NSString *)password completion:(void (^)(NSString *))completion failure:(void (^)(void))failure {
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[self url:@"/user"]];
    
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];
    r.HTTPMethod = @"POST";
    [r addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    r.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{
        @"username": username,
        @"password": password
    } options:0 error:nil];
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:r completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSString *authToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            self.authToken = authToken;
            if (completion) {
                completion(authToken);
            }
        } else {
            if (failure) {
                failure();
            }
        }
    }];
    [task resume];
}

- (void)authenticateUser:(NSString *)username withPassword:(NSString *)password completion:(void (^)(NSString *))completion failure:(void (^)(void))failure {
    
    // TODO: remove this code so that it's empty for students -- will project
    // this snippet in class and we can go through it together
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[self url:@"/auth?username=%@&password=%@", username, password]];
    
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
            if (failure) {
                failure();
            }
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
            if (failure) {
                failure();
            }
        }
    }];
    [task resume];
}

-(void)saveDevice:(Device *)device forUser:(User *)user completion:(void (^)(void))completion failure:(void (^)(void))failure {
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[self url:@"/device?auth=%@", self.authToken]];
    
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];
    r.HTTPMethod = @"POST";
    [r addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    r.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{
        @"device_type": device.deviceType,
        @"ios_version": device.iosVersion,
        @"language": device.language,
        @"app_version": device.appVersion
    } options:0 error:nil];
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:r completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            user.device = device;
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        } else {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }
    }];
    [task resume];
}

-(BOOL)isAuthenticated {
    return self.authToken;
}

/**
 * BONUS CHALLENGES...
 *
 * Below here you'll find methods that will flesh out this API Manager
 * even more. Pick and choose which you're interested in and ask for help...
 * Heads up! These have actually not been implemented as any prep for this
 * exercise, so you're probably the first one doing these!
 */

-(void)logout {
    NSLog(@"Hi! Does anybody want to implement ApiManager.logout ;)");
    
    // what should this method do?
    
    // How do we DELETE an auth token from the API?
    
    // What if ApiManager simply 'forgets' its auth token?
    
    // What do you think this method should really do?
}

@end
