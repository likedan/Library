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

@synthesize bookTable;
@synthesize navigationBar;
@synthesize loadingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    navigationBar.layer.shadowRadius = 1;
    navigationBar.layer.shadowOpacity = 0.3;
    
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
    return self->bookList.count;
}

// request the booklist from the server
- (void)requestBookList {
    
    [self.view bringSubviewToFront: self.loadingView];
    [self.view bringSubviewToFront: self.navigationBar];
    // loading view disappear
    loadingView.alpha = 1;

    
    InternetConnection *connection = [[InternetConnection alloc] init:@"books" parameters:nil];
    connection.delegate = self;
    [connection sendGetRequest];
}

- (void)gotResultFromServer:(NSString *)suffix result:(id)result {
    
    // loading view disappear
    [self.view sendSubviewToBack: self.loadingView];
    
    if ([suffix isEqual: @"books"]) {
        
        bookList = [NSMutableArray arrayWithArray:(NSArray *)result];
        
        //save booklist as a dictionary
        bookDict = [[NSMutableDictionary alloc] init];
        for (int index = 0; index < bookList.count; index++) {
            [bookDict setObject:bookList[index] forKey:[bookList[index] objectForKey:@"title"]];
        }
        // Store the data
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:bookDict] forKey:@"books"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:bookList] forKey:@"booklist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [bookTable reloadData];
    }
    
}

- (void)errorFromServer:(NSString *)suffix error:(NSError *)error {
    
    [self.view sendSubviewToBack: self.loadingView];

    if ([suffix isEqual: @"books"]) {
        //retrieve local data
        
        bookDict = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"books"]] mutableCopy];
        bookList = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"booklist"]] mutableCopy];
        [bookTable reloadData];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
