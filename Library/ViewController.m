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
    
    bookList = [[NSMutableArray alloc] init];
    
    
    self.bookTable.estimatedRowHeight = self.view.bounds.size.width / 1.4 ;
    self.bookTable.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view, typically from a nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookshelfViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"shelfCell"];
    NSMutableDictionary *message = self->bookList[indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->bookList.count;
}

- (void)getBookList {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
