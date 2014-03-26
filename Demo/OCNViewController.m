//
//  OCNViewController.m
//  Demo
//
//  Created by Daniel Doubrovkine on 2/26/14.
//  Copyright (c) 2014 Daniel Doubrovkine. All rights reserved.
//

#import "OCNViewController.h"
#import <objc-ngram/OCNDictionary.h>

@interface OCNViewController ()
@property(nonatomic, readonly) OCNDictionary *dictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, readonly) NSArray *results;
@property(nonatomic, readonly) UIFont *textFont;
@property(nonatomic, readonly) UIFont *detailTextFont;
@end

@implementation OCNViewController

- (void)viewDidLoad
{
    _textFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    _detailTextFont = [UIFont fontWithName:@"Helvetica" size:10.0];
    
    [self loadSentences];
    [super viewDidLoad];
}

- (void)loadSentences
{
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"sentences" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSString *sentencesText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *sentences = [sentencesText componentsSeparatedByString:@"\n"];
    
    _dictionary = [OCNDictionary dictionary];
    for(NSString *sentence in sentences) {
        [self.dictionary addObject:sentence forKey:sentence];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _results = [self.dictionary matchObjectsForKey:searchText];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCNObjectScore *objectWithScore = [self.results objectAtIndex:indexPath.row];
    NSString *match =(NSString *)objectWithScore.object;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:match];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:match];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = self.textFont;
        cell.textLabel.text = match;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(score: %f)", objectWithScore.score];
        cell.detailTextLabel.font = self.detailTextFont;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f + [[_results[indexPath.row] object] boundingRectWithSize:self.tableView.frame.size
                                                                  options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{ NSFontAttributeName: self.textFont }
                                                                  context:nil].size.height;
}

@end
