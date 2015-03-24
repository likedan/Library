//
//  InternetConnection.m
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import "InternetConnection.h"

#define SERVER "http://prolific-interview.herokuapp.com/5509cf58dfe21d000931b8f5"


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

- (BOOL)connected {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return false;
    } else {
        return true;
    }
    
}

- (void) sendGetRequest {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: [NSString stringWithFormat:@"%s%@", SERVER, self.suffix] parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[self delegate] gotResultFromServer:self.suffix result:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[self delegate] errorFromServer:self.suffix error:error];
    }];
}


- (void) sendPostRequest {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%s%@", SERVER, self.suffix] parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [[self delegate] gotResultFromServer:self.suffix result:responseObject];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[self delegate] errorFromServer:self.suffix error:error];
        
    }];
    
}

- (void) sendPutRequest {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[NSString stringWithFormat:@"%s%@", SERVER, self.suffix] parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[self delegate] gotResultFromServer:self.suffix result:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[self delegate] errorFromServer:self.suffix error:error];
        
    }];
    
}

- (void) sendDeleteRequest {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:[NSString stringWithFormat:@"%s%@", SERVER, self.suffix] parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[self delegate] gotResultFromServer:self.suffix result:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[self delegate] errorFromServer:self.suffix error:error];
        
    }];
    
}

@end
