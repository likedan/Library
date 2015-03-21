//
//  InternetConnection.h
//  Library
//
//  Created by Kedan Li on 15/3/18.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@protocol InternetConnectionDelegate <NSObject>

@required

- (void) gotResultFromServer: (NSString*)suffix result:(id)result;

- (void) errorFromServer: (NSString*)suffix error:(NSError*)error;


@end

@interface InternetConnection : NSObject{

id <InternetConnectionDelegate> delegate;
    
}

@property id delegate;

@property(strong) NSString *suffix;
@property(strong) NSDictionary *parameters;

- (instancetype)init :(NSString*)suffix parameters:(NSDictionary*)parameters;
- (void) sendGetRequest;
- (void) sendPostRequest;
- (void) sendPutRequest;
- (void) sendDeleteRequest;

@end
