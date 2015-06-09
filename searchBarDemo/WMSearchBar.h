//
//  GRESearchBar.h
//  gre3K
//
//  Created by zwm on 14-7-22.
//  Copyright (c) 2014年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSearchBorderH 7
#define kSearchH 30

#define kSearchIconWH 16
#define kSearchIconImg [UIImage imageNamed:@"icon_search"]
#define kSearchIconLeft 17
#define kSearchIconRight 9

#define kSearchFont [UIFont systemFontOfSize:14]
#define kSearchBackColor [UIColor colorWithRed:(237)/255.0 green:(237)/255.0 blue:(237)/255.0 alpha:1]
#define kSearchBordColor [UIColor colorWithRed:(221)/255.0 green:(221)/255.0 blue:(221)/255.0 alpha:1]
#define kSearchTextColor [UIColor colorWithRed:(0)/255.0 green:(206)/255.0 blue:(13)/255.0 alpha:1]

#define kCancelBtnW 64
#define kCancelBtnFont [UIFont systemFontOfSize:17]

@class WMSearchBar;
@protocol WMSearchBarDelegate <NSObject>

@required

- (void)searchBar:(WMSearchBar *)searchBar textDidChange:(NSString *)searchText;

- (void)searchBarTextDidEndEditing;
- (void)searchBarTextDidBeginEditing;

- (void)searchBarCancel;

@end

@interface WMSearchBar : UIView

@property (nonatomic, assign) id<WMSearchBarDelegate> delegate;
@property (nonatomic, assign) BOOL noRealTime;

- (NSString *)getText;

@end
