//
//  BookDetailsViewController.m
//  Library
//
//  Created by Kedan Li on 15/3/19.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "BookDetailsViewController.h"

@interface BookDetailsViewController ()

@end

@implementation BookDetailsViewController


@synthesize publisher;
@synthesize tags;
@synthesize checkoutInfo;
@synthesize bookName;
@synthesize author;
@synthesize checkout;
@synthesize backView;
@synthesize bookInfo;
@synthesize returnButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",bookName.text);
    self.backView.layer.shadowOffset = CGSizeMake(0, 2);
    self.backView.layer.shadowRadius = 1;
    self.backView.layer.shadowOpacity = 0.3;
    
    publisher.text = [NSString stringWithFormat:@"Publisher: %@",[bookInfo objectForKey: @"publisher"]];
    bookName.text = [bookInfo objectForKey: @"title"];
    author.text = [NSString stringWithFormat:@"by %@",[bookInfo objectForKey: @"author"]];
    tags.text = [NSString stringWithFormat:@"Tags: %@",[bookInfo objectForKey: @"categories"]];
    checkoutInfo.text = [NSString stringWithFormat:@"%@ %@",[bookInfo objectForKey: @"lastCheckedOutBy"], [bookInfo objectForKey: @"lastCheckedOut"]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
