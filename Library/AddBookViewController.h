//
//  AddBookViewController.h
//  Library
//
//  Created by Kedan Li on 15/3/20.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetConnection.h"

@interface AddBookViewController : UIViewController <UITextFieldDelegate, InternetConnectionDelegate>

@property(nonatomic,strong) IBOutlet UITextField *bookName;
@property(nonatomic,strong) IBOutlet UITextField *author;
@property(nonatomic,strong) IBOutlet UITextField *publisher;
@property(nonatomic,strong) IBOutlet UITextField *categories;
@property(nonatomic,strong) IBOutlet UIButton *add;
@property(nonatomic,strong) IBOutlet UIView *back;

@end
