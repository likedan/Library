//
//  InternetConnection.m
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "InternetConnection.h"

#define SERVER "http://prolific-interview.herokuapp.com/5509cf58dfe21d000931b8f5/"


@implementation InternetConnection

@synthesize delegate;

- (instancetype)init :(NSString*)suffix parameters:(NSDictionary*)parameters
{
    self = [super init];
    if (self) {
        self.suffix = suffix;
        self.parameters = parameters;
    }
    return self;
}

- (void) sendGetRequest {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: [NSString stringWithFormat:@"%s%@", SERVER, self.suffix] parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[self delegate] gotResultFromServer:self.suffix result:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
}

- (void) sendPostRequest {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%s%@", SERVER, self.suffix] parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [[self delegate] gotResultFromServer:self.suffix result:responseObject];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
@end
