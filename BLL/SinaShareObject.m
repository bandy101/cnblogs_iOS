//
//  SinaShareObject.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//
#define k_sinaUserInfo @"sinaUserInfo"

#import "SinaShareObject.h"
#import "SVProgressHUD.h"
@implementation SinaShareObject
+(SinaShareObject *)share
{
    static SinaShareObject *_share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share=[[SinaShareObject alloc] init];
    
    });
    return _share;
}
-(id)init
{
    if (self=[super init]) {
     
      
    }
    return self;
}
-(void)shareWithContent:(NSString *)conent pVC:(UIViewController *)pvc
{
    //读取已存在的用户
    self.userInfoArray=[[NSUserDefaults standardUserDefaults] arrayForKey:k_sinaUserInfo];
    self.content=conent;
    parentVC=pvc;
    if (self.userInfoArray.count>0)
    {
        [self showUserInfo];
    }
    else
    {
        [self showLoginView];
    }
    
  
}
-(void)showUserInfo
{
 
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"选择分享账号"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                           destructiveButtonTitle:@"注销所有账号"
                                                otherButtonTitles: nil];
        for (NSDictionary *dic in self.userInfoArray)
        {
            [sheet addButtonWithTitle: [dic objectForKey:@"userName"]];
        }
        [sheet addButtonWithTitle: @"绑定其他账号"];
        [sheet setActionSheetStyle:UIActionSheetStyleDefault];
        [sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"取消"]];
        [sheet showInView:parentVC.view];
 

}
-(void)showLoginView
{
    if (sina==nil) {
        sina=[[SinaLogin alloc] init];
        sina.delegate=self;
    }
    [sina loginWithViewController:parentVC];
}
-(void)update:(NSString *)acctoken
{
    [SVProgressHUD showWithStatus:@"分享中..."];
    if (updateAPI) {
        updateAPI=nil;
    }
    updateAPI=[[SinaAPI_update alloc] initWithAccessToken:acctoken conent:self.content];
    updateAPI.delegate=self;
    [updateAPI startRequest];
}
#pragma 第三方登录成功
-(void)OAuthLogin:(OAuthLogin *)login success:(BOOL)success
{
  if (success)
  {
      BOOL has=NO;
      NSMutableArray *array=[[NSMutableArray alloc] init];
      for (int i=0; i<self.userInfoArray.count; i++) {
          NSDictionary *dic=[self.userInfoArray objectAtIndex:i];
          if ([[dic objectForKey:@"UID"] intValue]==[login.userID intValue]) {
              //更新
              has=YES;
              NSDictionary *newDic=[NSDictionary dictionaryWithObjectsAndKeys:login.userID,@"UID",
                                    login.userName,@"userName",
                                    login.accessToken,@"accessToken",
                                    login.expirationDate,@"expirationDate",
                                    nil];
              [array addObject:newDic];
          }
          else
          {
              [array addObject:dic];
          }
      }
      if (!has)
      {
          NSDictionary *newDic=[NSDictionary dictionaryWithObjectsAndKeys:login.userID,@"UID",
                                login.userName,@"userName",
                                login.accessToken,@"accessToken",
                                login.expirationDate,@"expirationDate",
                                nil];
          [array addObject:newDic];

      }
      [[NSUserDefaults standardUserDefaults] setObject:array forKey:k_sinaUserInfo];
      [self update:login.accessToken];
      
  }

}
#pragma API接口
-(void)SinaAPIRequest:(SinaAPIRequestBase *)reqeust success:(BOOL)success result:(NSDictionary *)resultDic
{
   if(reqeust.type==SinaAPIType_post)
    {
        if (success)
        {
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        }
        else
        {
            NSString *error=@"分享失败";
            if (resultDic) {
                error=[resultDic objectForKey:@"error"];
            }
            [SVProgressHUD showErrorWithStatus:error];
        }
    }
}
#pragma actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==actionSheet.cancelButtonIndex)
    {
    }
    else if(buttonIndex==actionSheet.destructiveButtonIndex)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_sinaUserInfo];
    }
    else if(buttonIndex>self.userInfoArray.count)
    {
        [self showLoginView];
    }
    else
    {
        NSDictionary *dic=[self.userInfoArray objectAtIndex:buttonIndex-1];
        [self update:[dic objectForKey:@"accessToken"]];
    }
}
@end
