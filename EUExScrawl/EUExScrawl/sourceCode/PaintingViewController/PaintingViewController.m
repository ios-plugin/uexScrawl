//
//  PaintingViewController.m
//  EUExHandwriting
//
//  Created by 杨广 on 16/2/23.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "PaintingViewController.h"
#import "DrawerView.h"
#import <Masonry/Masonry.h>
#import "EUtility.h"
#import "MyView.h"
#import "JSON.h"

#define BOTTOWVIEW_HEIGHT 40.0f
#define SETTINGVIEW_HEIGHT 50.0f
#define BOTTOWVIEW_ICON 30.0f
#define SETTINGVIEW_ICON 40.0f
@interface PaintingViewController ()
@property (strong, nonatomic) DrawerView *drawerView;
@property (strong, nonatomic) MyView *showView;
@property (strong, nonatomic) UIView *settingColorView;
@property (strong, nonatomic)  UISlider *alphaValueSlider;
@property (assign, nonatomic)   CGFloat alphaValue;
@property (strong, nonatomic)  UISlider *drawingSizeSlider;
@property (assign, nonatomic)   CGFloat drawingSize;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *settingView;
@property (strong, nonatomic)  UIImageView *backGroundImageView;
@property (strong,nonatomic) UIColor *selectedColor;
@property (strong,nonatomic) UIColor *tempColor;

@end

@implementation PaintingViewController
-(UIView*)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [EUtility ColorFromString:@"#363636"];//[UIColor lightGrayColor];
        _bottomView.tag = 1000;
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(BOTTOWVIEW_HEIGHT);
        }];
    }
    return _bottomView;
}
-(UIView*)settingView{
    if (!_settingView) {
        _settingView = [UIView new];
        _settingView.backgroundColor = [EUtility ColorFromString:@"#2F4F4F"];//[UIColor grayColor];
        _settingView.tag = 1002;
        [self.view addSubview:_settingView];
        [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.bottomView.mas_top).mas_equalTo(0);
            make.height.mas_equalTo(SETTINGVIEW_HEIGHT);
        }];
    }
    return _settingView;
}

-(DrawerView*)drawerView{
    if (!_drawerView) {
        _drawerView = [DrawerView new];
        _drawerView.userInteractionEnabled = YES;
        CGSize size = [self OriginImage:self.backGroundImage Width:self.view.bounds.size.width Height:self.view.bounds.size.height-BOTTOWVIEW_HEIGHT-SETTINGVIEW_HEIGHT];
        NSLog(@"%@", NSStringFromCGSize(size));

        _drawerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_drawerView];
        [_drawerView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (size.height > size.width) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo((self.view.bounds.size.width - size.width)/2);
            }else{
                make.top.mas_equalTo((self.view.bounds.size.height - SETTINGVIEW_HEIGHT-BOTTOWVIEW_HEIGHT - size.height)/2);
                make.left.mas_equalTo((self.view.bounds.size.width - size.width)/2);
            }
            make.size.mas_equalTo(size);
           
        }] ;
    }
    return _drawerView;
}
-(UIView*)showView{
    if (!_showView) {
        _showView = [MyView new];
        _showView.backgroundColor =[EUtility ColorFromString:@"#FFFFFF"]; //[UIColor greenColor];
        [_showView.layer setBorderColor:[UIColor grayColor].CGColor];
        [_showView.layer setBorderWidth:5.0];
        [_showView.layer setCornerRadius:5.0];
        _showView.layer.masksToBounds = YES;
        _showView.selectColor =[self.tempColor colorWithAlphaComponent:self.alphaValue];
        _showView.radius = self.drawingSize *10;
        UIButton *btn =(UIButton*)[self.settingView viewWithTag:200];
        [btn addSubview:_showView];
        [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(SETTINGVIEW_HEIGHT-(SETTINGVIEW_HEIGHT - SETTINGVIEW_ICON)/2);
            make.height.mas_equalTo(SETTINGVIEW_HEIGHT-(SETTINGVIEW_HEIGHT - SETTINGVIEW_ICON)/2);
        }];
    }
    return _showView;
}
- (BOOL)prefersStatusBarHidden
{
        return YES;
}

-(UIImageView*)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView = [UIImageView new];
        _backGroundImageView.userInteractionEnabled = YES;
        CGSize size = [self OriginImage:self.backGroundImage Width:self.view.bounds.size.width Height:self.view.bounds.size.height-BOTTOWVIEW_HEIGHT-SETTINGVIEW_HEIGHT];
         UIImage *image = [self OriginImage:self.backGroundImage scaleToSize:size];
        _backGroundImageView.image = image;
         [self.view addSubview:_backGroundImageView];
        [_backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (size.height > size.width) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo((self.view.bounds.size.width - size.width)/2);
            }else{
                make.top.mas_equalTo((self.view.bounds.size.height - SETTINGVIEW_HEIGHT-BOTTOWVIEW_HEIGHT - size.height)/2);
                make.left.mas_equalTo((self.view.bounds.size.width - size.width)/2);
            }
            make.size.mas_equalTo(size);
        }];
    }
    return _backGroundImageView;
}
- (void)viewDidLoad {
    //默认配置
    [super viewDidLoad];
    self.backGroundImageView.hidden = NO;
    self.drawingSize = 0.25;
    self.alphaValue = 1.0;
    self.drawerView.lineWidth = 5;
    self.tempColor = [UIColor redColor];
    [self.drawerView setLineColor:[self.tempColor colorWithAlphaComponent:self.alphaValue]];
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.bottomView.hidden = NO;
    self.settingView.hidden = NO;
    self.drawerView.hidden = NO;
    NSLog(@"==%f",(self.view.bounds.size.width - 40)/7);
    self.selectedColor = [UIColor redColor];
    self.drawerView.lineColor = self.selectedColor;
    
    [self setCharKeyboard:1000 count:4 distance:(self.view.bounds.size.width - 4*BOTTOWVIEW_ICON)/5 top:(BOTTOWVIEW_HEIGHT - BOTTOWVIEW_ICON)/2  titles:nil buttonTag:100];
    [self setCharKeyboard:1002 count:6 distance:(self.view.bounds.size.width - 6*SETTINGVIEW_ICON)/7 top:(SETTINGVIEW_HEIGHT - SETTINGVIEW_ICON)/2   titles:nil buttonTag:200];
    self.showView.hidden = NO;

    
}
-(void)setCharKeyboard:(NSInteger)viewTag count:(NSInteger)count distance:(NSInteger)distance top:(NSInteger)top titles:(NSArray *)titles buttonTag:(NSInteger)buttonTag{
    UIView *view = (UIView*)[self.view viewWithTag:viewTag];
    UIView *lastView1 = nil;
    for (int i = 0; i < count; i ++) {
        UIButton *btn=[UIButton buttonWithType:0];

        //btn.backgroundColor = [UIColor redColor];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.bottom.mas_equalTo(-top);
            if (i == 0) {
                make.left.mas_equalTo(distance);
            }else if(i == count - 1){
                make.right.mas_equalTo(-distance);
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(distance);
            }else{
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(distance);
            }
            if (lastView1) {
                make.width.mas_equalTo(lastView1);
            }
        }];
        lastView1 = btn;
        btn.tag = buttonTag+i;
        if (btn.tag == 100) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"close.png"] forState:UIControlStateNormal];
        }
        if (btn.tag == 101) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"undo.png"] forState:UIControlStateNormal];
            [btn setImage:[self imagesNamedFromCustomBundle:@"undo-act.png"] forState:UIControlStateHighlighted];
        }
        if (btn.tag == 102) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"restore.png"] forState:UIControlStateNormal];
            [btn setImage:[self imagesNamedFromCustomBundle:@"restore-act.png"] forState:UIControlStateHighlighted];
        }
        if (btn.tag == 103) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"save.png"] forState:UIControlStateNormal];
            //[btn setImage:[self imagesNamedFromCustomBundle:@"restore-act.png"] forState:UIControlStateSelected];
        }

        if (btn.tag == 201) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"Eraser.png"] forState:UIControlStateNormal];
            [btn setImage:[self imagesNamedFromCustomBundle:@"Eraser-act.png"] forState:UIControlStateHighlighted];
        }
        if (btn.tag == 202) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"brush-act.png"] forState:UIControlStateNormal];
            [btn setImage:[self imagesNamedFromCustomBundle:@"brush.png"] forState:UIControlStateHighlighted];
        }
        if(btn.tag == 203){
            [btn setImage:[self imagesNamedFromCustomBundle:@"color.png"] forState:UIControlStateNormal];
        }
        if (btn.tag == 204) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"trans.png"] forState:UIControlStateNormal];
            [btn setImage:[self imagesNamedFromCustomBundle:@"trans-act.png"] forState:UIControlStateHighlighted];
        }
        if (btn.tag == 205) {
            [btn setImage:[self imagesNamedFromCustomBundle:@"thin.png"] forState:UIControlStateNormal];
            [btn setImage:[self imagesNamedFromCustomBundle:@"thin-act.png"] forState:UIControlStateHighlighted];
        }

       [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)settingColor:(NSInteger)viewTag count:(NSInteger)count distance:(NSInteger)distance colors:(NSArray *)titles buttonTag:(NSInteger)buttonTag{
    self.drawerView.userInteractionEnabled = NO;
    UIView *view = (UIView*)[self.view viewWithTag:viewTag];
    UIView *lastView1 = nil;
    for (int i = 0; i < count; i ++) {
        UIButton *btn=[UIButton buttonWithType:0];
        [btn.layer setBorderColor:[UIColor blackColor].CGColor];
        [btn.layer setBorderWidth:1.0];
        [btn.layer setCornerRadius:10.0];
        btn.backgroundColor = [EUtility ColorFromString:titles[i]];
        btn.titleLabel.font = [UIFont systemFontOfSize:[EUtility screenWidth] /17];
        
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            if (i == 0) {
                make.left.mas_equalTo(distance);
            }else if(i == count - 1){
                make.right.mas_equalTo(-distance);
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(5);
            }else{
                make.left.mas_equalTo(lastView1.mas_right).mas_equalTo(5);
            }
            if (lastView1) {
                make.width.mas_equalTo(lastView1);
            }
        }];
        lastView1 = btn;
        btn.tag = buttonTag+i;
        [btn addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName
{
    NSBundle *bundle = [EUtility bundleForPlugin:@"uexScrawl"];
    NSString *img_path = [[bundle resourcePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imgName]];
    return [UIImage imageWithContentsOfFile:img_path];
}
-(void)buttonPressed:(id)sender{
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 100) {//关闭
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (btn.tag == 101) {//回退
        self.drawerView.userInteractionEnabled = YES;
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }
        if (self.alphaValueSlider) {
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
            
        }

        [self.drawerView rollback];

    }
    if (btn.tag == 102) {//清屏
        self.drawerView.userInteractionEnabled = YES;
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }
        if (self.alphaValueSlider) {
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
            
        }

        [self.drawerView clearScreen];
    }
    if (btn.tag == 103) {//保存
        self.drawerView.userInteractionEnabled = YES;
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }
        if (self.alphaValueSlider) {
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
        }

        [self saveButtonPressed];
    }
    if (btn.tag == 200) {//预览
        
    }
    if (btn.tag == 201) {//橡皮
        self.drawerView.userInteractionEnabled = YES;
        [btn setImage:[self imagesNamedFromCustomBundle:@"Eraser-act.png"] forState:UIControlStateNormal];
        
            [(UIButton*)[self.settingView viewWithTag:202] setImage:[self imagesNamedFromCustomBundle:@"brush.png"] forState:UIControlStateNormal];
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }
        if (self.alphaValueSlider) {
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
            
        }
        [self.drawerView erase];
    }
    if (btn.tag == 202) {//画笔
        self.drawerView.userInteractionEnabled = YES;
        [btn setImage:[self imagesNamedFromCustomBundle:@"brush-act.png"] forState:UIControlStateNormal];
        [(UIButton*)[self.settingView viewWithTag:201] setImage:[self imagesNamedFromCustomBundle:@"Eraser.png"] forState:UIControlStateNormal];
        [self.drawerView setLineColor:self.selectedColor];
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }
        if (self.alphaValueSlider) {
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
            
        }
        [self.drawerView draw];
        
    }
    if(btn.tag == 203){//选择颜色
         self.drawerView.userInteractionEnabled = YES;
        
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }
        if (self.alphaValueSlider) {
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
            
        }else{
            
            self.settingColorView = [UIView new];
            self.settingColorView.tag = 1004;
            //self.settingColorView.backgroundColor = [UIColor greenColor];
            [self.view addSubview:self.settingColorView];
            [self.settingColorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(self.settingView.mas_top).mas_equalTo(0);
                make.height.mas_equalTo(50);
            }];
            NSArray *colors = [NSArray arrayWithObjects:@"#999999",
                               @"#FFFF00",
                               @"#00CD00",
                               @"#FF0000",
                               @"#1E90FF",
                               @"#0000CD",
                               @"#000000",
                               nil];
            [self settingColor:1004 count:7 distance:5 colors:colors buttonTag:300];
        }

    }
    if (btn.tag == 204) {//透明度
        self.drawerView.userInteractionEnabled = YES;
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
            
        }
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }
        if (self.alphaValueSlider) {
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }else{
            self.alphaValueSlider = [UISlider new];
            self.drawerView.userInteractionEnabled = NO;
            
            
            //左边的图片, 轨迹图  Track:轨迹
            [self.alphaValueSlider setMinimumTrackImage:[UIImage imageNamed:@"bg-act.png"] forState:UIControlStateNormal];
            //右边轨迹图
            [self.alphaValueSlider setMaximumTrackImage:[self imagesNamedFromCustomBundle:@"bg.png"] forState:UIControlStateNormal];
            //设置调节按钮图
            [self.alphaValueSlider setThumbImage:[self imagesNamedFromCustomBundle:@"dot.png"] forState:UIControlStateNormal];
            self.alphaValueSlider.value = self.alphaValue;
           // self.alphaValueSlider.backgroundColor = [UIColor yellowColor];
            self.alphaValueSlider.transform = CGAffineTransformMakeRotation(M_PI*0.5);
            [self.view addSubview:self.alphaValueSlider];
            UIButton *btn = [(UIButton*)self.settingView viewWithTag:204];
            [self.alphaValueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(btn.mas_centerX).mas_equalTo(0);
                make.bottom.mas_equalTo(btn.mas_top).mas_equalTo(-30-(SETTINGVIEW_HEIGHT - SETTINGVIEW_ICON)/2);
                make.size.mas_equalTo(CGSizeMake(120, 60));
                
            }];
            [self.alphaValueSlider addTarget:self action:@selector(alphaChange:) forControlEvents:UIControlEventValueChanged];
            [self.alphaValueSlider addTarget:self action:@selector(alphaChangeEnd:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    if (btn.tag == 205) {//粗细
        self.drawerView.userInteractionEnabled = YES;
        if(self.settingColorView){
            [self.settingColorView removeFromSuperview];
            self.settingColorView = nil;
            
        }
        if(self.alphaValueSlider){
            [self.alphaValueSlider removeFromSuperview];
            self.alphaValueSlider = nil;
        }
        if (self.drawingSizeSlider) {
            [self.drawingSizeSlider removeFromSuperview];
            self.drawingSizeSlider = nil;
        }else{
            self.drawingSizeSlider = [UISlider new];
            self.drawerView.userInteractionEnabled = NO;
            self.drawingSizeSlider.value = self.drawingSize;
            //self.drawingSizeSlider.backgroundColor = [UIColor yellowColor];
            self.drawingSizeSlider.transform = CGAffineTransformMakeRotation(M_PI*0.5);
            //左边的图片, 轨迹图  Track:轨迹
            [self.drawingSizeSlider setMinimumTrackImage:[UIImage imageNamed:@"bg-act.png"] forState:UIControlStateNormal];
            //右边轨迹图
            [self.drawingSizeSlider setMaximumTrackImage:[self imagesNamedFromCustomBundle:@"bg.png"] forState:UIControlStateNormal];
            //设置调节按钮图
            [self.drawingSizeSlider setThumbImage:[self imagesNamedFromCustomBundle:@"dot.png"] forState:UIControlStateNormal];
           
            
            [self.view addSubview:self.drawingSizeSlider];
            UIButton *btn = [(UIButton*)self.settingView viewWithTag:205];
            [self.drawingSizeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(btn.mas_centerX).mas_equalTo(0);
                make.bottom.mas_equalTo(btn.mas_top).mas_equalTo(-30-(SETTINGVIEW_HEIGHT - SETTINGVIEW_ICON)/2);
                make.size.mas_equalTo(CGSizeMake(120, 60));
                
            }];
            [self.drawingSizeSlider addTarget:self action:@selector(drawingSizeChange:) forControlEvents:UIControlEventValueChanged];
            [self.drawingSizeSlider addTarget:self action:@selector(drawingSizeChangeEnd:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}
-(void)drawingSizeChange:(id)sender{
     UISlider *slider = (UISlider*)sender;
     self.drawingSize = slider.value ;
    self.drawerView.lineWidth = self.drawingSize *20;
    self.showView.radius = self.drawingSize*10;
    [self.showView setNeedsDisplay];

}
-(void)drawingSizeChangeEnd:(id)sender{
    self.drawerView.userInteractionEnabled = YES;
    [self.drawingSizeSlider removeFromSuperview];
     self.drawingSizeSlider = nil;

}

-(void)alphaChange:(id)sender{
    [(UIButton*)[self.settingView viewWithTag:201] setImage:[self imagesNamedFromCustomBundle:@"Eraser.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.settingView viewWithTag:202] setImage:[self imagesNamedFromCustomBundle:@"brush-act.png"] forState:UIControlStateNormal];
    UISlider *slider = (UISlider*)sender;
    self.alphaValue = slider.value;
    self.alphaValueSlider.value = self.alphaValue;
    self.selectedColor = [self.tempColor colorWithAlphaComponent:self.alphaValue];
    self.showView.selectColor = self.selectedColor;
     [self.showView setNeedsDisplay];
    [self.drawerView setLineColor:self.selectedColor];

}
-(void)alphaChangeEnd:(id)sender{
    self.drawerView.userInteractionEnabled = YES;
    [self.alphaValueSlider removeFromSuperview];
    self.alphaValueSlider = nil;
}
-(void)selectColor:(id)sender{

    [self.drawerView setLineColor:self.selectedColor];
    self.drawerView.userInteractionEnabled = YES;
    [(UIButton*)[self.settingView viewWithTag:201] setImage:[self imagesNamedFromCustomBundle:@"Eraser.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.settingView viewWithTag:202] setImage:[self imagesNamedFromCustomBundle:@"brush-act.png"] forState:UIControlStateNormal];
    UIButton *btn = (UIButton*)sender;
    self.tempColor = btn.backgroundColor;
    self.selectedColor = [self.tempColor colorWithAlphaComponent:self.alphaValue];
    self.showView.selectColor = self.selectedColor;
    [self.showView setNeedsDisplay];
    [self.drawerView setLineColor:self.selectedColor];
    [self.settingColorView removeFromSuperview];
     self.settingColorView = nil;
}



- (void)saveButtonPressed
{
    UIImage *frontImage = [self convertViewToImage:self.drawerView];
    CGSize size = [self OriginImage:self.backGroundImage Width:self.view.bounds.size.width Height:self.view.bounds.size.height-BOTTOWVIEW_HEIGHT-SETTINGVIEW_HEIGHT];
    UIImage *bottomImage = [self OriginImage:self.backGroundImage scaleToSize:size];
    UIImage *image = [self overlay:bottomImage andImage:frontImage];
    NSString *saveImagePath = [self saveImage:image quality:1.0 usePng:YES];
    NSString *str = [NSString stringWithFormat:@"%@",saveImagePath];
    NSDictionary *dic = @{@"savePath":str};
    NSString *jsonStr = [dic JSONFragment];
    NSString *jsString = [NSString stringWithFormat:@"uexScrawl.cbSave('%@');",jsonStr];
    [EUtility brwView:self.meBrwView evaluateScript:jsString];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGSize)OriginImage:(UIImage *)image Width:(CGFloat)drawWidth Height:(CGFloat)drawHeight {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    NSDecimalNumber *drawWidthNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",drawWidth]];
    NSDecimalNumber *drawHeightNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",drawHeight]];
    NSDecimalNumber *widthNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",width]];
    NSDecimalNumber *heightNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",height]];

    if (width > height) {
        
        NSDecimalNumber *ratioNumber = [drawWidthNumber decimalNumberByDividingBy:widthNumber];
        NSDecimalNumber *height1Number = [ratioNumber decimalNumberByMultiplyingBy:heightNumber];
        //CGFloat ratio1 = drawWidth/width;
        //CGFloat height1 = height*ratio1;
        return CGSizeMake(drawWidth, [height1Number floatValue]);
    }else{
        NSDecimalNumber *ratioNumber = [drawHeightNumber decimalNumberByDividingBy:heightNumber];
        NSDecimalNumber *width1Number = [ratioNumber decimalNumberByMultiplyingBy:widthNumber];
        //CGFloat ratio1 = drawHeight/height;
        //CGFloat width1 = width*ratio1;
        return CGSizeMake([width1Number floatValue], drawHeight);
    }
    
    return CGSizeZero;
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage; //返回的就是已经改变的图片
}
-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage*)overlay:(UIImage *)bottomImage andImage:(UIImage*)frontImage{
    CGSize finalSize = [bottomImage size];
    CGSize hatSize = [frontImage size];
    UIGraphicsBeginImageContext(finalSize);
    [bottomImage drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    [frontImage drawInRect:CGRectMake(0,0,hatSize.width,hatSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
                         
}

// save to disc
- (NSString *)getSaveDirPath{
    NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/apps"];
    NSString *wgtTempPath=[tempPath stringByAppendingPathComponent:[EUtility brwViewWidgetId:self.meBrwView]];
    
    return [wgtTempPath stringByAppendingPathComponent:@"uexScrawl"];
}
- (NSString *)saveImage:(UIImage *)image quality:(CGFloat)quality usePng:(BOOL)usePng{
    NSData *imageData;
    NSString *imageSuffix;
    
    
    if(usePng){
        imageData=UIImagePNGRepresentation(image);
        imageSuffix=@"png";
    }else{
        imageData=UIImageJPEGRepresentation(image, quality);
        imageSuffix=@"jpg";
    }
    
    
    if(!imageData) return nil;
    
    NSFileManager *fmanager = [NSFileManager defaultManager];
    
    NSString *uexImageSaveDir=[self getSaveDirPath];
    if (![fmanager fileExistsAtPath:uexImageSaveDir]) {
        [fmanager createDirectoryAtPath:uexImageSaveDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
    NSString *imgName = [NSString stringWithFormat:@"%@.%@",[timeStr substringFromIndex:([timeStr length]-6)],imageSuffix];
    NSString *imgTmpPath = [uexImageSaveDir stringByAppendingPathComponent:imgName];
    if ([fmanager fileExistsAtPath:imgTmpPath]) {
        [fmanager removeItemAtPath:imgTmpPath error:nil];
    }
    if([imageData writeToFile:imgTmpPath atomically:YES]){
        return imgTmpPath;
    }else{
        return nil;
    }
    
}
- (BOOL)shouldAutorotate{
    return NO;
}
@end
