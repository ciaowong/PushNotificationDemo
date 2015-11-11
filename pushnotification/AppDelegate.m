//
//  AppDelegate.m
//  pushnotification
//
//  Created by Awesome on 15/11/10.
//  Copyright © 2015年 Awesome. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //推送通知设置
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
    }

    
    return YES;
}

//这个千万记得加
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //注册远程通知
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
    
    //tokenStr 得到可用的token。
    NSString *tokenStr = [NSString stringWithFormat:@"%@",pToken];
    tokenStr = [tokenStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];//将其中的<>去掉
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];//将其中的空格去掉
    
    //注册成功，返回token
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"APNS返回的Token:" message:tokenStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    NSLog(@"返回Token--%@", pToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //将推送消息以alert形式呈现
    NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString *tokenStr = [NSString stringWithFormat:@"%@",error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败!" message:tokenStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    NSLog(@"注册失败%@",error);
}

@end
