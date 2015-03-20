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
@synthesize plus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    navigationBar.layer.shadowRadius = 1;
    navigationBar.layer.shadowOpacity = 0.3;
    
    bookList = [[NSMutableArray alloc] init];
    
    self.bookTable.estimatedRowHeight = self.view.bounds.size.width / 1.4;

    [self requestBookList];
    // Do any additional setup after loading the view, typically from a nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookshelfViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"shelfCell"];
    
    if(cell == nil) {
        cell = [[BookshelfViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shelfCell"];
    }
    NSMutableDictionary *message1 = self->bookList[indexPath.row * 2];
    NSMutableDictionary *message2 = nil;
    if (bookList.count >= indexPath.row * 2 + 1) {
        message2 = self->bookList[indexPath.row * 2 + 1];
    }

    [cell setupCell:message1 book2:message2];
    cell.delegate = self;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self->bookList.count + 1) / 2;
}

// request the booklist from the server
- (void)requestBookList {
    
    [self.view bringSubviewToFront: loadingView];
    [self.view bringSubviewToFront: navigationBar];
    [self.view bringSubviewToFront: plus];

    InternetConnection *connection = [[InternetConnection alloc] init:@"books" parameters:nil];
    connection.delegate = self;
    [connection sendGetRequest];
}

- (void)gotResultFromServer:(NSString *)suffix result:(id)result {
    
    // loading view disappear
    [self.view sendSubviewToBack: self.loadingView];
    
    NSLog(@"%@",result);
    
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

- (void)bookClicked:(NSString *)title cell:(BookshelfViewCell *)cell{
    
    CGPoint origin;
    // the first book
    if ([title isEqualToString: cell.book1Name.text]) {
        origin = [cell.contentView convertPoint:cell.book1back.frame.origin toView:self.bookTable]; //[self.bookTable convertPoint:cell.book1back.frame.origin fromView:cell.book1back];
        NSLog(@"%f",origin.x);
        [cell.book1back removeFromSuperview];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, cell.book1back.frame.size.width, cell.book1back.frame.size.height)];
        back.backgroundColor = cell.book1back.backgroundColor;
        [self.bookTable addSubview:back];
        back.layer.shadowOffset = CGSizeMake(0, 3);
        back.layer.shadowRadius = 2;
        back.layer.shadowOpacity = 0.5;
        
        
        UIImage *coverimg = [UIViewFunctions getImageFromView:cell.book1back];
        UIImageView *cover = [[UIImageView alloc] initWithImage:coverimg];
        [cover setFrame: back.bounds];
        [back addSubview:cover];
        
        [self openBookAnimation:cover bookBack:back];
        
    }else{
        origin = [self.view convertPoint:cell.book2back.frame.origin fromView:cell.book2back];
        [cell.book2back removeFromSuperview];
        UIView *tempBook = [[UIView alloc] initWithFrame: CGRectMake(origin.x, origin.y, cell.book2back.frame.size.width, cell.book2back.frame.size.height)];
        tempBook.backgroundColor = cell.book2back.backgroundColor;
        [tempBook addSubview: cell.book2cover];
        [self.bookTable addSubview:tempBook];
    }

}

- (void) openBookAnimation :(UIView*)bookCover bookBack:(UIView*)bookBack {
    [UIView animateWithDuration:0.5 animations:^{
        
        [bookCover setFrame:CGRectMake(0, 0, bookTable.frame.size.width, bookTable.frame.size.height)];
        [bookBack setFrame:CGRectMake(0, 0, bookTable.frame.size.width, bookTable.frame.size.height)];
        [bookCover setTransform: CGAffineTransformMake(0.1, 0.1, 0, 1, -bookCover.frame.size.width / 2, 0)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            bookCover.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bookCover removeFromSuperview];
            [self performSegueWithIdentifier:@"bookToDetails" sender:self];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
