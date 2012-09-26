//
//  AppDelegate.h
//  instagramAppTest
//
//  Created by Roman Klimov on 26.09.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navContr;

@end
