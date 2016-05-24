//
//  Photo.m
//  AV Storybook
//
//  Created by Anthony Coelho on 2016-05-21.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithImage:(UIImage *)image {
    if (![super init]) {return  nil;}
    _image = image;
    return self;
}

// I need to override init and call the designated initializer
// Here I'm crashing if someone calls init, because there's no point in creating a Photo object without an image.
- (instancetype)init {
    NSAssert(NO, @"Call the designated initializer");
    return [self initWithImage:nil];
}


@end
