
//
//  AddBookViewController.m
//  Library
//
//  Created by Kedan Li on 15/3/20.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "AddBookViewController.h"

@interface AddBookViewController ()

@end

@implementation AddBookViewController{
    UITextField *currentResponder;
}

@synthesize bookName;
@synthesize author;
@synthesize publisher;
@synthesize categories;
@synthesize add;
@synthesize back;

- (void)viewDidLoad {
    [super viewDidLoad];
    // add edge recognizer
    UIScreenEdgePanGestureRecognizer *screenLeftEdgeReco = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(ScreenLeftEdgeSwiped:)];
    screenLeftEdgeReco.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer: screenLeftEdgeReco];
    
    // add tap reco for keyboard return
    UITapGestureRecognizer *returnKeyB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyboard)];
    [back addGestureRecognizer:returnKeyB];
}

- (IBAction)addClicked :(id)sender {
    
    Boolean hasError = false;
    
    if ([author.text isEqualToString:@""]) {
        [self addWarningAnimation:author :@"Field Empty!"];
        hasError = true;
    }
    
    if ([bookName.text isEqualToString:@""]) {
        [self addWarningAnimation:bookName :@"Field Empty!"];
        hasError = true;
    } else if ([[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"books"]] mutableCopy] objectForKey: bookName.text] != nil) {
        
        //dupiclated name
        [self addWarningAnimation:bookName :@"invalid name"];
        hasError = true;
    }
    
    if ([publisher.text isEqualToString:@""]) {
        [self addWarningAnimation:publisher :@"Field Empty!"];
        hasError = true;
    }
    
    if ([categories.text isEqualToString:@""]) {
        [self addWarningAnimation:categories :@"Field Empty!"];
        hasError = true;
    }
    
    if (!hasError) {
        
        //add new book to local
        NSMutableDictionary *localLibrary = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"books"]] mutableCopy];
        
        NSDictionary *bookInfo = [NSDictionary dictionaryWithObjectsAndKeys:bookName.text, @"title", author.text, @"author", categories.text, @"categories", publisher.text, @"publisher",nil];
        [localLibrary setObject:bookInfo forKey:bookName.text];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:localLibrary] forKey:@"books"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        InternetConnection *connection = [[InternetConnection alloc] init:@"/books/" parameters:bookInfo];
        connection.delegate = self;
        [connection sendPostRequest];
    }
    
}

// display warning
- (void) addWarningAnimation :(UIView*)view :(NSString*)message {
    
    UILabel * warning = [[UILabel alloc] initWithFrame:view.bounds];
    warning.textColor = [UIColor darkGrayColor];
    warning.backgroundColor = [UIColor whiteColor];
    warning.font = [UIFont fontWithName:@"Courier-Oblique" size:25];
    warning.text = message;
    warning.textAlignment = NSTextAlignmentCenter;
    warning.alpha = 0;
    [view addSubview:warning];
    
    [UIView animateWithDuration:0.5 animations:^{
        warning.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            warning.alpha = 0;
        } completion:^(BOOL finished) {
            [warning removeFromSuperview];
        }];
    }];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentResponder = textField;
    // push the view up if necessary
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardDidShowNotification object:nil];

}

- (void)keyboardWillChange:(NSNotification *)notification {
    
    //get keyboard height
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGPoint origin = [back convertPoint:currentResponder.frame.origin toView:self.view];
    
    if (origin.y + currentResponder.frame.size.height + keyboardFrameBeginRect.size.height > self.view.frame.size.height) {
        //animate the board up
        [UIView animateWithDuration:0.4 animations:^{
            [back setTransform:CGAffineTransformMakeTranslation(0, self.view.frame.size.height - (origin.y + currentResponder.frame.size.height + keyboardFrameBeginRect.size.height))];
        }];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        [back setTransform:CGAffineTransformMakeTranslation(0, 0)];
    }];
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // return the text field if pressed return
    if (textField == bookName) {
        [textField resignFirstResponder];
        [author becomeFirstResponder];
    }else if (textField == author) {
        [textField resignFirstResponder];
        [publisher becomeFirstResponder];
    }else if (textField == publisher) {
        [textField resignFirstResponder];
        [categories becomeFirstResponder];
    }else if (textField == categories) {
        [textField resignFirstResponder];
    }
    return true;
}

- (void)gotResultFromServer:(NSString *)suffix result:(id)result {
    [self performSegueWithIdentifier:@"returnToMainFromAddBook" sender:self];
}

- (void)errorFromServer:(NSString *)suffix error:(NSError *)error {
    //error handling
}

- (void) ScreenLeftEdgeSwiped :(UIScreenEdgePanGestureRecognizer*)recognizer {
    [self performSegueWithIdentifier:@"returnToMainFromAddBook" sender:self];
}

- (void)returnKeyboard {
    [bookName resignFirstResponder];
    [author resignFirstResponder];
    [categories resignFirstResponder];
    [publisher resignFirstResponder];
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
