//
//  MovieTableViewCell.m
//  SimpleFeedReader
//
//  Created by Thomas LEVY on 19/01/15.
//  Copyright (c) 2015 Thomas LEVY. All rights reserved.
//

#import "MovieTableViewCell.h"

@interface MovieTableViewCell ()

@end

@implementation MovieTableViewCell

#pragma mark - Accessors

- (void)setMovie:(Movie *)movie
{
    _movie = movie;
    self.textLabel.text = _movie.title;
    if (_movie.fanRating)
    {
        self.detailTextLabel.text = [NSString stringWithFormat: @"Fan Rating: %@", _movie.fanRating];
    }
}

@end
