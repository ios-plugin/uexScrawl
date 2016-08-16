//
//  EUExScrawl.m
//  EUExScrawl
//
//  Created by 杨广 on 16/3/17.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "EUExScrawl.h"
#import "EUtility.h"
#import "PaintingViewController.h"
@implementation EUExScrawl
//-(id)initWithBrwView:(EBrowserView *) eInBrwView {
//    if (self = [super initWithBrwView:eInBrwView]) {
//        
//    }
//    return self;
//}
-(void)open:(NSMutableArray *)inArguments{
    if (inArguments.count < 1) {
        return;
    }
    ACArgsUnpack(NSDictionary *jsonDict) = inArguments;
    ACJSFunctionRef *func = ac_JSFunctionArg(inArguments.lastObject);
    NSString *imagePath = [jsonDict objectForKey:@"src"];
    //imagePath = [EUtility getAbsPath:meBrwView path:imagePath];
    imagePath = [self absPath:imagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    PaintingViewController *paintingVC = [[PaintingViewController alloc]init];
    paintingVC.webViewEngine = self.webViewEngine;
    paintingVC.backGroundImage = image;
    paintingVC.func = func;
    //[EUtility brwView:meBrwView presentModalViewController:paintingVC animated:YES];
    [[self.webViewEngine viewController] presentViewController:paintingVC animated:YES completion:nil];
    
}

@end

