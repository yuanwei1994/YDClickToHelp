//
//  YDRewardModel.h
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDRewardModel : NSObject

//@property (nonatomic,copy) NSString * reward_id;            //打赏记录id
@property (nonatomic,copy) NSString * price;                //打赏的金额
@property (nonatomic,copy) NSString * wish_id;              //愿望id
@property (nonatomic,copy) NSString * uid;                  //打赏的用户id
@property (nonatomic,copy) NSString * to_uid;               //被打赏的用户id
@property (nonatomic,copy) NSString * add_time;             //打赏的时间
@property (nonatomic,copy) NSString * avatar;               //打赏用户的头像
@property (nonatomic,copy) NSString * user_nicename;        //打赏用户的昵称
@property (nonatomic,copy) NSString * to_avatar;            //被打赏用户的头像
@property (nonatomic,copy) NSString * to_user_nicename;     //被打赏用户的昵称
@property (nonatomic,copy) NSString * wish_title;           //愿望标题


@end
