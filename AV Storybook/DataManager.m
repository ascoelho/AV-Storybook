//
//  DataManager.m
//  PageViewController
//
//  Created by steve on 2016-05-20.
//  Copyright © 2016 steve. All rights reserved.
//

#import "DataManager.h"
#import "StoryPartViewController.h"
#import "Photo.h"

@interface DataManager() <StoryPartViewControllerDelegate>

@property (nonatomic) NSMutableArray<Photo*>*data;
@end

@implementation DataManager


- (instancetype)init {
    
    if (![super init]) {return nil;}
    
    [self createModel];
    
    return self;
}

#pragma mark - Model

- (void)createModel {
    
    
    NSMutableArray *result = [NSMutableArray new];
    for (NSInteger i = 0; i < 5; ++i) {
        
        Photo *photo = [[Photo alloc]initWithImage:nil];
        [result addObject:photo];
    }
    _data = result;
}

#pragma mark - StoryPartViewController Data Source

// this is a public method because the pageViewController calls it to create the first VC
- (StoryPartViewController *)createViewControllerAtIndex:(NSInteger)index {
    StoryPartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPartViewController"];
    
    vc.delegate = self;
    vc.photo = self.data[index];
    vc.index = index;
    


    return vc;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = ((StoryPartViewController *)viewController).index;
    if (index >= self.data.count -1) {
        return nil;
    }
    index += 1;
    StoryPartViewController *vc = [self createViewControllerAtIndex:index];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = ((StoryPartViewController *)viewController).index;
    if (index <= 0) {
        return nil;
    }
    index -= 1;
    StoryPartViewController *vc = [self createViewControllerAtIndex:index];
    return vc;
}

#pragma mark - Creates PageController (little dots)

// total number of dots
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.data.count;
}

// currently selected VC
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return ((StoryPartViewController *)pageViewController.viewControllers[0]).index;
}

#pragma mark - StoryPartViewControllerDelegate methods

-(void)setImage:(UIImage *)image atIndex:(NSInteger)index {
    
    NSMutableArray *mutableData = [self.data mutableCopy];
    
    Photo *photo = (Photo *)mutableData[index];
    photo.image= image;
    
    
    self.data = mutableData;
    
    
}

- (void)setSoundURL:(NSURL *)url atIndex:(NSInteger)index {
    
    NSMutableArray *mutableData = [self.data mutableCopy];
    
    Photo *photo = (Photo *)mutableData[index];
    photo.soundFileURL = url;
    
    
    self.data = mutableData;
    
    
    
}




@end
