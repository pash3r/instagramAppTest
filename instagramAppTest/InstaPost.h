//
//  InstaPost.h
//  instagramAppTest
//
//  Created by Roman Klimov on 29.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstaPost : NSObject{
    
    NSString *author;
    NSString *profilePicture;
    NSString *photoName;
    NSString *miniImage;
    NSString *maxiImage;
    NSString *locationName;
    NSDictionary *likes;
    NSDictionary *comments;
}

@property (retain, nonatomic) NSString *author;
@property (retain, nonatomic) NSString *profilePicture;
@property (retain, nonatomic) NSString *photoName;
@property (retain, nonatomic) NSString *miniImage;
@property (retain, nonatomic) NSString *maxiImage;
@property (retain, nonatomic) NSString *locationName;
@property (retain, nonatomic) NSDictionary *likes;
@property (retain, nonatomic) NSDictionary *comments;

@end
