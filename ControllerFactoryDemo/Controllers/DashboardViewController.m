//
//  DashboardViewController.m
//  ControllerFactoryDemo
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController()

@property (nonatomic, strong) NSString *useCase;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = [self.titleLabel.text stringByAppendingFormat:@"\n%@", self.useCase];
}

+ (NSArray<NSString *> *)getUseCases {
    return @[@"Case 1", @"Case 2"];
}

- (void)prepareForControllerFactoryWithUseCase:(NSString *)useCase {
    NSLog(@"Use case: %@", useCase);
    self.useCase = useCase;
}

@end
