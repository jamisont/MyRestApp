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

/*
 * This method takes a username and password and attempts
 * to register a new user in the remote server.
 * If successful, execute completion block specified in the method call (with auth token).
 * If unsuccessful, execute failure block specified in the method call.
 */
- (void)registerNewUsername:(NSString *)username
               withPassword:(NSString *)password
                 completion:(void (^)(NSString *))completion
                    failure:(void (^)(void))failure
{
    // create an empty dictionary to store info we're sending to
    NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc] init];
    // add the "username" key-value pair
    [userDataDictionary setObject:username forKey:@"username"];
    // add the "password" key-value pair
    [userDataDictionary setObject:password forKey:@"password"];
    // declare a pointer to an NSError object
    NSError *error;
    // convert the dictionary to NSData using JSON style
    NSData *dataToPass = [NSJSONSerialization dataWithJSONObject:userDataDictionary
                                                         options:0
                                                           error:&error];
    
    // if there was an error in converting to NSData, execute failure block and end method execution
    if (error)
    {
        failure();
        return;
    }
    
    // create an NSURL object using the address specified in API documentation
    NSURL *url = [NSURL URLWithString:@"http://104.236.231.254:5000/user"];
    
    // create a request object to load up with data to send to server
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // set the HTTPMethod as specified in API documentation
    request.HTTPMethod = @"POST";
    
    // set the HTTPBody as specified in the API documentation
    request.HTTPBody = dataToPass;
    
    // set the header as specified in the API documentation
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // prepare to interact with a server
    NSURLSession *urlSession = [NSURLSession sharedSession];
    // creates HTTP request that conforms to server specifications
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error is %@", error);
        if (!error) // connected to server
        {
            if (((NSHTTPURLResponse *)response).statusCode == 200) // everything works OK!
            {
                // convert data from server to auth token (as described in API documentation)
                NSString *authToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // execute completion block in method call with authToken parameter
                [self setAuthToken:authToken];
                completion(authToken);
            }
            else // got a weird status code from server
            {
                // execute failure block in method call
                failure();
            }
        }
        else // had a connection problem
        {
            // execute failure block in method call
            failure();
        }
    }];
    
    // sends HTTP request to server
    [dataTask resume];
}

#pragma mark CHALLENGE #2 - with a partner
- (void)authenticateUser:(NSString *)username withPassword:(NSString *)password completion:(void (^)(NSString *))completion failure:(void (^)(void))failure {
    
    // create an NSURL object using the address specified in API documentation
    NSString *urlString = [NSString stringWithFormat:@"http://104.236.231.254:5000/auth?username=%@&password=%@", username, password];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // create a request object to load up with data to send to server
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // set the HTTPMethod as specified in API documentation
    request.HTTPMethod = @"POST";
    
    // set the header as specified in the API documentation
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // prepare to interact with a server
    NSURLSession *urlSession = [NSURLSession sharedSession];
    // creates HTTP request that conforms to server specifications
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error is %@", error);
        if (!error) // connected to server
        {
            if (((NSHTTPURLResponse *)response).statusCode == 200) // everything works OK!
            {
                // convert data from server to auth token (as described in API documentation)
                NSString *authToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // execute completion block in method call with authToken parameter
                completion(authToken);
                [self setAuthToken:authToken];
            }
            else // got a weird status code from server
            {
                // execute failure block in method call
                failure();
            }
        }
        else // had a connection problem
        {
            // execute failure block in method call
            failure();
        }
    }];
    
    // sends HTTP request to server
    [dataTask resume];
}

#pragma mark CHALLENGE #3 - with a partner or on your own
- (void)fetchAllUserDataWithCompletion:(void (^)(NSArray<User *> *))completion failure:(void (^)(void))failure {
    
}

#pragma mark CHALLENGE #4 - with a partner or on your own
-(void)saveDevice:(Device *)device forUser:(User *)user completion:(void (^)(void))completion failure:(void (^)(void))failure {
    
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
