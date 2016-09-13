//
//  ViewController.m
//  YYDownloadManager
//
//  Created by 杨振 on 16/9/13.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "ViewController.h"
#import "YYViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)myDownloadPage:(UIButton *)sender {
    
    YYViewController *vc = [[YYViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
