
//
//  CustomSegue.m
//  Library
//
//  Created by Kedan Li on 15/3/19.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "CustomSegue.h"
#import "BookDetailsViewController.h"
#import "ViewController.h"

@implementation CustomSegue

-(void)perform{
    
    
    // Assign the source and destination views to local variables.
    UIView *firstView = [self.sourceViewController view];
    UIView *secondView = [self.destinationViewController view];
    
    //from main view to detail view
    if ([self.destinationViewController isMemberOfClass: [BookDetailsViewController class]] && [self.sourceViewController isMemberOfClass: [ViewController class]]) {
        ((BookDetailsViewController*)self.destinationViewController).returnButton.alpha = 0;
        
        [UIView animateWithDuration:0.1 animations:^{
            ((ViewController*)self.sourceViewController).plus.alpha = 0;
        } completion:^(BOOL finished) {
            // Access the app's key window and insert the destination view above the current (source) one.
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window insertSubview:secondView aboveSubview:firstView];
            [self.sourceViewController presentViewController:self.destinationViewController animated:false completion:^{
                [UIView animateWithDuration:0.5 animations:^{
                    ((BookDetailsViewController*)self.destinationViewController).returnButton.alpha = 1;
                } completion:^(BOOL finished) {
                }];
            }];
        }];
    }
    
}

@end
