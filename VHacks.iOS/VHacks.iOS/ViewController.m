//
//  ViewController.m
//  VHacks.iOS
//
//  Created by Jacob Zarobsky on 11/12/16.
//  Copyright © 2016 University of Alabama. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PhoneNumberTextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;

@property (strong, nonatomic) BackgroundWorker *worker;

@end

@implementation ViewController

-(BackgroundWorker *)worker {
    if(_worker == nil) {
        _worker = [BackgroundWorker sharedManager];
    }
    
    return _worker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [self.worker.locationManager requestAlwaysAuthorization];
    }
    
    if([self.worker isAuthed]) {
        [self.worker startUpdates];
    } else {
        
    }
}
- (IBAction)registerAccount:(id)sender {
    [self.worker registerUserWithPhone:self.phoneNumberField.text FirstName:self.firstNameField.text LastName:self.lastNameField.text AndZip:self.zipCodeField.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
