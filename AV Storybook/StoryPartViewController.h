//
//  StoryPartViewController.h
//  AV Storybook
//
//  Created by Anthony Coelho on 2016-05-21.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@protocol StoryPartViewControllerDelegate <NSObject>

- (void)setImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)setSoundURL:(NSURL *)url atIndex:(NSInteger)index;

@end

@interface StoryPartViewController : UIViewController

@property (nonatomic, weak) id <StoryPartViewControllerDelegate> delegate;

@property (strong, nonatomic) Photo *photo;
@property (nonatomic) NSInteger index;



@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
