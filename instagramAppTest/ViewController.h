//
//  ViewController.h
//  instagramAppTest
//
//  Created by Roman Klimov on 26.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loginViewController.h"
#import "PullTableView.h"

@interface ViewController : UIViewController <UITableViewDataSource, PullTableViewDelegate>{
    
    IBOutlet PullTableView *photoTable;
    //IBOutlet UILabel *label;
    //IBOutlet UIButton *goButton;
    NSString *userToken;
    NSArray *tableData;
    int i;
    //NSUserDefaults *userDefaults;
    
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

@property (retain, nonatomic) IBOutlet PullTableView *photoTable;
//@property (retain, nonatomic) IBOutlet UILabel *label;
//@property (retain, nonatomic) IBOutlet UIButton *goButton;
@property (retain, nonatomic) NSString *userToken;
@property (retain, nonatomic) NSArray *tableData;
//@property (retain, nonatomic) NSUserDefaults *userDefaults;

@property (retain, nonatomic) NSManagedObjectContext *context;
@property (retain, nonatomic) NSManagedObjectModel *model;

-(void)loginViewController:(loginViewController *)controller saveToken:(NSString *)text;

-(void)reloadPosts;
//-(void)getDataWithParams:(NSDictionary *)params andMediaID:(NSString *)mediaID;


@end
