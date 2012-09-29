//
//  ViewController.h
//  instagramAppTest
//
//  Created by Roman Klimov on 26.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loginViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate>{
    
    IBOutlet UITableView *photoTable;
    IBOutlet UILabel *label;
    IBOutlet UIButton *goButton;
    NSString *user_token;
    NSArray *jsonDict;
}

@property (retain, nonatomic) IBOutlet UITableView *photoTable;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIButton *goButton;
@property (retain, nonatomic) NSString *user_token;
@property (retain, nonatomic) NSArray *jsonDict;

-(void)loginViewController:(loginViewController *)controller saveToken:(NSString *)text;

-(IBAction)makeRequest:(id)sender;
-(void)parseJSON:(NSArray *)json;

@end
