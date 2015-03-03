//
//  SlideFrameViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-4.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "SlideFrameViewController.h"
@interface SlideFrameViewController ()
{
    //-------------------------
    //框架数据
    UIViewController *currentVC;
    int currentIndex;
    UIViewController *_willShowCTR;
    float showTime;
    float autoShowDistance;
    //-------------------------
    //业务数据
    RESideMenu *sideMenuVC;
    PostShowViewController *postVC;
    UINavigationController *postNavVC;
    CommentViewController *commVC;
    UINavigationController *commNavVC;
    UINavigationController *containerNavVC;
    IndexSlideViewController *indexListVC;
    IndexSlideViewController *categoryListVC;
    FavAuthorsViewController *favAuthorVC;
    UIButton *showmenuBtn;
    AuthorsListViewController *authorsListVC;
    UINavigationController *authorsListNavVC;
    AuthorHomeViewController *authorHomeVC;
    UINavigationController *authorHomeNavVC;
    FavPostViewController *favPostVC;
    AboutViewController *aboutVC;
    CagtegorySortViewController *categorySortVC;
    UINavigationController *categorySortNavVC;
    
}
@end

@implementation SlideFrameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showTime=0.5;
    autoShowDistance=80;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizedBase:)];
    //首页
	indexListVC=[[IndexSlideViewController alloc] initWithIsIndex:YES];
    containerNavVC=[[UINavigationController alloc] initWithRootViewController:indexListVC];
    LeftMenuViewController *leftMenuVC=[[LeftMenuViewController alloc] init];
    leftMenuVC.delegate=self;
    sideMenuVC=[[RESideMenu alloc] initWithContentViewController:containerNavVC
                                                          menuViewController:leftMenuVC];
    sideMenuVC.backgroundImage = [UIImage imageNamed:@"menubg.png"];
    sideMenuVC.delegate=self;
    //[sideMenuVC.view setBackgroundColor:[UIColor redColor]];
    sideMenuVC.parallaxEnabled=NO;
    //菜单缩放
    sideMenuVC.menuViewScaleValue=1.0f;
    sideMenuVC.menuViewAlphaChangeable=NO;
    //菜单背景缩放
    sideMenuVC.scaleBackgroundImageView=NO;
    if ([Common IOSVersion]<7.0) {
        sideMenuVC.scaleContentView=NO;
    }
    [self addChildViewController:sideMenuVC];
    [self.view addSubview:sideMenuVC.view];
    [self changeCurrentVC:sideMenuVC fromVC:nil];
    
    //分类列表
    categoryListVC=[[IndexSlideViewController alloc] initWithIsIndex:NO];
    categoryListVC.delegate=self;
   
    //详细页
    postVC=[[PostShowViewController alloc] init];
    postVC.delegate=self;
    postNavVC=[[UINavigationController alloc] initWithRootViewController:postVC];
    [self addChildViewController:postNavVC];
    //评论
    commVC=[[CommentViewController alloc] init];
    commVC.delegate=self;
    commNavVC=[[UINavigationController alloc] initWithRootViewController:commVC];
    [self addChildViewController:commNavVC];
    postVC.rightVC=commNavVC;
    
    // 其他页
    //订阅作者
    favAuthorVC=[[FavAuthorsViewController alloc] init];
    favAuthorVC.delegate=self;
    showmenuBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    [showmenuBtn setBackgroundImage:[UIImage imageNamed:@"top_navigation_menuicon.png"] forState:UIControlStateNormal];
    [showmenuBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    containerNavVC.topViewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:showmenuBtn];
    //作者列表
    authorsListVC=[[AuthorsListViewController alloc] init];
    authorsListVC.sliderFrameVC=self;
    authorsListVC.delegate=self;
    authorsListNavVC=[[UINavigationController alloc] initWithRootViewController:authorsListVC];
    [self addChildViewController:authorsListNavVC];
    //作者主页
    authorHomeVC=[[AuthorHomeViewController alloc] init];
    authorHomeVC.delegate=self;
    authorHomeNavVC=[[UINavigationController alloc] initWithRootViewController:authorHomeVC];
    [self addChildViewController:authorHomeNavVC];
    //收藏
    favPostVC=[[FavPostViewController alloc] init];
    favPostVC.delegate=self;
    //关于
    aboutVC=[[AboutViewController alloc] init];
    //分类排序
    categorySortVC=[[CagtegorySortViewController alloc] init];
    categorySortVC.delegate=self;
    categorySortNavVC=[[UINavigationController alloc] initWithRootViewController:categorySortVC];
    [self addChildViewController:categorySortNavVC];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showLeftMenu
{
    [sideMenuVC presentMenuViewController];
}

#pragma -
#pragma leftmenu selected deleage
-(void)leftMenuChangeSelected:(int)index
{
    switch (index) {
        case 0:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:indexListVC, nil];
            break;
        case 1:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:categoryListVC, nil];
            break;
        case 2:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:favAuthorVC, nil];
            break;
        case 3:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:favPostVC, nil];
            break;
        case 4:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:[[LoginViewController alloc] init], nil];
            break;
        case 5:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:aboutVC, nil];
            break;
        
        default:
            break;
    }
    containerNavVC.topViewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:showmenuBtn];    
}
#pragma category index delegate
//显示分类排序
-(void)indexSliderViewShowCategorySort
{
    
    [self switchShowViewContrller:categorySortNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
   

}
//分类返回
-(void)categorySortGoBack:(BOOL)changed
{

    [self switchShowViewContrller:sideMenuVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
 
    if (changed) {
        [categoryListVC reset];
    }

}
#pragma listView Delegate
//从普通列表页到内容页
-(void)listViewContoller:(ListViewController *)listVCT selectedPostObject:(PostObject *)postObj
{
    
    [postVC setPostObj:postObj];
    [commVC setPostObj:postObj];
    [postNavVC.view setFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self switchShowViewContrller:postNavVC
              fromViewController:currentVC
                        duration:showTime
                       showRight:YES];

}
#pragma postview delegate
//从内容页返回
-(void)postShowViewControllerBack:(PostShowViewController *)_postVC
{
    
    [self switchShowViewContrller:_postVC.leftVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
    if (_postVC.leftVC==sideMenuVC) {
        _postVC.leftVC=nil;
    }
    
}
//从从容页到评论页
-(void)postShowViewControllerComment:(PostShowViewController *)postVC
{
    [self switchShowViewContrller:commNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
}
//从内容页到作者首页
-(void)postShowAuthorHome:(AuthorObject *)author
{
    authorHomeVC.isFromPost=YES;
    [authorHomeVC setAuthorObj:author];
    [self switchShowViewContrller:authorHomeNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];


}
#pragma commview delegate
//从评论页返回内容页
-(void)commentViewControllerBack:(CommentViewController *)commVC
{
    [self switchShowViewContrller:postNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];

}
#pragma favauthorsView delegate
//打开所有作者页
-(void)showAuthorListView
{
    [self switchShowViewContrller:authorsListNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
}
//从关注页到作者页
-(void)showAuthorHomeView:(AuthorObject *)author
{
    authorHomeVC.isFromPost=NO;
    [authorHomeVC setAuthorObj:author];
    [self switchShowViewContrller:authorHomeNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];

}
#pragma authorlistview delegate
//作者列表页返回
-(void)authorListGoBack
{
    [self switchShowViewContrller:sideMenuVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
}
#pragma authorHomeview delegate
//作者主页返回
-(void)authorHomeGoBack
{
    
    [self switchShowViewContrller:authorHomeVC.leftVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
    postVC.isFromAuthorHome=NO;
}
//作者主页到内容页
-(void)authorHome:(AuthorHomeViewController *)authorHome selectedPostObj:(PostObject *)postObj
{
    [postVC setPostObj:postObj];

    if(postVC.leftVC==nil||postVC.leftVC==authorHomeNavVC)
    {
        postVC.isFromAuthorHome=YES;
       
    }
    else
    {
         postVC.isFromAuthorHome=NO;
         
    }
    
    [commVC setPostObj:postObj];
    [postNavVC.view setFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self switchShowViewContrller:postNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:authorHome.leftVC==postNavVC?NO:YES];
}
#pragma favpostview delegate
//收藏页到内容页
-(void)favPostView:(FavPostViewController *)favPVC selectedPostObject:(PostObject *)postObj
{
    [postVC setPostObj:postObj];
    [commVC setPostObj:postObj];

    [self switchShowViewContrller:postNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
}
#pragma -
#pragma 框架方法

-(void)addPanGesture
{

    [self.view addGestureRecognizer:self.panGestureRecognizer];
}
-(void)removePanGesture
{
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
}
-(void)changeCurrentVC:(UIViewController *)vc fromVC:(UIViewController *)fr
{
    
    [self.view bringSubviewToFront:fr.view];
    if ([vc respondsToSelector:@selector(leftVC)]||[vc respondsToSelector:@selector(rightVC)])
    {
        [self addPanGesture];
        
    }
    else
    {
        [self removePanGesture];
    }
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        UIViewController *child=[(UINavigationController *)vc topViewController];
        if ([child respondsToSelector:@selector(leftVC)]||[child respondsToSelector:@selector(rightVC)])
        {
            [self addPanGesture];
        }
        else
        {
            [self removePanGesture];
        }
    }
    currentVC=vc;
    currentIndex=[self.childViewControllers indexOfObject:currentVC];
    
    
    //切换页面的逻辑处理
    //从内容页切换到其他页
    if (fr==postNavVC) {
        if (vc==sideMenuVC||(vc==authorHomeNavVC&&authorHomeVC.leftVC!=postNavVC)) {
            [postVC reset];
            [commVC reset];
        }
       
    }
    
    
    if (fr==authorHomeNavVC&&vc!=postNavVC) {
        [authorHomeVC reset];
        
    }

    if (vc==sideMenuVC) {
        [authorHomeVC reset];
        [postVC reset];
        [commVC reset];
    }
    
    
}


-(void)switchShowViewContrller:(UIViewController *)toVC
            fromViewController:(UIViewController *)fromVC
                      duration:(NSTimeInterval)duration
                     showRight:(BOOL)showRight//显示右边的VC
{
    toVC.view.layer.shadowColor=[UIColor blackColor].CGColor;
    toVC.view.layer.shadowOpacity = 0.7;
    // The Width and the Height of the shadow rect
    CGFloat rectWidth = 5.0;
    CGFloat rectHeight =  toVC.view.frame.size.height;
    // Creat the path of the shadow
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    // Move to the (0, 0) point
    CGPathMoveToPoint(shadowPath, NULL, 0.0, 0.0);
    // Add the Left and right rect
    CGPathAddRect(shadowPath, NULL, CGRectMake(0.0-rectWidth, 0.0, rectWidth, rectHeight));
    CGPathAddRect(shadowPath, NULL, CGRectMake( toVC.view.frame.size.width, 0.0, rectWidth, rectHeight));
    toVC.view.layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    if (duration==showTime) {
        //根据动画时间确定是否非手势
        toVC.view.center=CGPointMake(self.view.frame.size.width*(showRight?1.5:-1), fromVC.view.center.y);
    }

    [self transitionFromViewController:fromVC
                      toViewController:toVC
                              duration:duration
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                fromVC.view.center=CGPointMake(self.view.center.x*(showRight?-1:1.5), fromVC.view.center.y);
                                toVC.view.center=CGPointMake(self.view.center.x, toVC.view.center.y);
                                
                            } completion:^(BOOL finished) {
                                toVC.view.layer.shadowColor=[UIColor clearColor].CGColor;
                                toVC.view.layer.shadowOpacity = 0.0;
                                toVC.view.layer.shadowPath=NULL;
                                [self changeCurrentVC:toVC fromVC:fromVC];
                            }];
    if (showRight)
    {
        BaseViewController *currentBaseVC=nil;
        if ([toVC isKindOfClass:[UINavigationController class]])
        {
            currentBaseVC=(BaseViewController *)[(UINavigationController *)toVC topViewController];
        }
       else
        {
            currentBaseVC=(BaseViewController *)toVC;
        }
        currentBaseVC.leftVC=fromVC;
             
    }
    
    
}

#pragma mark Gesture recognizer
-(void)panGestureRecognizedBase:(UIPanGestureRecognizer *)recognizer
{
    
    BOOL showRight=NO;
    BaseViewController *currentBaseVC=(BaseViewController *)currentVC;
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        currentBaseVC=(BaseViewController *)[(UINavigationController *)currentVC topViewController];
    }
    CGPoint point=[recognizer velocityInView:self.view];
    if (recognizer.state==UIGestureRecognizerStateBegan)
    {
       
        
    }
    if (recognizer.state==UIGestureRecognizerStateChanged)
    {
        if (self.view.center.x+point.x*0.01>self.view.bounds.size.width*0.5)
        {
            //向右滑动准备显示左边VC
            if (_willShowCTR) {
                if (_willShowCTR!=currentBaseVC.leftVC&&currentVC.view.frame.origin.x>0) {
                    [_willShowCTR.view removeFromSuperview];
                    _willShowCTR=nil;
                }
            }
            else
            {
                _willShowCTR=currentBaseVC.leftVC;
               
            }
            if (_willShowCTR.view.superview!=self.view) {
                [_willShowCTR.view setFrame:CGRectMake(-self.view.frame.size.width*0.5, 0, self.view.frame.size.width,self.view.frame.size.height)];
                [self.view addSubview:_willShowCTR.view];
                [self.view sendSubviewToBack:_willShowCTR.view];
                currentVC.view.layer.shadowColor=[UIColor blackColor].CGColor;
                currentVC.view.layer.shadowRadius=5.0;
                currentVC.view.layer.shadowOpacity = 0.7;
            }

            
        }
        if (self.view.center.x+point.x*0.01<self.view.bounds.size.width*0.5)
        {
           
            //向左滑动准备显示右边VC
            if (_willShowCTR) {
                if (_willShowCTR!=currentBaseVC.rightVC&&currentVC.view.frame.origin.x<0) {
                    [_willShowCTR.view removeFromSuperview];
                    _willShowCTR=nil;
                }
            }
            else
            {
                _willShowCTR=currentBaseVC.rightVC;
                
            }
            if (_willShowCTR.view.superview!=self.view) {
                [_willShowCTR.view setFrame:CGRectMake(self.view.frame.size.width*0.5, 0, self.view.frame.size.width,self.view.frame.size.height)];
                [self.view addSubview:_willShowCTR.view];
                [self.view sendSubviewToBack:_willShowCTR.view];
                currentVC.view.layer.shadowColor=[UIColor blackColor].CGColor;
                currentVC.view.layer.shadowRadius=5.0;
                currentVC.view.layer.shadowOpacity = 0.7;

            }

            
        }
        if (_willShowCTR)
        {
            [_willShowCTR.view setFrame:CGRectMake(_willShowCTR.view.frame.origin.x+point.x*0.01, 0, self.view.frame.size.width,self.view.frame.size.height)];
            [currentVC.view setFrame:CGRectMake(currentVC.view.frame.origin.x+point.x*0.01*2, 0, self.view.frame.size.width,self.view.frame.size.height)];

        }
  
        
    }
    if (recognizer.state==UIGestureRecognizerStateEnded) {
       
       
        if (_willShowCTR) {
            float distance=currentVC.view.center.x-currentVC.view.bounds.size.width*0.5;
           
            NSTimeInterval time=showTime*fabsf(distance)/self.view.bounds.size.width;
           
            if(fabsf(distance)>autoShowDistance)
            {
                showRight=distance>0?NO:YES;
                [self switchShowViewContrller:_willShowCTR
                           fromViewController:currentVC
                                     duration:time
                                    showRight:showRight];
               
              
            }
            else
            {
                showRight=distance>0?YES:NO;
                [self switchShowViewContrller:currentVC
                           fromViewController:_willShowCTR
                                     duration:time
                                    showRight:showRight];
            }
             _willShowCTR=nil;
        }
        
        
    }
    
    
}
@end
