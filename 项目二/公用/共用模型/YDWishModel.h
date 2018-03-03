//
//  YDWishModel.h
//  ClickToHelp
//
//  Created by rimi on 16/11/5.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDWishModel : NSObject

@property (nonatomic,copy) NSString * wish_id;           //愿望的id
@property (nonatomic,copy) NSString * wish_title;        //愿望的标题
@property (nonatomic,copy) NSString * wish_desc;         //愿望的描述
@property (nonatomic,copy) NSString * wish_price;        //愿望的金额
@property (nonatomic,copy) NSString * wish_end_time;     //愿望的结束时间
@property (nonatomic,copy) NSString * province;          //愿望发布省份
@property (nonatomic,copy) NSString * city;              //愿望发布城市
@property (nonatomic,copy) NSString * user_id;           //愿望发布人的id
@property (nonatomic,copy) NSString * user_nicename;     //愿望发布人的昵称
@property (nonatomic,copy) NSString * with_cat;          //愿望的分类（生活类 互助类等）
@property (nonatomic,copy) NSString * wish_type;         //愿望的类型（1.普通,2.预热）
@property (nonatomic,copy) NSString * wish_reward_price; //愿望目前的赏金
@property (nonatomic,copy) NSString * wish_reward_num;   //愿望目前的打赏人数
@property (nonatomic,copy) NSString * wish_add_time;     //愿望的发布时间
@property (nonatomic,copy) NSString * avatar;            //愿望发布人头像
@property (nonatomic,copy) NSString * is_favorites;      //是否收藏   1为收藏


@end
