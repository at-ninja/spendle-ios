//
//  NavigationControllerViewController.m
//  VHacks.iOS
//
//  Created by Jacob Zarobsky on 11/12/16.
//  Copyright © 2016 University of Alabama. All rights reserved.
//

#import "NavigationControllerViewController.h"

@interface NavigationControllerViewController ()

@end

@implementation NavigationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBackgroundColor:[UIColor redColor]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    // Bar tint color rgb: (77,133,114)
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:77.0/255 green:133.0/255 blue:114.0/255 alpha:1.0]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
