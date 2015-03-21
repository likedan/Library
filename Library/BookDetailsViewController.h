//
//  BookDetailsViewController.h
//  Library
//
//  Created by Kedan Li on 15/3/19.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetConnection.h"

@interface BookDetailsViewController : UIViewController <UITextFieldDelegate, InternetConnectionDelegate>

@property(nonatomic,strong) IBOutlet UILabel *publisher;
@property(nonatomic,strong) IBOutlet UILabel *tags;
@property(nonatomic,strong) IBOutlet UILabel *checkoutInfo;
@property(nonatomic,strong) IBOutlet UITextView *bookName;
@property(nonatomic,strong) IBOutlet UITextView *author;
@property(nonatomic,strong) IBOutlet UIButton *checkout;
@property(nonatomic,strong) IBOutlet UIView *backView;
@property(nonatomic,strong) IBOutlet UIButton *returnButton;
@property(nonatomic, strong) IBOutlet UINavigationBar *navigationBar;

@property(nonatomic,strong) NSMutableDictionary *bookInfo;


@end
