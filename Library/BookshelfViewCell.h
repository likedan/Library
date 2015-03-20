//
//  BookshelfViewCell.h
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookCellDelegate <NSObject>

@required
- (void) bookClicked: (NSString*)title cell:(UITableViewCell*)cell;

@end

@interface BookshelfViewCell : UITableViewCell{
    
    id <BookCellDelegate> delegate;
    
}

@property id delegate;


@property(strong) IBOutlet UILabel *book1Name;
@property(strong) IBOutlet UILabel *book1Author;
@property(strong) IBOutlet UIView *book1back;
@property(strong) IBOutlet UIView *book1cover;

@property(strong) IBOutlet UILabel *book2Name;
@property(strong) IBOutlet UILabel *book2Author;
@property(strong) IBOutlet UIView *book2back;
@property(strong) IBOutlet UIView *book2cover;


- (void) setupCell:(NSDictionary *)view book2:(NSDictionary *)book2 ;

@end
