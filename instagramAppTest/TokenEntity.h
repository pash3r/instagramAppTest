//
//  TokenEntity.h
//  instagramAppTest
//
//  Created by Roman Klimov on 04.10.12.
//  Copyright (c) 2012 info@vvww.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TokenEntity : NSManagedObject

@property (nonatomic, retain) NSString * token;

@end
