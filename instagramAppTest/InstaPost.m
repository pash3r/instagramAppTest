//
//  InstaPost.m
//  instagramAppTest
//
//  Created by Roman Klimov on 29.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import "InstaPost.h"

@implementation InstaPost
@synthesize author, profilePicture, photoName, lowRes, hiRes, likesCount;

-(void)dealloc{
    
    [author release];
    [profilePicture release];
    [photoName release];
    [lowRes release];
    [hiRes release];
    //[locationName release];
    [likesCount release];
    [super dealloc];
}

@end
