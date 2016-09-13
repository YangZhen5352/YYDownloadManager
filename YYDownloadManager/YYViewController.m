//
//  YYViewController.m
//  YYDownloadManager
//
//  Created by 杨振 on 16/9/13.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "YYViewController.h"
#import "YYTableViewCell.h"
#import "MCDownloadManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YYViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation YYViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.urls.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTableViewCell *cell = [YYTableViewCell tableViewCellWith:tableView];
    cell.url = self.urls[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[MCDownloadManager defaultInstance] removeWithURL:self.urls[indexPath.row]];
        [self.tableView reloadData];
    }
}
#pragma mark -
#pragma mark - lazy
- (NSMutableArray *)urls
{
    if (!_urls) {
        self.urls = [NSMutableArray array];
        for (int i = 1; i<=10; i++) {
            [self.urls addObject:[NSString stringWithFormat:@"http://120.25.226.186:32812/resources/videos/minion_%02d.mp4", i]];
            
        }
    }
    return _urls;
}

@end
