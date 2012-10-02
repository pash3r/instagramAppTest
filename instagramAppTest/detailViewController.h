//
//  detailViewController.h
//  instagramAppTest
//
//  Created by Roman Klimov on 26.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "InstaPost.h"

@interface detailViewController : UIViewController <UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *scroll;
    InstaPost *choosenPost;
    UILabel *location;
    NSString *token;
    UILabel *likedPeople;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scroll;
@property (retain, nonatomic) InstaPost *choosenPost;
@property (retain, nonatomic) UILabel *location;
@property (retain, nonatomic) NSString *token;
@property (retain, nonatomic) UILabel *likedPeople;

-(void)setLike;
-(void)setDislike;
-(void)showComments:(int)CommentAuthorY commentTextY:(int)CommentTextY;

@end
