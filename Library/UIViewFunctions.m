//
//  UIVIewExtension.m
//  Library
//
//  Created by Kedan Li on 15/3/19.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "UIViewFunctions.h"

@implementation UIViewFunctions

+ (UIImage*) getImageFromView :(UIView*)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}


@end
