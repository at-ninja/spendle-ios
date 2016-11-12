//
//  BackgroundWorker.h
//  VHacks.iOS
//
//  Created by Jacob Zarobsky on 11/12/16.
//  Copyright © 2016 University of Alabama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BackgroundWorker : NSObject<CLLocationManagerDelegate>

@property(nonatomic) BOOL authed;
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) NSArray *aroundMeSpots;

+(id)sharedManager;
-(BOOL)isAuthed;
-(void)startUpdates;

-(void)registerUserWithPhone:(NSString *)phone FirstName:(NSString *)first LastName:(NSString *)last AndZip:(NSString *)zip;

@end
