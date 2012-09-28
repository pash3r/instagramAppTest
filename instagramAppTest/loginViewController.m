//
//  loginViewController.m
//  instagramAppTest
//
//  Created by Roman Klimov on 27.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import "loginViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"

@interface loginViewController ()

@end

@implementation loginViewController
@synthesize loginPage, okButton, delegate, code;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)dismissSelf:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
    if ([delegate respondsToSelector:@selector(loginViewController:changeParentLabel:)]) {
        NSString *str = @"valera!!!!!!!!!";
        [delegate loginViewController:self changeParentLabel:str];
        NSLog(@"delegate!!!!!");
    }
    
    
}

- (void)viewDidLoad
{
    [loginPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=11fa4d658d2f449e87cd67368576d901&redirect_uri=http://getresponse.com/&response_type=code"]]];
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *clickedURL = [request URL];
    NSString *URLString = [clickedURL absoluteString];
    NSArray *tmpArr = [URLString componentsSeparatedByString:@"="];
    code = [tmpArr objectAtIndex:1];
    NSLog(@"code: %@", code);
    
//    if (navigationType == UIWebViewNavigationTypeOther){
//    
//    NSURL *myLoadedUrl = [webView.request mainDocumentURL];
//    NSString *URLString = [myLoadedUrl absoluteString];
//    NSLog(@"Loaded url: %@", myLoadedUrl);
//    NSArray *tmpArr = [URLString componentsSeparatedByString:@"="];
//    code = [tmpArr objectAtIndex:1];
//    NSLog(@"code == %@", code);
//    //[loginPage stopLoading];
//  
//    if (navigationType == UIWebViewNavigationTypeOther){
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=11fa4d658d2f449e87cd67368576d901&redirect_uri=http://getresponse.com/&code="]];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            code, @"code",
//                            nil];
//    NSMutableURLRequest *request1 = [httpClient requestWithMethod:@"POST" path:@"https://api.instagram.com/oauth/authorize/?client_id=11fa4d658d2f449e87cd67368576d901&redirect_uri=http://getresponse.com/&code=" parameters:params];
//    
//    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request1] autorelease];
//    
//    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *response = [operation responseString];
//        NSLog(@"response: [%@]",response);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@", [operation error]);
//    }];
//    
//    [operation start];
//    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{  
    
}

- (void)viewDidUnload
{
    
    
    
    loginPage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    
    [loginPage release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
