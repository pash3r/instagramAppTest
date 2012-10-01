//
//  detailViewController.m
//  instagramAppTest
//
//  Created by Roman Klimov on 26.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import "detailViewController.h"
#import "AFImageRequestOperation.h"

@interface detailViewController ()

@end

@implementation detailViewController
@synthesize scroll = _scroll;
@synthesize choosenPost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width, 416)];
    
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 25, 25)];
    
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:choosenPost.profilePicture]];
    AFImageRequestOperation *imageRequest1 = [AFImageRequestOperation imageRequestOperationWithRequest:request1 imageProcessingBlock:^UIImage *(UIImage *image){
        return image;
    }success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        [avatar setImage:image];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error getting photo");
    }];
    [imageRequest1 start];
    [self.scroll addSubview:avatar];
    
    UILabel *creator = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 150, 20)];
    [creator setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    creator.text = choosenPost.author;
    [self.scroll addSubview:creator];
    
    UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(7, 34, 306, 306)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:choosenPost.maxiImage]];
    AFImageRequestOperation *imageRequest = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image){
        return image;
    }success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        [photo setImage:image];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error getting photo");
    }];
    
    [imageRequest start];
    [self.scroll addSubview:photo];
    
    if ([choosenPost.locationName length] != 0){
        UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(7, 340, 220, 50)];
        [location setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [location setNumberOfLines:4];
        [location setLineBreakMode:UILineBreakModeClip];
        location.text = choosenPost.locationName;
        [self.scroll addSubview:location];
        [location release];
    }
    
    [photo release];
    [avatar release];
    [creator release];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    _scroll = nil;
    choosenPost = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    
    [_scroll release];
    [choosenPost release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
