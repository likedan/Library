//
//  ViewController.m
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "ViewController.h"
#import "BookshelfViewCell.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    self.navigationBar.layer.shadowRadius = 1;
    self.navigationBar.layer.shadowOpacity = 0.3;
    
    bookList = [[NSMutableArray alloc] init];
    
    self.bookTable.estimatedRowHeight = self.view.bounds.size.width / 1.4 ;

    [self requestBookList];
    // Do any additional setup after loading the view, typically from a nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookshelfViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"shelfCell"];
    
    if(cell == nil) {
        cell = [[BookshelfViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shelfCell"];
    }
    //[cell.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
   // NSMutableDictionary *message = self->bookList[indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;// self->bookList.count;
}

// request the booklist from the server
- (void)requestBookList {
    
    [self.view bringSubviewToFront: self.loadingView];
    [self.view bringSubviewToFront: self.navigationBar];
    // loading view disappear
    [UIView animateWithDuration:0.3 animations:^{
        self.loadingView.alpha = 1;
    }];
    
    InternetConnection *connection = [[InternetConnection alloc] init:@"books" parameters:nil];
    connection.delegate = self;
    [connection sendGetRequest];
}

- (void)gotResultFromServer:(NSString *)suffix result:(id)result {
    
    // loading view disappear
    [UIView animateWithDuration:0.3 animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack: self.loadingView];
    }];
    
    
    if ([suffix isEqual: @"books"]) {
        NSLog(@"%@",result);
    }
    
}

- (void)errorFromServer:(NSString *)suffix error:(NSError *)error {
    // error handling
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
