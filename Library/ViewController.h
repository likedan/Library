//
//  ViewController.h
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetConnection.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InternetConnectionDelegate>{
    
    NSMutableArray *bookList;
    NSMutableDictionary *bookDict;
}

@property(strong) IBOutlet UITableView *bookTable;
@property(strong) IBOutlet UIVisualEffectView *loadingView;
@property(strong) IBOutlet UINavigationBar *navigationBar;

@end

