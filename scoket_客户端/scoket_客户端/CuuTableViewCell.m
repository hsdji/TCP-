//
//  CuuTableViewCell.m
//  scoket_客户端
//
//  Created by ekhome on 17/3/31.
//  Copyright © 2017年 小飞. All rights reserved.
//

#import "CuuTableViewCell.h"

@implementation CuuTableViewCell

-(UILabel *)message
{
    if (!_message)
    {
        _message = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, 0.8*self.frame.size.width-20, self.frame.size.height)];
        _message.numberOfLines = 1000;
        _message.textAlignment = NSTextAlignmentRight;
    }
    [self.contentView addSubview:_message];
    return _message;
}

@end
