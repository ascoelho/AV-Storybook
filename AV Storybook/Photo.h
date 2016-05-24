//
//  Photo.h
//  AV Storybook
//
//  Created by Anthony Coelho on 2016-05-21.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

- (instancetype)initWithImage:(UIImage *)image NS_DESIGNATED_INITIALIZER;

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) NSURL *soundFileURL;

@end
