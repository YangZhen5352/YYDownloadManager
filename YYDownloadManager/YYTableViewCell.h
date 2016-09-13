//
//  YYTableViewCell.h
//  YYDownloadManager
//
//  Created by 杨振 on 16/9/13.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *url;
+ (instancetype)tableViewCellWith:(UITableView *)tableView;

@end
