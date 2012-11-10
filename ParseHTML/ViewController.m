//
//  ViewController.m
//  ParseHTML
//
//  Created by Alex Antonyuk on 11/10/12.
//  Copyright (c) 2012 Alex Antonyuk. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <hpple/TFHpple.h>
#import <hpple/XPathQuery.h>
#import "ImageCell.h"

@interface ViewController ()
	<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIButton* parseImagesButton;
@property (strong, nonatomic) UITableView* tableView;

- (void)parseTapped:(UIButton*)sender;
@property (strong, nonatomic) NSArray* images;

@end

@implementation ViewController

- (void)
viewDidLoad
{
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.

	self.parseImagesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.parseImagesButton setTitle:@"Parse" forState:UIControlStateNormal];
	self.parseImagesButton.frame = CGRectMake(10.0, 10.0, 80.0, 44.0);
	[self.parseImagesButton addTarget:self action:@selector(parseTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.parseImagesButton];

	CGRect tableFrame = self.view.bounds;
	tableFrame.origin.y = 60;
	tableFrame.size.height -= 60;
	self.tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerClass:[ImageCell class] forCellReuseIdentifier:@"ImageCell"];

	[self.view addSubview:self.tableView];
}

- (void)
parseTapped:(UIButton*)sender
{
	sender.enabled = NO;

	AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://500px.com/"]];
	[httpClient getPath:@"/popular" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		TFHpple* doc = [[TFHpple alloc] initWithHTMLData:responseObject];

		NSArray* images = [doc searchWithXPathQuery:@"//img"];
		NSMutableArray* srcs = [NSMutableArray arrayWithCapacity:images.count];
		[images enumerateObjectsUsingBlock:^(TFHppleElement* node, NSUInteger idx, BOOL *stop) {
			NSString* src = node.attributes[@"src"];
			if (src) {
				[srcs addObject:src];
			}
		}];
		self.images = srcs;
		[self.tableView reloadData];
		sender.enabled = YES;
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		sender.enabled = YES;
	}];
}

#pragma mark - TV Delegate & Data Source

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.images.count;
}

- (ImageCell*)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* ident = @"ImageCell";

	ImageCell* cell = [tableView dequeueReusableCellWithIdentifier:ident];
	cell.imageView.image = nil;
	if (indexPath.row < self.images.count) {
		[cell.picView setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]]];
	}

	return cell;
}

- (CGFloat)
tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 200.0;
}

@end
