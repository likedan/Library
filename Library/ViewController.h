//
//  ViewController.h
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetConnection.h"
#import "BookshelfViewCell.h"
#import "UIViewFunctions.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InternetConnectionDelegate, BookCellDelegate>{
    
    NSMutableArray *bookList;
    NSMutableDictionary *bookDict;
}

@property(nonatomic, strong) IBOutlet UITableView *bookTable;
@property(nonatomic, strong) IBOutlet UIVisualEffectView *loadingView;
@property(nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, strong) IBOutlet UIButton *plus;

@end

