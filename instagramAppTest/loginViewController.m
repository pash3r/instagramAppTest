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
#import "TokenEntity.h"

@interface loginViewController ()

@end

static NSString *const authUrlString = @"https://api.instagram.com/oauth/authorize/";
static NSString *const tokenUrlString = @"https://api.instagram.com/oauth/access_token/";
static NSString *const clientID = @"11fa4d658d2f449e87cd67368576d901";
static NSString *const clientSecret = @"c8b74ecf12954616a1b508380bb7afc7";
static NSString *const redirectUri = @"http://getresponse.com/";
static NSString *const scope = @"basic+likes";



@implementation loginViewController
@synthesize loginPage, delegate;
@synthesize tokenStr;

@synthesize context, model;

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
    //https://api.instagram.com/oauth/authorize/?client_id=11fa4d658d2f449e87cd67368576d901&redirect_uri=http://getresponse.com/&response_type=code
    
    //[loginPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://instagram.com/oauth/authorize/?client_id=11fa4d658d2f449e87cd67368576d901&redirect_uri=http://getresponse.com/&response_type=token"]]];
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSString *fullAuthUrlString = [[NSString alloc]
                                   initWithFormat:@"%@/?client_id=%@&redirect_uri=%@&scope=%@&response_type=token&display=touch",
                                   authUrlString,
                                   clientID,
                                   redirectUri,
                                   scope
                                   ];
    NSURL *authUrl = [NSURL URLWithString:fullAuthUrlString];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:authUrl];
    //NSURLRequest *tmpReq = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://https://instagram.com/accounts/logout/"]];
    [loginPage loadRequest:myRequest];
    [myRequest release];
    [fullAuthUrlString release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //if(navigationType == UIWebViewNavigationTypeLinkClicked){
    NSString* urlString = [[request URL] absoluteString];
    NSString *kRedirectUri = @"http://getresponse.com/";
    
    if ([urlString hasPrefix: kRedirectUri]) {
        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
        if (tokenParam.location != NSNotFound) {
            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            // If there are more args, don't include them in the token:
            NSRange endRange = [token rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                token = [token substringToIndex: endRange.location];
            tokenStr = token;
            //NSLog(@"token == %@", tokenStr);
            
            TokenEntity *tokenEntity = (TokenEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"TokenEntity" inManagedObjectContext:context];
            [tokenEntity setToken:tokenStr];
            
            NSLog(@"entity.token: %@", tokenEntity.token);
            
            if ([delegate respondsToSelector:@selector(loginViewController:saveToken:)] && tokenStr != nil) {
                //NSLog(@"tokenStr == %@", tokenStr);
                [delegate loginViewController:self saveToken:tokenStr];
                NSLog(@"delegate!!!!!");
                [self dismissModalViewControllerAnimated:YES];
                }
        }
        }
    //}
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    loginPage = nil;
    tokenStr = nil;
    
    context = nil;
    model = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    
    [loginPage release];
    [tokenStr release];
    
    [context release];
    [model release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
