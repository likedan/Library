//
//  BookshelfViewCell.h
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookshelfViewCell : UITableViewCell{
    
}

@property(strong) IBOutlet UITextView *book1Name;
@property(strong) IBOutlet UITextView *book1Author;
@property(strong) IBOutlet UIView *book1back;
@property(strong) IBOutlet UIView *book1cover;

@property(strong) IBOutlet UITextView *book2Name;
@property(strong) IBOutlet UITextView *book2Author;
@property(strong) IBOutlet UIView *book2back;
@property(strong) IBOutlet UIView *book2cover;


- (void) configureWithMessages:(NSDictionary *)view book2:(NSDictionary *)book2 ;

@end
