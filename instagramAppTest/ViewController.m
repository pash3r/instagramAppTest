//
//  ViewController.m
//  instagramAppTest
//
//  Created by Roman Klimov on 26.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import "ViewController.h"
#import "loginViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSONKit.h"
#import "InstaPost.h"
#import "AFImageRequestOperation.h"
#import "detailViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize photoTable = _photoTable;
//@synthesize label = _label;
@synthesize goButton;
@synthesize userToken = _userToken;
@synthesize tableData = _tableData;

-(void)reloadPosts{
    
    NSURL *baseURL = [NSURL URLWithString:@"https://api.instagram.com/"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //[httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    //NSLog(@"client: %@", httpClient);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.userToken, @"access_token",
                            nil];
    //NSLog(@"params: %@", params);
    
    NSURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                 path:@"/v1/users/self/feed"
                                           parameters:params];
    //NSLog(@"request == %@", request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        //NSLog(@"response == %@", JSON);
        //NSLog(@"%@", [JSON objectForKey:@"data"]);
        
        NSMutableArray *photosArray = [[NSMutableArray alloc] init];
        NSArray *photos = [JSON objectForKey:@"data"];
        //NSLog(@"count == %@", [photos objectAtIndex:17]);
        //NSLog(@"photos: %@", photos);
//        NSDictionary *photo = [photos objectAtIndex:2];
//        NSDictionary *images = [photo objectForKey:@"images"];
//        NSDictionary *standart = [images objectForKey:@"standard_resolution"];
//        NSLog(@"%@", [standart objectForKey:@"url"]);
        
        for (int i = 0; i <= [photos count] - 1; i++){
            InstaPost *post = [[InstaPost alloc] init];
            NSDictionary *photoData = [photos objectAtIndex:i];
            NSDictionary *user = [photoData objectForKey:@"user"];
            post.author = [user objectForKey:@"full_name"];
            post.profilePicture = [user objectForKey:@"profile_picture"];
            if (![[photoData objectForKey:@"caption"] isEqual:[NSNull null]]){
                NSDictionary *caption = [photoData objectForKey:@"caption"];
                if (![[caption objectForKey:@"text"] isEqual:[NSNull null]]){
                    post.photoName = [caption objectForKey:@"text"];
                }
            }
            NSDictionary *images = [photoData objectForKey:@"images"];
            NSDictionary *thumbnail = [images objectForKey:@"thumbnail"];
            post.miniImage = [thumbnail objectForKey:@"url"];
            NSDictionary *standartRes = [images objectForKey:@"standard_resolution"];
            post.maxiImage = [standartRes objectForKey:@"url"];
            if (![[photoData objectForKey:@"location"] isEqual:[NSNull null]]){
                NSDictionary *location = [photoData objectForKey:@"location"];
                if (![[location objectForKey:@"name"] isEqual:[NSNull null]]){
                    post.locationName = [location objectForKey:@"name"];
                }
            }
            post.likes = [photoData objectForKey:@"likes"];
            post.comments = [photoData objectForKey:@"comments"];
            //NSLog(@"post: %@\n, %@\n, %@\n, %@\n, %@\n", post.author, post.profilePicture, post.miniImage, post.maxiImage, post.locationName);
            [photosArray addObject:post];
        }
        self.tableData = photosArray;
        [self.photoTable reloadData];
    }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"error: %d", [response statusCode]);
        NSLog(@"request == %@\n error == %@", request, error);
        NSLog(@"fail");
    }];

    [operation start];    

    NSLog(@"click!!");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.tableData count];
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 311, 150, 20)];
    }
    // Configure the cell...
    InstaPost *postt = (InstaPost *)[self.tableData objectAtIndex:indexPath.row];
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 150, 150)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:postt.miniImage]];
    
    AFImageRequestOperation *imageRequest = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image){
        return image;
    }success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        [photoView setImage:image];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error getting photo");
    }];
    
    if (self.tableData != nil){
        [imageRequest start];
        }
    
    [cell addSubview:photoView];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 5, 100, 15)];
    [authorLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    authorLabel.text = postt.author;
    [cell addSubview:authorLabel];
    
    UILabel *likesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40, 100, 15)];
    [likesCountLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    if ([postt.likes objectForKey:@"count"] != 0){
        NSNumber *number = [postt.likes objectForKey:@"count"];
        NSString *likesString = [NSString stringWithFormat:@"Likes: %@", number];
        likesCountLabel.text = likesString;
        [cell addSubview:likesCountLabel];
    }
    //[likesString release];
    
    UILabel *commentsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 60, 100, 15)];
    [commentsCountLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    if ([postt.comments objectForKey:@"count"] != 0){
        NSNumber *number1 = [postt.comments objectForKey:@"count"];
        NSString *commentsString = [NSString stringWithFormat:@"Comments: %@", number1];
        commentsCountLabel.text = commentsString;
        [cell addSubview:commentsCountLabel];
    }
    //[commentsString release];

        
    //cell.textLabel.text = @"test";
    
    [photoView release];
    [authorLabel release];
    [likesCountLabel release];
    //[commentsCountLabel release];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableData count] != 0){
        detailViewController *detailView = [[detailViewController alloc] initWithNibName:@"detailViewController" bundle:nil];
    
        InstaPost *currentPost = (InstaPost *)[self.tableData objectAtIndex:indexPath.row];
        detailView.choosenPost = currentPost;
    
        [self.navigationController pushViewController:detailView animated:YES];
        [detailView release];
        NSLog(@"height: %f", self.photoTable.frame.size.height);

    }
}

-(void)loginViewController:(loginViewController *)controller saveToken:(NSString *)text{
    
    //self.label.text = text;
    self.userToken = text;
    NSLog(@"token: %@", self.userToken);
}

- (void)viewDidLoad
{
    i = 0;
    
    if (self.userToken == nil){
        loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        [loginVC setDelegate:self];
        [self presentModalViewController:loginVC animated:YES];
    }
        
    self.navigationItem.title = @"My feed";
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonSystemItemRefresh target:self action:@selector(reloadPosts)];
    [self.navigationItem setRightBarButtonItem:reloadButton];
    [reloadButton release];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.userToken != nil && i == 0){
        [self reloadPosts];
        i++;
    }
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    _photoTable = nil;
    _userToken = nil;
    _tableData = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc{
    
    [_photoTable release];
    [_userToken release];
    [_tableData release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
