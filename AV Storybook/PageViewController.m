//
//  PageViewController.m
//  PageViewController
//
//  Created by steve on 2016-05-20.
//  Copyright © 2016 steve. All rights reserved.
//

#import "PageViewController.h"
#import "StoryPartViewController.h"
#import "DataManager.h"

@interface PageViewController ()
// you must retain the manager!
@property (nonatomic) DataManager *dataManager;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataManager];
    [self createInitialViewController];
}

- (void)setupDataManager {
    self.dataManager = [DataManager new];
    self.dataSource = self.dataManager;
    self.dataManager.storyboard = self.storyboard;
}

- (void)createInitialViewController {
    StoryPartViewController *vc = [self.dataManager createViewControllerAtIndex:0];
    [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}


@end
