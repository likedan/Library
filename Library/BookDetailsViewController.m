//
//  BookDetailsViewController.m
//  Library
//
//  Created by Kedan Li on 15/3/19.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "BookDetailsViewController.h"

@interface BookDetailsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonRightConstrain;

@end

@implementation BookDetailsViewController{
    UITextField *nameInput;
}

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
    
    //set text of the label
    publisher.text = [NSString stringWithFormat:@"Publisher: %@",[bookInfo objectForKey: @"publisher"]];
    bookName.text = [bookInfo objectForKey: @"title"];
    author.text = [NSString stringWithFormat:@"by %@",[bookInfo objectForKey: @"author"]];
    tags.text = [NSString stringWithFormat:@"Tags: %@",[bookInfo objectForKey: @"categories"]];
    checkoutInfo.text = [NSString stringWithFormat:@"%@ %@",[bookInfo objectForKey: @"lastCheckedOutBy"], [bookInfo objectForKey: @"lastCheckedOut"]];

    // add edge recognizer
    UIScreenEdgePanGestureRecognizer *screenLeftEdgeReco = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(ScreenLeftEdgeSwiped:)];
    screenLeftEdgeReco.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer: screenLeftEdgeReco];
    
    // add tap reco for keyboard return
    UITapGestureRecognizer *returnKeyB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyboard)];
    [backView addGestureRecognizer:returnKeyB];

}

- (void) ScreenLeftEdgeSwiped :(UIScreenEdgePanGestureRecognizer*)recognizer {
    [self performSegueWithIdentifier:@"detailToMain" sender:self];
}

// send checkout buttons
- (void) sendCheckout {
    
    // empty response
    if ([nameInput.text isEqualToString:@""]) {
        
        // display warning
        UILabel * warning = [[UILabel alloc] initWithFrame:nameInput.bounds];
        warning.textColor = [UIColor whiteColor];
        warning.backgroundColor = [nameInput backgroundColor];
        warning.font = [UIFont fontWithName:@"Courier-Oblique" size:25];
        warning.text = @"Name Empty!";
        warning.textAlignment = NSTextAlignmentCenter;
        warning.alpha = 0;
        [nameInput addSubview:warning];
        
        [UIView animateWithDuration:0.5 animations:^{
            warning.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                warning.alpha = 0;
            } completion:^(BOOL finished) {
                [warning removeFromSuperview];
            }];
        }];
    }else{
        //send result
        InternetConnection *connection = [[InternetConnection alloc] init:[bookInfo objectForKey:@"url"] parameters:[NSDictionary dictionaryWithObject:nameInput.text forKey:@"lastCheckedOutBy"]];
        connection.delegate = self;
        if ([connection connected]) {
            [connection sendPutRequest];
        }else{
            NSLog(@"no internet");
        }
    }
}

- (void)gotResultFromServer:(NSString *)suffix result:(id)result {
    
    // update the local library
    NSMutableDictionary *bookDict = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"books"]] mutableCopy];
    [bookDict setObject:result forKey:[(NSDictionary*)result objectForKey:@"title"]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:bookDict] forKey:@"books"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"detailToMain" sender:self];
    
}

- (void)errorFromServer:(NSString *)suffix error:(NSError *)error {
    // error handling
}


//transfer the checkout button into name input
- (IBAction)checkoutClicked:(id)sender {
    
    UIButton* button = (UIButton*)sender;
    
    // set up the name input button
    nameInput = [[UITextField alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width - button.frame.size.height - 5, button.frame.size.height)];
    nameInput.backgroundColor = [button backgroundColor];
    nameInput.font = [UIFont fontWithName:@"Courier-Oblique" size:25];
    nameInput.textAlignment = NSTextAlignmentCenter;
    nameInput.textColor = [UIColor whiteColor];
    nameInput.placeholder = @"Name";
    nameInput.alpha = 0;
    nameInput.delegate = self;
    [backView addSubview:nameInput];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width - button.frame.size.height, button.frame.origin.y, button.frame.size.height, button.frame.size.height)];
    sendButton.backgroundColor = [button backgroundColor];
    sendButton.alpha = 0;
    [sendButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendCheckout) forControlEvents: UIControlEventTouchUpInside];
    [backView addSubview:sendButton];
    // animate  button change
    [UIView animateWithDuration:0.5 animations:^{
        [button setTransform: CGAffineTransformMake(1 - (button.frame.size.height / button.frame.size.width), 0, 0, 1, -button.frame.size.height / 2, 0)];
    } completion:^(BOOL finished) {
        nameInput.alpha = 1;
        [(UIButton*)sender removeFromSuperview];
        [UIView animateWithDuration:0.4 animations:^{
            sendButton.alpha = 1;
        }];
    }];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardDidShowNotification object:nil];
    return true;
}

- (void)keyboardWillChange:(NSNotification *)notification {
    
    //get keyboard height
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    //animate the board up
    [UIView animateWithDuration:0.4 animations:^{
        [self.backView setTransform:CGAffineTransformMakeTranslation(0, -keyboardFrameBeginRect.size.height)];
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // return the text field if pressed return
    [textField resignFirstResponder];
    return true;
}

- (void)returnKeyboard {
    if (nameInput != nil) {
        [nameInput resignFirstResponder];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        [self.backView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    }];
    return true;
}

- (IBAction)shareDialogue:(UIBarButtonItem *)sender
{
    
    NSArray *objectsToShare = @[bookName.text, author.text];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    [self presentViewController:activityVC animated:YES completion:nil];
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
