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
}

@property (retain, nonatomic) IBOutlet UIScrollView *scroll;
@property (retain, nonatomic) InstaPost *choosenPost;

@end
