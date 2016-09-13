//
//  YYTableViewCell.m
//  YYDownloadManager
//
//  Created by 杨振 on 16/9/13.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "YYTableViewCell.h"
#import "YYDelayButton.h"
#import "MCDownloadManager.h"
#import <MediaPlayer/MediaPlayer.h>

#define LoadNib(xibName) [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil].firstObject

@interface YYTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *viewName;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet YYDelayButton *clickBtn;

@end

@implementation YYTableViewCell

+ (instancetype)tableViewCellWith:(UITableView *)tableView
{
    static NSString *identifer = @"custonCell";
    YYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = LoadNib(@"YYTableViewCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setUrl:(NSString *)url {
    _url = url;
    
    self.viewName.text = url.lastPathComponent;
    self.progressView.progress = 1;
    
    [self downloadReceipt:url];
}
- (void)downloadReceipt:(NSString *)url
{
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:url];
    
    self.progressView.progress = receipt.progress.fractionCompleted;
    
    if (receipt.state == MCDownloadStateDownloading) {
        [self.clickBtn setTitle:@"停止" forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateCompleted) {
        [self.clickBtn setTitle:@"播放" forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateFailed) {
        [self.clickBtn setTitle:@"重新下载" forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateSuspened) {
        [self.clickBtn setTitle:@"继续下载" forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateWillResume) {
        [self.clickBtn setTitle:@"等待下载" forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateNone) {
        [self.clickBtn setTitle:@"下载" forState:UIControlStateNormal];
    }
}
- (IBAction)clickButton:(YYDelayButton *)sender {
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:self.url];
    if (receipt.state == MCDownloadStateCompleted) {
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        MPMoviePlayerViewController *mpc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:receipt.filePath]];
        [vc presentViewController:mpc animated:YES completion:nil];
    }else if (receipt.state == MCDownloadStateFailed) {
        [self.clickBtn setTitle:@"停止" forState:UIControlStateNormal];
        [self download];
    }else if (receipt.state == MCDownloadStateDownloading) {
        [self.clickBtn setTitle:@"继续下载" forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
    }else if (receipt.state == MCDownloadStateSuspened) {
        [self.clickBtn setTitle:@"停止" forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] resumeWithDownloadReceipt:receipt];
    }else if (receipt.state == MCDownloadStateWillResume) {
        [self.clickBtn setTitle:@"下载" forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] removeWithDownloadReceipt:receipt];
    }else if (receipt.state == MCDownloadStateNone) {
        [self.clickBtn setTitle:@"停止" forState:UIControlStateNormal];
        [self download];
    }
}
- (void)download {
    [[MCDownloadManager defaultInstance] downloadFileWithURL:self.url
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        
                                                        if ([receipt.url isEqualToString:self.url]) {
                                                            self.progressView.progress = downloadProgress.fractionCompleted ;
                                                        }
                                                        
                                                    }
                                                 destination:nil
                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
                                                         [self.clickBtn setTitle:@"播放" forState:UIControlStateNormal];
                                                     }
                                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         [self.clickBtn setTitle:@"重新下载" forState:UIControlStateNormal];
                                                     }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.clipsToBounds = YES;
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.clickBtn.clipsToBounds = YES;
    self.clickBtn.layer.cornerRadius = 10;
    self.clickBtn.layer.borderWidth = 1;
    self.clickBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.clickBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.clickBtn.clickDurationTime = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
