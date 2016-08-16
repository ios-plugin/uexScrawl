//
//  PaintingViewController.h
//  EUExHandwriting
//
//  Created by 杨广 on 16/2/23.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppCanKit/AppCanKit.h>
@interface PaintingViewController : UIViewController
@property (strong, nonatomic)  UIImage *backGroundImage;
@property (nonatomic, weak) id<AppCanWebViewEngineObject> webViewEngine;
@property (nonatomic, strong) ACJSFunctionRef *func;
@end
