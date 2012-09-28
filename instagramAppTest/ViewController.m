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
#import "AFHTTPRequestOperation.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize photoTable = _photoTable;
@synthesize label = _label;
@synthesize goButton;
@synthesize user_token;

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
    NSURL *baseURL = [NSURL URLWithString:@"http://api.instagram.com/"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            user_token, @"access_token",
                            nil];
    
    [httpClient postPath:@"/feed" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // reponseObject will hold the data returned by the server.
        NSLog(@"data: %@", responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error retrieving data: %@", error);
    }];
    

    NSLog(@"click!!");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    cell.textLabel.text = @"test";
    
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
