
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
    
    if ([self.destinationViewController isMemberOfClass: [BookDetailsViewController class]] && [self.sourceViewController isMemberOfClass: [ViewController class]]) {
        //from main view to book detail view
        [self performBookToDetails];
    }else if ([self.sourceViewController isMemberOfClass: [BookDetailsViewController class]] && [self.destinationViewController isMemberOfClass: [ViewController class]]){
        //unwind from book detail view to main view
        [self performDetailToMain];
    }
    
}

- (void) performBookToDetails {
    ((BookDetailsViewController*)self.destinationViewController).returnButton.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        ((ViewController*)self.sourceViewController).plus.alpha = 0;
    } completion:^(BOOL finished) {
        // Access the app's key window and insert the destination view above the current (source) one.
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window insertSubview:[self.destinationViewController view] aboveSubview:[self.sourceViewController view]];
        [self.sourceViewController presentViewController:self.destinationViewController animated:false completion:^{
            [UIView animateWithDuration:0.5 animations:^{
                ((BookDetailsViewController*)self.destinationViewController).returnButton.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }];
    }];

}

- (void) performDetailToMain {
    [UIView animateWithDuration:0.3 animations:^{
        ((BookDetailsViewController*)self.sourceViewController).backView.alpha = 0;
        ((BookDetailsViewController*)self.sourceViewController).returnButton.alpha = 0;
        ((BookDetailsViewController*)self.sourceViewController).view.backgroundColor = [UIColor whiteColor];

    } completion:^(BOOL finished) {
        // Access the app's key window and insert the destination view above the current (source) one.
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window insertSubview:[self.destinationViewController view] aboveSubview:[self.sourceViewController view]];
        [self.sourceViewController dismissViewControllerAnimated:false completion:^{
            [UIView animateWithDuration:0.5 animations:^{
                ((ViewController*)self.destinationViewController).plus.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}


@end
