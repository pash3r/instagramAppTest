//
//  InstaPost.m
//  instagramAppTest
//
//  Created by Roman Klimov on 29.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import "InstaPost.h"

@implementation InstaPost
@synthesize author, profilePicture, photoName, miniImage, maxiImage, locationName, likes, comments, mediaID;

-(void)dealloc{
    
    [author release];
    [profilePicture release];
    [photoName release];
    [miniImage release];
    [maxiImage release];
    [locationName release];
    [likes release];
    [comments release];
    [mediaID release];
    [super dealloc];
}

@end
