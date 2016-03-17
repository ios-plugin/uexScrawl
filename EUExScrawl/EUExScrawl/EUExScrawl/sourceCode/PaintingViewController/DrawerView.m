//
//  DrawerView.m
//  EUExHandwriting
//
//  Created by 杨广 on 16/2/24.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "DrawerView.h"
#import "HVWBezierPath.h"
@interface DrawerView ()

@end

@implementation DrawerView

- (void)awakeFromNib
{
    
}
- (NSMutableArray *)lines {
    if (nil == _lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint startLocation = [touch locationInView:touch.view];
    
    // 新建一条Bezier线
    HVWBezierPath *path = [[HVWBezierPath alloc] init];
    
    // 配置线粗
    if (self.lineWidth) {
        [path setLineWidth:self.lineWidth];
    }
    // 配置线色
    if (self.lineColor) {
        path.color = self.lineColor;
    }
    
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    
    // 移动到始点
    [path moveToPoint:startLocation];
    // 添加Bezier线到数组
    [self.lines addObject:path];
    
    // 重绘
    [self setNeedsDisplay];
   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // 获得正在画的线
    HVWBezierPath *path = [self.lines lastObject];
    
    // 画线-添加点信息
    [path addLineToPoint:location];
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 停止拖曳的逻辑其实和拖曳中是一样的
    [self touchesMoved:touches withEvent:event];
}

#pragma mark - 绘图方法
/** 绘图 */
- (void)drawRect:(CGRect)rect {
    // 画出所有的线
    for (HVWBezierPath *path in self.lines) {
        
        // 设置颜色
        if (path.color) {
            [path.color set];
        }
        [path strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
        // 渲染
        [path stroke];
       
    }
    
}

#pragma mark - view操作方法
/** 回退 */
- (void)rollback {
    [self.lines removeLastObject];
    [self setNeedsDisplay];
}

/** 清屏 */
- (void)clearScreen {
    [self.lines removeAllObjects];
    [self setNeedsDisplay];
}
/** 橡皮 */
-(void)erase{
    
    self.lineColor = [UIColor clearColor];

}
/** 画笔 */
-(void)draw{
    

}
@end
