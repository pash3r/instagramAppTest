//
//  loginViewController.h
//  instagramAppTest
//
//  Created by Roman Klimov on 27.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class loginViewController;

@protocol loginViewDelegate <NSObject>

-(void)loginViewController:(loginViewController *)controller changeParentLabel:(NSString *)text;

@end

@interface loginViewController : UIViewController <UIWebViewDelegate>{
    
    IBOutlet UIWebView *loginPage;
    IBOutlet UIButton *okButton;
    id <loginViewDelegate> delegate;
    NSString *code;
}

//@property (assign, nonatomic) ViewController *viewController;

@property (strong, nonatomic) IBOutlet UIWebView *loginPage;
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (assign, nonatomic) id <loginViewDelegate> delegate;
@property (retain, nonatomic) NSString *code;

-(IBAction)dismissSelf:(id)sender;


@end
