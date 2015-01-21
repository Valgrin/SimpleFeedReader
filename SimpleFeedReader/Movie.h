//
//  Movie.h
//  SimpleFeedReader
//
//  Created by Thomas LEVY on 19/01/15.
//  Copyright (c) 2015 Thomas LEVY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *trailer;
@property (nonatomic, strong) NSNumber *fanRating;
@property (nonatomic, strong) NSString *reviewLink;
@property (nonatomic, strong) NSString *category;

@end
