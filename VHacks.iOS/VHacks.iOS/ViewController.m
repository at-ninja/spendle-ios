//
//  ViewController.m
//  VHacks.iOS
//
//  Created by Jacob Zarobsky on 11/12/16.
//  Copyright © 2016 University of Alabama. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) BackgroundWorker *worker;
@property (strong, nonatomic) PhoneNumberTextField *phoneNumber;
@property (strong, nonatomic) UITextField *firstName;
@property (strong, nonatomic) UITextField *lastName;
@property (strong, nonatomic) UITextField *zipCode;

@end

@implementation ViewController

-(BackgroundWorker *)worker {
    if(_worker == nil) {
        _worker = [BackgroundWorker sharedManager];
    }
    
    return _worker;
}

-(PhoneNumberTextField *)phoneNumber {
    if(_phoneNumber == nil) {
        _phoneNumber = [[PhoneNumberTextField alloc] init];
        _phoneNumber.translatesAutoresizingMaskIntoConstraints  = NO;
        _phoneNumber.font = [UIFont fontWithName:@"Avenir" size:24.0];
        _phoneNumber.placeholder = @"phone number";
    }
    
    return _phoneNumber;
}

-(UITextField *)firstName {
    if(_firstName == nil) {
        _firstName = [[UITextField alloc] init];
        _firstName.translatesAutoresizingMaskIntoConstraints  = NO;
        _firstName.font = [UIFont fontWithName:@"Avenir" size:24.0];

        _firstName.placeholder = @"first name";
    }
    
    return _firstName;
}

-(UITextField *)lastName {
    if(_lastName == nil) {
        _lastName = [[UITextField alloc] init];
        _lastName.translatesAutoresizingMaskIntoConstraints  = NO;
        _lastName.font = [UIFont fontWithName:@"Avenir" size:24.0];

        _lastName.placeholder = @"last name";
    }
    
    return _lastName;
}

-(UITextField *)zipCode {
    if(_zipCode == nil) {
        _zipCode = [[UITextField alloc] init];
        _zipCode.placeholder = @"zip code";
        _zipCode.font = [UIFont fontWithName:@"Avenir" size:24.0];

        _zipCode.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _zipCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [self.worker.locationManager requestAlwaysAuthorization];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    
    self.title = @"Spendle";
    
    if([self.worker isAuthed]) {
        [self.worker startUpdates];
    } else {
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [super tableView:tableView viewForHeaderInSection:section];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Enter your information to get started.";
    
    CGRect frame = view.frame;
    label.frame = CGRectMake(frame.origin.x + 10, frame.origin.y + 5, frame.size.width - 20, frame.size.height - 10);
    [view addSubview:label];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    const NSString *reuseIdentifier = @"textfieldCells";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    switch(indexPath.row) {
        case 0:
            [ViewController placeView:self.phoneNumber inCell:cell];
            break;
        case 1:
            [ViewController placeView:self.firstName inCell:cell];
            break;
        case 2:
            [ViewController placeView:self.lastName inCell:cell];
            break;
        case 3:
            [ViewController placeView:self.zipCode inCell:cell];
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

-(BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

+(void)placeView:(UIView *)view inCell:(UITableViewCell *)cell {
    CGRect frame = cell.contentView.frame;
    view.frame = CGRectMake(frame.origin.x + 10, frame.origin.y + 5, frame.size.width - 20, frame.size.height - 10);
    [cell.contentView addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
