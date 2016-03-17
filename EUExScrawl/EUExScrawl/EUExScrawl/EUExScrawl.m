//
//  EUExScrawl.m
//  EUExScrawl
//
//  Created by 杨广 on 16/3/17.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "EUExScrawl.h"
#import "EUtility.h"
#import "JSON.h"
#import "PaintingViewController.h"
@implementation EUExScrawl
-(id)initWithBrwView:(EBrowserView *) eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {
        
    }
    return self;
}
-(void)open:(NSMutableArray *)inArguments{
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
        self.jsonDict = [jsonStr JSONValue];//将JSON类型的字符串转化为可变字典
        
    }else{
        return;
    }
    NSString *imagePath = [self.jsonDict objectForKey:@"src"];
    imagePath = [EUtility getAbsPath:meBrwView path:imagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    PaintingViewController *paintingVC = [[PaintingViewController alloc]init];
    paintingVC.meBrwView = meBrwView;
    paintingVC.backGroundImage = image;
    [EUtility brwView:meBrwView presentModalViewController:paintingVC animated:YES];
    
}

@end

