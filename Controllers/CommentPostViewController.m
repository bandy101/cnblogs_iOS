//
//  CommentPostViewController.m
//  NewsBrowser
//
//  Created by Sampson on 15/3/4.
//  Copyright (c) 2015年 Ethan. All rights reserved.
//

#import "CommentPostViewController.h"
#import "BlogAccountHandler.h"

#define TAIL @"\n--[来自睡睡]"
@interface CommentPostViewController ()

@end

@implementation CommentPostViewController{
    UITextView*postView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    CGSize size=self.view.frame.size;
    float workSpaceHeight= self.view.bounds.size.height;
    float topnavHeight=k_navigationBarHeigh;
    if (![Common isIOS7]) {
        workSpaceHeight-=k_navigationBarHeigh;
        topnavHeight=0;
    }
    float vheight=(workSpaceHeight-topnavHeight)/3;
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(8, (workSpaceHeight-vheight)/2, (size.width-16), vheight)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=5;
    [self.view addSubview:view];
    
    postView=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, view.frame.size.width-10, view.frame.size.height-50)];
    postView.layer.borderWidth=1;
    postView.layer.cornerRadius=3;
    [view addSubview:postView];
    
    UIButton*submit=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    submit.frame=CGRectMake(view.frame.size.width-40, view.frame.size.height-40, 35,35);
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submit_click) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    BlogAccountHandler*handler=[BlogAccountHandler shareBlogAccountHandlerInstance];
    [handler IsLoginWithPopformcallback:^(BOOL success, NSString *errormsg) {
        
    }];
//    if (!handler.IsLogin) {
//        [[[UIAlertView alloc]initWithTitle:@"尚未登录" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//    }

}

-(void)submit_click{
    
    BlogAccountHandler*handler=[BlogAccountHandler shareBlogAccountHandlerInstance];
    [handler IsLoginWithPopformcallback:^(BOOL success, NSString *errormsg) {
        if (success) {
            if (!handler.IsLogin) {
                [[[UIAlertView alloc]initWithTitle:@"尚未登录" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }else if(postView.text.length==0){
                [[[UIAlertView alloc]initWithTitle:@"请填写内容" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }else if(postView.text.length+[TAIL length]>4000){
                [[[UIAlertView alloc]initWithTitle:@"内容超长" message:@"博客园要求评论的字数少于4000" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }else{
                PostItem*item=[[PostItem alloc]init];
                item.blogApp=self.postObj.authorID;
                item.body=[NSString stringWithFormat:@"%@%@",postView.text,TAIL];
                item.postId=[self.postObj.ID longValue];
                item.parentCommentId=0;
                [handler post:item callback:^(BOOL success, NSString *errormsg) {
                    if (success) {
                        if (self.delegate&&[self.delegate respondsToSelector:@selector(CommentPostViewControllerPostSuccess)])
                        {
                            postView.text=nil;
                            [self.delegate CommentPostViewControllerPostSuccess];
                            
                        }else{
                            [[[UIAlertView alloc]initWithTitle:@"提交成功" message:errormsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                            
                        }
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"提交失败" message:errormsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                    }
                }];
            }
        }
    }];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //如何阻止事件冒泡
    self.postObj=nil;
    self.view.hidden=YES;
}

-(void)hidden:(BOOL)hide{
    postView.text=nil;
    self.view.hidden=hide;
}

@end
