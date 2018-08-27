//
//  BaseViewController.m
//  ControllerFactoryDemo
//
//  Created by Vincent Pradeilles on 18/05/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [[self class] description];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.title;
    [self.view addSubview:self.titleLabel];
    [self.view addConstraint:[self.titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]];
    [self.view addConstraint:[self.titleLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]];
}

@end
