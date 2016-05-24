//
//  DataManager.h
//  PageViewController
//
//  Created by steve on 2016-05-20.
//  Copyright © 2016 steve. All rights reserved.
//

@import UIKit;
@class StoryPartViewController;

@interface DataManager : NSObject<UIPageViewControllerDataSource>
@property (nonatomic) UIStoryboard *storyboard;
- (StoryPartViewController *)createViewControllerAtIndex:(NSInteger)index;

@end
