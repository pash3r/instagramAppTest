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

@interface ViewController ()

@end

@implementation ViewController
@synthesize photoTable = _photoTable;
@synthesize label = _label;
@synthesize goButton;
@synthesize user_token;
@synthesize jsonDict;
@synthesize tableData = _tableData;

-(IBAction)makeRequest:(id)sender{
    
//    NSURL *url = [NSURL URLWithString:@"http://api.instagram.com/v1/users/self/"];
//    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
//    
//    //depending on what kind of response you expect.. change it if you expect XML 
//    //[client registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    
//    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
//                            user_token, @"access_token", 
//                            nil];
//    [client putPath:@"/feed" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"success");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure");
//    }];    
//    //call start on your request operation
    NSURL *baseURL = [NSURL URLWithString:@"https://api.instagram.com/"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //[httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            user_token, @"access_token",
                            nil];
    //NSLog(@"params == %@", params);
    
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
        NSLog(@"photos: %@", [photos objectAtIndex:5]);
//        NSDictionary *photo = [photos objectAtIndex:2];
//        NSDictionary *images = [photo objectForKey:@"images"];
//        NSDictionary *standart = [images objectForKey:@"standard_resolution"];
//        NSLog(@"%@", [standart objectForKey:@"url"]);
        
        for (int i = 0; i <= 16; i++){
            InstaPost *post = [[InstaPost alloc] init];
            NSDictionary *photoData = [photos objectAtIndex:i];
            NSDictionary *user = [photoData objectForKey:@"user"];
            post.author = [user objectForKey:@"full_name"];
            post.profilePicture = [user objectForKey:@"profile_picture"];
//            if ([photoData objectForKey:@"caption"] != nil){
//                NSDictionary *caption = [photoData objectForKey:@"caption"];
//                if ([caption objectForKey:@"text"] != nil){
//                    post.photoName = [caption objectForKey:@"text"];
//                }
//            }
            //NSLog(@"name: %@\n picture: %@", post.author, post.profilePicture);
            NSDictionary *images = [photoData objectForKey:@"images"];
            NSDictionary *lowResolution = [images objectForKey:@"low_resolution"];
            post.lowRes = [lowResolution objectForKey:@"url"];
            NSDictionary *standartRes = [images objectForKey:@"standard_resolution"];
            post.hiRes = [standartRes objectForKey:@"url"];
            NSDictionary *likes = [photoData objectForKey:@"likes"];
            post.likesCount = [likes objectForKey:@"count"];
            NSLog(@"post: %@\n, %@\n, %@\n, %@\n, %@\n", post.author, post.profilePicture, post.lowRes, post.hiRes, post.likesCount);
            [photosArray addObject:post];
        }
        self.tableData = photosArray;
    }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        // 
        NSLog(@"error: %d", [response statusCode]);
        NSLog(@"request == %@\n error == %@", request, error);
        NSLog(@"fail");
    }];
    
    // you can either start your operation like this 
    [operation start];    

    NSLog(@"click!!");
}

-(void)parseJSON:(NSArray *)json{
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 500;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 311, 150, 20)];
    }
    // Configure the cell...
    InstaPost *postt = (InstaPost *)[self.tableData objectAtIndex:indexPath.row];
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 306, 306)];
    [cell addSubview:photoView];
    
    photoView = [];    
    //cell.textLabel.text = @"test";
    
    return cell;
    
}

-(void)loginViewController:(loginViewController *)controller saveToken:(NSString *)text{
    
    self.label.text = text;
    user_token = text;
}

- (void)viewDidLoad
{
    if (user_token == nil){
        loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        [loginVC setDelegate:self];
        [self presentModalViewController:loginVC animated:YES];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    _photoTable = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc{
    
    [_photoTable release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
