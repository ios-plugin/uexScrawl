//
//  DrawerView.h
//  EUExHandwriting
//
//  Created by 杨广 on 16/2/24.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerView : UIView
/** 线组(所有线) */
@property(nonatomic, strong) NSMutableArray *lines;

/** 线粗 */
@property(nonatomic, assign) CGFloat lineWidth;

/** 线颜色 */
@property(nonatomic, strong) UIColor *lineColor;

/** 背景图 */
@property (nonatomic, strong) UIImage * drawImage;

/**是不是橡皮擦 */
//@property (nonatomic, assign) BOOL isEraser;

/** 回退 */
- (void)rollback;

/** 清屏 */
- (void)clearScreen;

/** 橡皮擦 */
- (void)erase;
/** 画笔 */
-(void)draw;
@end
