//
//  detailViewController.m
//  instagramAppTest
//
//  Created by Roman Klimov on 26.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import "detailViewController.h"
#import "AFImageRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface detailViewController ()

@end

@implementation detailViewController
@synthesize scroll = _scroll;
@synthesize choosenPost;
@synthesize location;
@synthesize token;
@synthesize likedPeople;

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
        location = [[UILabel alloc] init];
        [location setFrame:CGRectMake(7, 340, 220, 50)];
        [location setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [location setNumberOfLines:4];
        [location setLineBreakMode:UILineBreakModeClip];
        location.text = choosenPost.locationName;
        [self.scroll addSubview:location];
    }
    
    if (![[choosenPost.likes objectForKey:@"count"] isEqual:[NSNull null]]){
        //NSLog(@"%@", [choosenPost.likes objectForKey:@"data"]);
        NSMutableArray *likedUsersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *person in [choosenPost.likes objectForKey:@"data"]){
            NSString *name = [person objectForKey:@"username"];
            [likedUsersArr addObject:name];
        }
        //NSLog(@"liked: %@", [likedUsersArr componentsJoinedByString:@", "]);
        if (location){
            likedPeople = [[UILabel alloc] initWithFrame:CGRectMake(7, 385, 300, 29)];
            [likedPeople setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [likedPeople setNumberOfLines:3];
            [likedPeople setLineBreakMode:UILineBreakModeClip];
            NSString *likedUsersStr = [likedUsersArr componentsJoinedByString:@", "];
            likedPeople.text = [NSString stringWithFormat:@"Liked: %@", likedUsersStr];
            [self.scroll addSubview:likedPeople];
        }else {
            likedPeople = [[UILabel alloc] initWithFrame:CGRectMake(7, 345, 300, 29)];
            [likedPeople setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [likedPeople setNumberOfLines:3];
            [likedPeople setLineBreakMode:UILineBreakModeClip];
            NSString *likedUsersStr = [likedUsersArr componentsJoinedByString:@", "];
            likedPeople.text = [NSString stringWithFormat:@"Liked: %@", likedUsersStr];
            [self.scroll addSubview:likedPeople];
        }
    }
    //NSLog(@"%@", [[[choosenPost.comments objectForKey:@"data"] objectAtIndex:1] objectForKey:@"from"]);
    
    if ([[choosenPost.comments objectForKey:@"data"] count] != 0){
        if (location && likedPeople){
            [self showComments:420 commentTextY:437];
        } else if (location || likedPeople){
            [self showComments:393 commentTextY:410];
        } else {
            [self showComments:342 commentTextY:359];
        }
        
    }
    
    UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithTitle:@"Like" style:UIBarButtonItemStyleBordered target:self action:@selector(setLike)];
    self.navigationItem.rightBarButtonItem = likeButton;
    UIBarButtonItem *dislikeButton = [[UIBarButtonItem alloc] initWithTitle:@"Unlike" style:UIBarButtonItemStyleBordered target:self action:@selector(setDislike)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:likeButton, dislikeButton, nil];
    
    [likeButton release];
    [dislikeButton release];
    
    //NSLog(@"id: %@", choosenPost.mediaID);
    
    [photo release];
    [avatar release];
    [creator release];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)showComments:(int)CommentAuthorY commentTextY:(int)CommentTextY{
    
    int commentAuthorY = CommentAuthorY, commentTextY = CommentTextY;
    for (int i = 0; i <= [[choosenPost.comments objectForKey:@"data"] count] - 1; i++){
        UILabel *commentAuthor = [[UILabel alloc] initWithFrame:CGRectMake(7, commentAuthorY, 300, 18)];
        [commentAuthor setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        NSDictionary *comment = [[choosenPost.comments objectForKey:@"data"] objectAtIndex:i];
        NSString *str = [NSString stringWithFormat:@"%@:", [[comment objectForKey:@"from"] objectForKey:@"username"]];
        commentAuthor.text = str;
        commentAuthorY = commentAuthorY + 18 + 37;
        
        UILabel *commentText = [[UILabel alloc] initWithFrame:CGRectMake(7, commentTextY, 300, 35)];
        [commentText setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [commentText setLineBreakMode:UILineBreakModeClip];
        [commentText setNumberOfLines:3];
        commentText.text = [comment objectForKey:@"text"];
        commentTextY = commentTextY + 35 + 20;
        
        CGFloat newHeight = self.scroll.contentSize.height + 60;
        [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width, newHeight)];
        [self.scroll addSubview:commentAuthor];
        [self.scroll addSubview:commentText];
        
        [commentAuthor release];
        [commentText release];
    }

}

-(void)setLike{
    
    NSString *urlString = [NSString stringWithFormat:@"/v1/media/%@/likes", choosenPost.mediaID];
    NSURL *baseURL = [NSURL URLWithString:@"https://api.instagram.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:token, @"access_token", nil];
    NSURLRequest *setLike = [httpClient requestWithMethod:@"POST" path:urlString parameters:parameters];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:setLike];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *response = [operation responseString];
        NSLog(@"Liked!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [operation error]);
    }];
    [operation start];
    [operation release];
}

-(void)setDislike{
    
    NSString *urlString = [NSString stringWithFormat:@"/v1/media/%@/likes", choosenPost.mediaID];
    NSURL *baseURL = [NSURL URLWithString:@"https://api.instagram.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:token, @"access_token", nil];
    NSURLRequest *setLike = [httpClient requestWithMethod:@"DELETE" path:urlString parameters:parameters];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:setLike];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *response = [operation responseString];
        NSLog(@"Unliked");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [operation error]);
    }];
    [operation start];
    [operation release];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    _scroll = nil;
    choosenPost = nil;
    location = nil;
    token = nil;
    likedPeople = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    
    [_scroll release];
    [choosenPost release];
    [location release];
    [token release];
    [likedPeople release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
