//
//  AppDelegate.m
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define sendNotification(key)  [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];//发送通知
//#define sendMessage(key)  [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];//发送通知

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o; //引用self
#define BuglyAppId @"2c01372a7d"

@import Firebase;
@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@property (strong,nonatomic)AFHTTPSessionManager *manager;
@end
NSString *const kGCMMessageIDKey = @"gcm.message_id";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    

    ///// 腾讯bugly bug追踪
    [Bugly startWithAppId:BuglyAppId];
    ////// 谷歌推送
    [FIRApp configure];
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    if (@available(iOS 10.0, *)) {
        if ([UNUserNotificationCenter class] != nil) {
            // iOS 10 or later
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
            UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
                 // ...
             }];
        } else {
            // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        }
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动
        
        [userDefaults setObject:@"1" forKey:@"YHToken"];
        [userDefaults setObject:@"1" forKey:@"phoneNumber"];
        [userDefaults setObject:@"1" forKey:@"TouchID"];
        //存到本地UserDefaults 里面
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLoad"];
    }else
    {
        //不是第一次启动
    }
    [application registerForRemoteNotifications];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //    NSLog(@"app  launchOptions =%@",launchOptions);
    if(launchOptions!=nil)
    {
        sendNotification(@"Messagenotification");//发送通知
    }
    if(userInfo!=nil)
    {
        sendNotification(@"Messagenotification");//发送通知
    }
    //设置全局状态栏字体颜色为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    return YES;
}
// With "FirebaseAppDelegateProxyEnabled": NO
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [FIRMessaging messaging].APNSToken = deviceToken;
    
    
    
    
}
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * tokenStr = [userDefaults objectForKey:@"YHToken"];
        if(!([tokenStr isEqualToString:fcmToken]))
        {
            NSLog(@"新token");
            
            [self Post_Message_Token:fcmToken];
        }
}
-(void)Post_Message_Token:(NSString *)token
{

    NSDictionary * dict =
    @{@"tokenValue":token
      };
    NSLog(@"上传 dict = %@",dict);
    
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manager.requestSerializer setTimeoutInterval:50];
    // 加上这行代码，https ssl 验证。
    //    [_manager setSecurityPolicy:[jiamiStr customSecurityPolicy]];
    [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    self.manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    
    [self.manager POST:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_token] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"token上传请求成功: %@",responseObject);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:@"YHToken"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Request timed out!", @"Language") andDelay:1.5];
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"NewPostal"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
#pragma mark ---- Google 推送  ----

// 如果在应用内展示通知 （如果不想在应用内展示，可以不实现这个方法）
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)){
//
//    // 展示
//    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
//
//    //    // 不展示
//    //    completionHandler(UNNotificationPresentationOptionNone);
//}

#pragma mark - UNUserNotificationCenterDelegate

/*
 此方法是新的用于响应远程推送通知的方法
 1.如果应用程序在后台，则通知到，点击查看，该方法自动执行
 2.如果应用程序在前台，则通知到，该方法自动执行
 3.如果应用程序被关闭，则通知到，点击查看，先执行didFinish方法，再执行该方法
 4.可以开启后台刷新数据的功能
 step1：点击target-->Capabilities-->Background Modes-->Remote Notification勾上
 step2：在给APNs服务器发送的要推送的信息中，添加一组字符串如：
 {"aps":{"content-available":"999","alert":"bbbbb.","badge":1}}
 其中content-availabel就是为了配合后台刷新而添加的内容，999可以随意定义
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    NSLog(@"userInfo =  %@", userInfo);
    NSDictionary * aps = [userInfo objectForKey:@"aps"];
    NSDictionary * alert = [aps objectForKey:@"alert"];
    NSString * body = [alert objectForKey:@"body"];
    NSString * title = [alert objectForKey:@"title"];
    NSLog(@"标题：%@ ， 内容：%@",title,body);
    //
    if (application.applicationState == UIApplicationStateActive) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //        [AGPushNoteView showWithNotificationMessage:title completion:^{
        //
        //        }];
        application.applicationIconBadgeNumber = 1;
        sendNotification(@"chanegeMessage_upadte");
        sendMessage(kRegisterMessage)
    }
    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
    else if (application.applicationState == UIApplicationStateInactive){
        //......
        //        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //        sendNotification(@"chanegeMessage_upadte");
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }else if (application.applicationState == UIApplicationStateBackground){
        //......
        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        sendNotification(@"chanegeMessage_upadte");
        sendMessage(kRegisterMessage)
        //        sendNotification(@"Messagenotification");//发送通知
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Print full message.
    NSLog(@"userInfo3 ====  %@", userInfo);
    //    app.applicationIconBadgeNumber = 0;
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:@"1" forKey:@"Message"];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        sendNotification(@"chanegeMessage_upadte");
        sendMessage(kRegisterMessage)
    }
    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        //......
        //        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //            sendNotification(@"chanegeMessage_upadte");
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        //......
        //        application.applicationIconBadgeNumber = 1;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"Message"];
        //            sendNotification(@"chanegeMessage_upadte");
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }else
    {
        sendNotification(@"Messagenotification");//发送通知
        sendMessage(kRegisterMessage)
    }
    
    completionHandler();
}


@end
