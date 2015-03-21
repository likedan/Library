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


@property(nonatomic, strong) IBOutlet UILabel *book1Name;
@property(nonatomic, strong) IBOutlet UILabel *book1Author;
@property(nonatomic, strong) IBOutlet UIView *book1back;
@property(nonatomic, strong) IBOutlet UIView *book1cover;

@property(nonatomic, strong) IBOutlet UILabel *book2Name;
@property(nonatomic, strong) IBOutlet UILabel *book2Author;
@property(nonatomic, strong) IBOutlet UIView *book2back;
@property(nonatomic, strong) IBOutlet UIView *book2cover;


- (void) setupCell:(NSDictionary *)view book2:(NSDictionary *)book2 ;
- (void) setToDeleteMode :(UIView*)bookBack ;
- (void) quitFromDeleteMode :(UIView*)bookBack ;

@end
