//
//  MyView.m
//  EUExHandwriting
//
//  Created by 杨广 on 16/3/3.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path addLineToPoint:center];
    [self.selectColor setFill];
    [path fill];
}
@end
