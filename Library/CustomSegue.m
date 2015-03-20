
//
//  CustomSegue.m
//  Library
//
//  Created by Kedan Li on 15/3/19.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

-(void)perform{
    // Assign the source and destination views to local variables.
    UIView *firstView = [self.sourceViewController view];
    UIView *secondView = [self.destinationViewController view];
    
    // Get the screen width and height.
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [secondView setFrame: CGRectMake(0.0, screenHeight, screenWidth, screenHeight)];
    // Access the app's key window and insert the destination view above the current (source) one.
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window insertSubview:secondView aboveSubview:firstView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [firstView setFrame: CGRectOffset(firstView.frame, 0.0, -screenHeight)];
        [secondView setFrame: CGRectOffset(secondView.frame, 0.0, -screenHeight)];
    } completion:^(BOOL finished) {
        [self.sourceViewController presentViewController:self.destinationViewController animated:false completion:^{
            
        }];
    }];
    
}

@end
