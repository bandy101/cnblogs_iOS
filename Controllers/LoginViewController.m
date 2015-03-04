//
//  LoginViewController.m
//  NewsBrowser
//
//  Created by Ethan on 14-6-12.
//  Copyright (c) 2014年 Ethan. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "BlogAccountHandler.h"
#import "AFNetworking.h"

#define viewWidth 250
#define viewHeight 140
@interface LoginViewController ()

@end

@implementation LoginViewController{
    UILabel*lblUserInfo;
    UILabel*lblPwdInfo;
    UITextField*txtUserName;
    UITextField*txtPwd;
    
    UILabel*lblVail;
    UITextField*txtVail;
    UIImageView*imgVail;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSInteger left=(self.view.frame.size.width-viewWidth)/2;
        self.view.backgroundColor=[UIColor whiteColor];
        UIView*bacView=[[UIView alloc]initWithFrame:CGRectMake(left, 100, viewWidth, viewHeight)];
        bacView.layer.borderWidth=1;
        bacView.layer.cornerRadius=5;
        
        lblUserInfo=[[UILabel alloc] initWithFrame:CGRectMake(8, 8, 60, 25)];
        lblUserInfo.text=@"用户名";
        txtUserName=[[UITextField alloc]initWithFrame:CGRectMake(70, 8, 150, 25)];
        txtUserName.borderStyle = UITextBorderStyleRoundedRect;
        
        lblPwdInfo=[[UILabel alloc] initWithFrame:CGRectMake(8, 40, 60,25)];
        lblPwdInfo.text=@"密  码";
        txtPwd=[[UITextField alloc]initWithFrame:CGRectMake(70, 40, 150,25)];
        txtPwd.borderStyle = UITextBorderStyleRoundedRect;
        [txtPwd setSecureTextEntry:YES];
        
        lblVail=[[UILabel alloc] initWithFrame:CGRectMake(8, 72, 60, 25)];
        lblVail.text=@"验证码";
        txtVail=[[UITextField alloc]initWithFrame:CGRectMake(70, 72, 50, 25)];
        txtVail.borderStyle = UITextBorderStyleRoundedRect;
        imgVail=[[UIImageView alloc]initWithFrame:CGRectMake(125, 72, 50, 25)];
        lblVail.hidden=YES;
        txtVail.hidden=YES;
        imgVail.hidden=YES;
        
        
        UIButton*btnSubmit=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnSubmit.frame=CGRectMake((viewWidth-60)/2, 105, 60, 25);
        btnSubmit.layer.cornerRadius=5;
        [btnSubmit setTitle:@"登 陆" forState:UIControlStateNormal];
        [btnSubmit addTarget:self action:@selector(submit_click) forControlEvents:UIControlEventTouchUpInside];
        btnSubmit.layer.borderWidth=1;
        
//        UIButton*btnTest=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btnTest.frame=CGRectMake((viewWidth+70)/2, 105, 60, 25);
//        btnTest.layer.cornerRadius=5;
//        [btnTest setTitle:@"发评论" forState:UIControlStateNormal];
//        [btnTest addTarget:self action:@selector(text_Click) forControlEvents:UIControlEventTouchUpInside];
//        btnTest.layer.borderWidth=1;
        

        
        [bacView addSubview:lblUserInfo];
        [bacView addSubview:lblPwdInfo];
        [bacView addSubview:txtUserName];
        [bacView addSubview:txtPwd];
        [bacView addSubview:btnSubmit];
        //[bacView addSubview:btnTest];
        [bacView addSubview:lblVail];
        [bacView addSubview:txtVail];
        [bacView addSubview:imgVail];
        
        
        
        [self.view addSubview:bacView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([BlogAccountHandler shareBlogAccountHandlerInstance].IsLogin) {
        [[[UIAlertView alloc]initWithTitle:@"已经登录" message:@"您已登陆!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
        
    }else{
        [[BlogAccountHandler shareBlogAccountHandlerInstance] getPreLoginNecessary:^(NSDictionary *pre) {
            [self validateImg:pre];
        }];
        //此处跟验证码有关
    }
    
    
}

-(void)text_Click{
//http://www.cnblogs.com/bandy/p/4308010.html
    PostItem*item=[[PostItem alloc]init];
    item.blogApp=@"bandy";
    item.body=@"测试评论_SLEEPING2";
    item.parentCommentId=0;
    item.postId=4308010;
    [[BlogAccountHandler shareBlogAccountHandlerInstance]post:item callback:^(BOOL success, NSString *errormsg) {
        NSLog(@"%@%@",success?@"YES":@"NO",errormsg);
    }];
}


-(void)submit_click{
    if (txtUserName.text.length==0) {
        [[[UIAlertView alloc]initWithTitle:@"未填写" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
        [txtUserName becomeFirstResponder];
    }else if (txtPwd.text.length==0){
        [[[UIAlertView alloc]initWithTitle:@"未填写" message:@"请输入密码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
        [txtPwd becomeFirstResponder];
    }else{
        [SVProgressHUD showWithStatus:@"正在登陆"];
        [[BlogAccountHandler shareBlogAccountHandlerInstance] loginWith:txtUserName.text Pwd:txtPwd.text Validate:txtVail.text result:^(BOOL success, NSString *errorMsg, NSDictionary *loginNecessary) {
            if (success) {
                [[[UIAlertView alloc]initWithTitle:@"登陆成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"登陆失败" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                [self validateImg:loginNecessary];
            }
           [SVProgressHUD dismiss];
        }];
       
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)validateImg:(NSDictionary*)dict{
    if (dict==nil||[dict objectForKey:@"CaptchaCodeTextBox"]==nil) {
        txtVail.text=nil;
        lblVail.hidden=YES;
        txtVail.hidden=YES;
        imgVail.hidden=YES;
    }else{
        lblVail.hidden=NO;
        txtVail.hidden=NO;
        imgVail.hidden=NO;
        txtVail.text=nil;
        imgVail.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[dict objectForKey:@"CaptchaCodeTextBox"]]];
    }
    
}


@end
