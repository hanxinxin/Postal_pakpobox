//
//  PostmanViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PostmanViewController.h"
#import "PostmanNextViewController.h"
@interface PostmanViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@end

@implementation PostmanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Drop Off Packet";
//    self.navigationController.navigationBar.translucent = NO;
    self.DispenserField.layer.borderColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0].CGColor;
    self.DispenserField.layer.borderWidth = 1;
    self.DispenserField.layer.cornerRadius = 20;
    self.DispenserField.delegate=self;
    self.PacketNoField.layer.borderColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0].CGColor;
    self.PacketNoField.layer.borderWidth = 1;
    self.PacketNoField.layer.cornerRadius = 20;
    self.PacketNoField.delegate=self;
    self.NextBtn.layer.cornerRadius = 25;
    self.logoutBtn.layer.cornerRadius = 25;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
    [self.view addGestureRecognizer:tapGesture];
    [self addNoticeForKeyboard];
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    self.navigationItem.hidesBackButton = YES; ///隐藏返回按钮
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //    获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.logoutBtn.top+self.logoutBtn.height+kbHeight) - (SCREEN_HEIGHT);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = [UIScreen mainScreen].bounds;
    }];
}

- (IBAction)NextTouch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PostmanNextViewController * VC=[main instantiateViewControllerWithIdentifier:@"PostmanNextViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)LogoutTouch:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
