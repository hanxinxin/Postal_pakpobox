//
//  LoginNextViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LoginNextViewController.h"
#import "PostmanViewController.h"

#import "JZTouchIDManager.h"

@interface LoginNextViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,JZTouchIDManagerDelegate>

@property (nonatomic,strong)JZTouchIDManager * IDManager;
@end

@implementation LoginNextViewController
@synthesize  IDManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.NameField.layer.borderColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0].CGColor;
    self.NameField.layer.borderWidth = 1;
    self.NameField.layer.cornerRadius = 20;
    self.NameField.keyboardType = UIKeyboardTypeASCIICapable;
    self.NameField.delegate=self;
    self.PasswordField.layer.borderColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0].CGColor;
    self.PasswordField.layer.borderWidth = 1;
    self.PasswordField.layer.cornerRadius = 20;
    self.PasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.PasswordField.delegate=self;
    self.PasswordField.secureTextEntry = YES;
    self.LoginBtn.layer.cornerRadius = 25;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
    [self.view addGestureRecognizer:tapGesture];
    IDManager = [JZTouchIDManager shareManager];
    IDManager.delegate = self;
    [self addNoticeForKeyboard];
    NSString * phoneN = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString * TouchIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"TouchID"];
    NSLog(@"打印===  %@,%@",phoneN,TouchIDStr);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if(![phoneN isEqualToString:@"1"] && ![TouchIDStr isEqualToString:@"1"])
        {
            [self->IDManager openTouchId:NO];
            
        }
        self.view.frame = [UIScreen mainScreen].bounds;
    });
    
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    [self.navigationController.navigationBar setHidden:YES];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

//    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    if (@available(iOS 13.0, *)) {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    NSString * phoneN = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString * TouchIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"TouchID"];
        if(![phoneN isEqualToString:@"1"] && ![TouchIDStr isEqualToString:@"1"])
        {
            self.NameField.text = @"user";
            self.PasswordField.text = @"123456";
        }
    [super viewWillAppear:animated];
}
//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
////    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
////        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
////    }
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    //    [backBtn setTintColor:[UIColor blackColor]];
//    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
//    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1]];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    };
//    [super viewWillDisappear:animated];
//}
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
    NSLog(@"Float = %f",(self.LoginBtn.top+self.LoginBtn.height+kbHeight));
    CGFloat offset = (self.LoginBtn.top+self.LoginBtn.height+kbHeight) - (SCREEN_HEIGHT);
    
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
- (IBAction)LoginTouch:(id)sender {
    
//    if(self.logInt==1) ///投递员
//    {
//        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        PostmanViewController * VC=[main instantiateViewControllerWithIdentifier:@"PostmanViewController"];
////        self.navigationController.view.window.rootViewController=VC;
//        [self.navigationController pushViewController:VC animated:YES];
//    }else if (self.logInt==2)///取件员
//    {
    
//    }
    if(self.NameField.text.length>0 && self.PasswordField.text.length>0)
    {
        if([self.NameField.text isEqualToString:@"user"])
        {
            if([self.PasswordField.text isEqualToString:@"123456"])
            {
                NSString * phoneN = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
                NSString * TouchIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"TouchID"];
                if([phoneN isEqualToString:@"user"] && [TouchIDStr isEqualToString:@"2"])
                {
                    [self pushView];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"user" forKey:@"phoneNumber"];
                    [self addalt:@"Would you like to enable Touch ID/Face ID for this application?"];
                }
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Password mistake", @"Language") andDelay:2.5];
            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Account name error", @"Language") andDelay:2.5];
        }
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Please enter your account and password", @"Language") andDelay:2.0];
    }

//    [userDefaults setObject:@"1" forKey:@"phoneNumber"];
}

-(void)TouchVerify:(NSInteger)touch_YN
{
    if(touch_YN==0)
    {
        NSLog(@"touch_YN=  %ld  ",(long)touch_YN);
    }else if(touch_YN==1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"TouchID"];
//        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        BarViewController*VC=[main instantiateViewControllerWithIdentifier:@"BarViewController"];
//        self.navigationController.view.window.rootViewController=VC;
        [self pushView];
    }else if(touch_YN==5)
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"You haven't set it yet Touch ID", @"Language") andDelay:2.5];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
           [self pushView];
            
        });
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TouchID"];
    }else if(touch_YN==10)
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Touch ID Do not use", @"Language") andDelay:2.5];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TouchID"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self pushView];
            
        });
    }
}
-(void)addalt:(NSString *)tipsStr
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Enable Touch ID/Face ID?" message:tipsStr preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"Enable" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self->IDManager openTouchId:NO];
    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"Not Now" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TouchID"];
        [self pushView];
    }];
    
    
    [alertC addAction:alertB];
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)pushView
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.VC=[main instantiateViewControllerWithIdentifier:@"BarViewController"];
    self.navigationController.view.window.rootViewController=self.VC;
}

@end
