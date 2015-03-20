//
//  BookshelfViewCell.m
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "BookshelfViewCell.h"


@implementation BookshelfViewCell

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

- (void) book1Clicked {
    [[self delegate] bookClicked:self.book1Name.text cell:self];
}

- (void) book2Clicked {
    [[self delegate] bookClicked:self.book2Name.text cell:self];
}

@end
