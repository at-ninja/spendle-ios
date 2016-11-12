//
//  BackgroundWorker.m
//  VHacks.iOS
//
//  Created by Jacob Zarobsky on 11/12/16.
//  Copyright © 2016 University of Alabama. All rights reserved.
//

#import "BackgroundWorker.h"

@implementation BackgroundWorker

static const NSString *url = @"https://stark-shelf-87339.herokuapp.com/";

+(id) sharedManager {
    static BackgroundWorker *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.locationManager.delegate = sharedManager;
    });
    
    return sharedManager;
}

-(CLLocationManager *)locationManager {
    if(_locationManager == nil) {
        _locationManager = [CLLocationManager new];
    }
    
    return _locationManager;
}

-(void)setAroundMeSpots:(NSArray *)aroundMeSpots {
    // Post a notification after update.
    _aroundMeSpots = aroundMeSpots;
}

-(BOOL)isAuthed {
    return [[self authToken] length] > 0;
}

-(NSString *)authToken {
    const NSString* propertyKey = @"VHACKS_AUTH_KEY";
    return [[NSUserDefaults standardUserDefaults] stringForKey:propertyKey];
}

-(void) setAuthToken:(NSString *)token {
    const NSString* propertyKey = @"VHACKS_AUTH_KEY";
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:propertyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getAroundMyLat:(double) lat AndLng:(double) lng withCompletionHandler:(void (^) (NSArray *)) handler {
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[self authToken], @"auth_token",
                             [NSNumber numberWithDouble:lat], @"lat",
                             [NSNumber numberWithDouble:lng], @"lng",
                             [NSNumber numberWithInt:10], "@limit", nil];
    [self postDictionary:request toEndPoint:@"aroundme" withCompletionHandler:^(NSDictionary *dictionary) {
        if(dictionary != nil && [dictionary objectForKey:@"locations"]) {
            _aroundMeSpots = [dictionary objectForKey:@"locations"];
        }
    }];
}

-(void)startUpdates {
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    
    if(location != nil) {
         [self heartBeatWithLatitude:[NSNumber numberWithDouble:location.coordinate.latitude] AndLongitude:[NSNumber numberWithDouble:location.coordinate.longitude]];
    }
}

-(void)heartBeatWithLatitude:(NSNumber *)lat AndLongitude:(NSNumber *)longitude {
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"lat", longitude, @"lng", [self authToken], @"auth_token", nil];
    
    [self postDictionary:data toEndPoint:@"location" withCompletionHandler:^(NSDictionary *dictionary) {
        NSLog(@"We did something ok?\n");
    }];
}

-(void)registerUserWithPhone:(NSString *)phone FirstName:(NSString *)first LastName:(NSString *)last AndZip:(NSString *)zip
{
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:first, @"first", last, @"last", zip, @"zip", nil];
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", info, @"account_info", nil];

    [self postDictionary:request toEndPoint:@"user" withCompletionHandler:^(NSDictionary* dictionary) {
        if(dictionary != nil && [dictionary objectForKey:@"auth_token"] != nil) {
            [self setAuthToken:[dictionary objectForKey:@"auth_token"]];
        }
    }];
}

-(void)postDictionary:(NSDictionary *)dict toEndPoint:(NSString *)endpoint withCompletionHandler:(void (^) (NSDictionary *)) handler {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *fullUrl = [NSURL URLWithString:[url stringByAppendingString:endpoint]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fullUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPMethod = @"POST";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    request.HTTPBody = postData;
    
    NSURLSessionDataTask *postTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if(statusCode == 200 || statusCode == 201) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            handler(dictionary);
        } else {
            handler(nil);
        }
    }];
    
    [postTask resume];
}

@end
