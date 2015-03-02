//
//  APPInitObject.m
//  NewsBrowser
//
//  Created by Ethan on 13-11-22.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "APPInitObject.h"
#import "Config.h"
@implementation APPInitObject
+(APPInitObject *)share
{
    static APPInitObject * _APPInitObject_Share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _APPInitObject_Share=[[APPInitObject alloc] init];
    });
    return _APPInitObject_Share;
}
-(id)init
{
    if (self=[super init]) {
        self.loading=[[LoadingInfo alloc] init];
        self.version=[[VersionInfo alloc] init];
    }
    return self;
}
-(void)initWithJsonString:(NSDictionary *)json
{
    if (json==nil) {
        return;
    }

    NSDictionary *postList=[json objectForKey:@"postList"];
    self.postListHandlerJSURL=[postList objectForKey:@"handlerJSURL"];
    self.postListIndex=[[postList objectForKey:@"index"] intValue];
    self.postListID=[postList objectForKey:@"id"];
    self.postListClass=[postList objectForKey:@"class"];
    
    
   
    self.loading.version=[[json objectForKey:@"loading"] objectForKey:@"version"];
    self.loading.link=[[json objectForKey:@"loading"] objectForKey:@"link"];
    self.loading.img=[[json objectForKey:@"loading"] objectForKey:@"img"];


    self.version.version=[[json objectForKey:@"version"] objectForKey:@"version"];
    self.version.note=[[json objectForKey:@"version"] objectForKey:@"note"];
    self.version.URL=[[json objectForKey:@"version"] objectForKey:@"URL"];

    
    NSArray *categoryArray=[json objectForKey:@"categorys"];
    NSMutableArray *categorysTemp=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in categoryArray) {
        CategoryObject *catObj=[[CategoryObject alloc] init];
        catObj.categoryName=[dic objectForKey:@"categoryName"];
        catObj.categoryIsShow=[[dic objectForKey:@"categoryIsShow"] boolValue];
        catObj.categoryAccept=[dic objectForKey:@"categoryAccept"];
        catObj.categoryURL=[dic objectForKey:@"categoryURL"];
        catObj.categoryPostDic=[dic objectForKey:@"categoryPostDic"];
        catObj.categoryID=[[dic objectForKey:@"categoryID"] intValue];
        if (catObj.categoryIsShow) {
            [categorysTemp addObject:catObj];
        }
        
    }
    self.categorys=[NSArray arrayWithArray:categorysTemp];
    //显示的分类
    NSArray *categoryShowArr=[[Common readLocalString:k_categoryShowPath secondPath:k_categoryShowPath2] JSONValue];
    NSMutableArray *showTempArr=[[NSMutableArray alloc] init];
    for (int i=0; i<categoryShowArr.count; i++) {
        NSPredicate *filter=[NSPredicate predicateWithFormat:@"categoryID=%@",[categoryShowArr objectAtIndex:i]];
       [showTempArr addObjectsFromArray:[self.categorys filteredArrayUsingPredicate:filter]];
    }
    self.categorysShow=[NSArray arrayWithArray:showTempArr];
    NSPredicate *filter2=[NSPredicate predicateWithFormat:@" NOT (categoryID  in %@)",categoryShowArr];
    self.categoryHide=[self.categorys filteredArrayUsingPredicate:filter2];
    self.API=[json objectForKey:@"API"];
    
    [categorysTemp removeAllObjects];
    NSArray *indexCategory=[json objectForKey:@"indexs"];
    for (NSDictionary *dic in indexCategory) {
        CategoryObject *catObj=[[CategoryObject alloc] init];
        catObj.categoryName=[dic objectForKey:@"categoryName"];
        catObj.categoryIsShow=[[dic objectForKey:@"categoryIsShow"] boolValue];
        catObj.categoryAccept=[dic objectForKey:@"categoryAccept"];
        catObj.categoryURL=[dic objectForKey:@"categoryURL"];
        catObj.categoryPostDic=[dic objectForKey:@"categoryPostDic"];
        catObj.categoryID=[[dic objectForKey:@"categoryID"] intValue];
        if (catObj.categoryIsShow) {
            [categorysTemp addObject:catObj];
        }
        
    }
    self.indexsCategorys=[NSArray arrayWithArray:categorysTemp];

    
}
-(NSString *)APIForType:(APIType)type
{

    return [[self.API objectForKey:[self APIKeyForType:type]] objectForKey:@"api"];
}
-(NSDictionary *)XPathForType:(APIType)type
{
    return [[self.API objectForKey:[self APIKeyForType:type]] objectForKey:@"xpath"];
}
-(NSString *)APIKeyForType:(APIType)type
{
    NSString *key=@"";
    switch (type) {
        case APIType_body:
            key=@"postBody";
            break;
        case APIType_comment:
            key=@"comment";
            break;
        case APIType_authors:
            key=@"authors";
            break;
        case APIType_searchauthor:
            key=@"searchauthor";
            break;
        case APIType_authorhome:
            key=@"authorhome";
            break;
        default:
            break;
    }

    return key;
}
@end
@implementation VersionInfo
@end
@implementation LoadingInfo
@end