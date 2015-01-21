//
//  ViewController.m
//  SimpleFeedReader
//
//  Created by Thomas LEVY on 14/01/15.
//  Copyright (c) 2015 Thomas LEVY. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieTableViewCell.h"

@interface ViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSMutableData *apiReturnXMLData;
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSString *currentElement;

@property (nonatomic, strong) Movie *currentMovie;
@property (nonatomic, strong) NSMutableArray *movieList;
@property (nonatomic, strong) NSArray *orderedMovieList;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    self.movieList = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView.frame = CGRectZero;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.connection start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Accessors

- (NSURL *)url
{
    if (_url == nil)
    {
        _url = [NSURL URLWithString: feedURL];
    }
    return _url;
}

- (NSURLRequest *)request
{
    if (_request == nil)
    {
        _request = [[NSURLRequest alloc] initWithURL: self.url];
    }
    return _request;
}

- (NSURLConnection *)connection
{
    if (_connection == nil)
    {
        _connection = [NSURLConnection connectionWithRequest: self.request delegate: self];
    }
    return _connection;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.connection cancel];
    self.connection = nil;
    NSLog(@"error");
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.apiReturnXMLData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.apiReturnXMLData = [NSMutableData data];
    [self.apiReturnXMLData setLength: 0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.xmlParser = [[NSXMLParser alloc] initWithData: self.apiReturnXMLData];
    
    [self.xmlParser setDelegate: self];
    
    [self.xmlParser parse];

    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.movieList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kMovieCellIdentifier];
    Movie *movie = [self.orderedMovieList objectAtIndex: indexPath.row];
    
    if (cell == nil)
    {
        cell = [[MovieTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: kMovieCellIdentifier];
    }
    cell.movie = movie;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = [self.orderedMovieList objectAtIndex: indexPath.row];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: movie.link]];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"Error"])
    {
        NSLog(@"Web API Error!");
    }
    
    if ([elementName isEqualToString: @"item"])
    {
        if (self.currentMovie != nil)
        {
            [self.movieList addObject: self.currentMovie];
        }
        self.currentMovie = [[Movie alloc] init];
    }
    
    if ([elementName isEqualToString: @"title"] ||
        [elementName isEqualToString: @"link"] ||
        [elementName isEqualToString: @"trailer"] ||
        [elementName isEqualToString: @"fan:fanRating"] ||
        [elementName isEqualToString: @"reviewLink"] ||
        [elementName isEqualToString: @"category"])
    {
        self.currentElement = [[NSString alloc] initWithString: elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.currentElement isEqualToString: @"title"])
    {
        self.currentMovie.title = [[NSString alloc] initWithString: string];
    }
    else if ([self.currentElement isEqualToString: @"link"])
    {
        self.currentMovie.link = [[NSString alloc] initWithString: string];
    }
    else if ([self.currentElement isEqualToString: @"trailer"])
    {
        self.currentMovie.trailer = [[NSString alloc] initWithString: string];
    }
    else if ([self.currentElement isEqualToString: @"fan:fanRating"])
    {
        self.currentMovie.fanRating = [[NSNumber alloc] initWithFloat: [string floatValue]];
    }
    else if ([self.currentElement isEqualToString: @"reviewLink"])
    {
        self.currentMovie.reviewLink = [[NSString alloc] initWithString: string];
    }
    else if ([self.currentElement isEqualToString: @"category"])
    {
        self.currentMovie.category = [[NSString alloc] initWithString: string];
    }
    self.currentElement = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.apiReturnXMLData = nil;
    
   self.orderedMovieList = [self.movieList sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
        return [((Movie *)obj1).title compare: ((Movie *)obj2).title];
    }];
    [self.tableView reloadData];
}

@end
