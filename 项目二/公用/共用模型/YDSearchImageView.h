//
//  YDSearchImageView.h
//  ClickToHelp
//
//  Created by rimi on 16/11/4.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YDSearchImageViewDelegate <NSObject>

-(void)pushViewController;

@end



@interface YDSearchImageView : UIImageView
@property (nonatomic,weak) id<YDSearchImageViewDelegate> delegate;
@end
