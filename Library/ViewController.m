//
//  ViewController.m
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "ViewController.h"
#import "BookshelfViewCell.h"
#import "BookDetailsViewController.h"
#import "CustomSegue.h"
@interface ViewController ()

@end

@implementation ViewController{
    NSString* chosenBook;
}

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
    
    chosenBook = title;
    UIView *bookBack;
    // the first book
    if ([title isEqualToString: cell.book1Name.text]) {
        bookBack = cell.book1back;
    }else{
        bookBack = cell.book2back;
    }
    
    // find the corresponding position
    CGPoint origin = [cell.contentView convertPoint:bookBack.frame.origin toView:self.bookTable];
    
    NSLog(@"%f",bookTable.contentOffset.y);
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, bookBack.frame.size.width, bookBack.frame.size.height)];
    back.backgroundColor = bookBack.backgroundColor;
    [self.bookTable addSubview:back];
    back.layer.shadowOffset = CGSizeMake(0, 3);
    back.layer.shadowRadius = 2;
    back.layer.shadowOpacity = 0.5;
    
    //render the vew as image
    UIImage *coverimg = [UIViewFunctions getImageFromView:bookBack];
    UIImageView *cover = [[UIImageView alloc] initWithImage:coverimg];
    [cover setFrame: back.bounds];
    [back addSubview:cover];
    
    [self openBookAnimation:cover bookBack:back];

}

- (void) openBookAnimation :(UIView*)bookCover bookBack:(UIView*)bookBack {
    [UIView animateWithDuration:0.5 animations:^{
        
        //open the book cover animation
        [bookCover setFrame:CGRectMake(0, 0, bookTable.frame.size.width, bookTable.frame.size.height)];
        [bookBack setFrame:CGRectMake(0, bookTable.contentOffset.y, bookTable.frame.size.width, bookTable.frame.size.height)];
        [bookCover setTransform: CGAffineTransformMake(0.1, 0.1, 0, 1, -bookCover.frame.size.width / 2, 0)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            bookCover.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bookCover removeFromSuperview];
            
            [UIView animateWithDuration:0.1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                bookBack.alpha = 0;
            } completion:^(BOOL finished) {
                [bookBack removeFromSuperview];
            }];
            [self performSegueWithIdentifier:@"bookToDetails" sender:self];
        }];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"bookToDetails"]) {
        
        BookDetailsViewController *controller = segue.destinationViewController;
        controller.bookInfo = [bookDict objectForKey: chosenBook];
    }

}

- (IBAction)dismissToMain:(UIStoryboardSegue *)segue {
    
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier{
    if([identifier isEqualToString: @"detailToMain"]){
        UIStoryboardSegue *unwindSegue = [[CustomSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        return unwindSegue;
    }
    return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
