//
//  BookshelfViewCell.m
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "BookshelfViewCell.h"


@implementation BookshelfViewCell{
    UIVisualEffectView *book1DeleteCover;
    UIVisualEffectView *book2DeleteCover;
    
    UIImageView *book1Checked;
    UIImageView *book2Checked;
}

@synthesize delegate;

// set the information for the books
- (void) setupCell:(NSDictionary *)book1 book2:(NSDictionary *)book2 {
    
    UITapGestureRecognizer *reco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(book1Clicked)];
    [self.book1cover addGestureRecognizer:reco];
    // set up the messages
    [self.book1Author setText: [NSString stringWithFormat:@"by %@", [book1 objectForKey: @"author"]]];
    [self.book1Name setText:[book1 objectForKey: @"title"]];
    
    // add shadow effect
    self.book1back.layer.shadowOffset = CGSizeMake(0, 3);
    self.book1back.layer.shadowRadius = 2;
    self.book1back.layer.shadowOpacity = 0.8;
    
    //set random color
    CGFloat rand = arc4random() % 500;
    CGFloat red = rand / 600;
    rand = arc4random() % 500;
    CGFloat green = rand / 600;
    rand = arc4random() % 500;
    CGFloat blue = rand / 600;

    self.book1cover.backgroundColor = [UIColor colorWithRed: red green:green blue:blue alpha:1];
    
    // check if there is two books in the row
    if (book2 == nil) {
        self.book2back.alpha = 0;
    }else{
        self.book2back.alpha = 1;
        reco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(book2Clicked)];
        [self.book2cover addGestureRecognizer:reco];
        
        rand = arc4random() % 500;
        red = rand / 600;
        rand = arc4random() % 500;
        green = rand / 600;
        rand = arc4random() % 500;
        blue = rand / 600;
        
        self.book2cover.backgroundColor = [UIColor colorWithRed: red green:green blue:blue alpha:1];

        [self.book2Author setText:[NSString stringWithFormat:@"by %@", [book2 objectForKey: @"author"]]];
        [self.book2Name setText:[book2 objectForKey: @"title"]];
        
        self.book2back.layer.shadowOffset = CGSizeMake(0, 3);
        self.book2back.layer.shadowRadius = 2;
        self.book2back.layer.shadowOpacity = 0.8;

    }
}

// set a book to delete mode
- (void) setToDeleteMode :(UIView*)bookBack {
        
    if (bookBack == self.book1back) {
        
        // set up the cover views
        book1DeleteCover = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        book1DeleteCover.frame = bookBack.bounds;
        book1DeleteCover.userInteractionEnabled = false;
        [bookBack addSubview:book1DeleteCover];
        
        book1Checked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        [book1Checked setFrame:CGRectMake(0, 0, 40, 40)];
        [book1Checked setCenter:book1DeleteCover.center];
        book1Checked.alpha = 0;
        [bookBack addSubview:book1Checked];
        
        [UIView animateWithDuration:0.2 animations:^{
            book1Checked.alpha = 1;
        }];
        
    }else if (bookBack == self.book2back){
        // set up the cover views
        book2DeleteCover = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        book2DeleteCover.frame = bookBack.bounds;
        book2DeleteCover.userInteractionEnabled = false;
        [bookBack addSubview:book2DeleteCover];
        
        book2Checked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        [book2Checked setFrame:CGRectMake(0, 0, 40, 40)];
        [book2Checked setCenter:book2DeleteCover.center];
        book2Checked.alpha = 0;
        [bookBack addSubview:book2Checked];
        
        [UIView animateWithDuration:0.2 animations:^{
            book2Checked.alpha = 1;
        }];

    }
}

// remove the covers for delete mode
- (void) quitFromDeleteMode :(UIView*)bookBack {
    if (bookBack == self.book1back) {
        [book1DeleteCover removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            book1Checked.alpha = 0;
        } completion:^(BOOL finished) {
            [book1Checked removeFromSuperview];
        }];
    }else if (bookBack == self.book2back) {
        [book2DeleteCover removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            book2Checked.alpha = 0;
        } completion:^(BOOL finished) {
            [book2Checked removeFromSuperview];
        }];
    }
}


- (void) book1Clicked {
    [[self delegate] bookClicked:self.book1Name.text cell:self];
}

- (void) book2Clicked {
    [[self delegate] bookClicked:self.book2Name.text cell:self];
}

@end
