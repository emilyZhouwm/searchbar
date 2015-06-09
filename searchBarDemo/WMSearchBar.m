//
//  GRESearchBar.m
//  gre3K
//
//  Created by zwm on 14-7-22.
//  Copyright (c) 2014年 zwm. All rights reserved.
//

#import "WMSearchBar.h"

#define kSearchBorderW 0// 15

@interface WMSearchBar () <UITextFieldDelegate>
{
    UITextField *_textField;
}
@end

@implementation WMSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kSearchBorderW, kSearchBorderH,
                                                                   CGRectGetWidth(self.frame) - kSearchBorderW - kCancelBtnW, kSearchH)];
        
        _textField.backgroundColor = kSearchBackColor;
        
        _textField.layer.borderColor = kSearchBordColor.CGColor;
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = kSearchH *0.5;
        
        _textField.placeholder = @"Search";
        _textField.textColor = kSearchTextColor;
        _textField.font = kSearchFont;
        
        _textField.delegate = self;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.returnKeyType = UIReturnKeySearch;
        //_textField.keyboardType
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kSearchIconLeft, 0, kSearchIconWH, kSearchIconWH)];
        [iconView setImage:kSearchIconImg];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSearchIconWH + kSearchIconLeft + kSearchIconRight, kSearchIconWH)];
        leftView.backgroundColor = [UIColor clearColor];
        [leftView addSubview:iconView];
        
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - kCancelBtnW, 0,
                                                                         kCancelBtnW, CGRectGetHeight(self.frame))];
        [cancelBtn setTitleColor:kSearchTextColor forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:kCancelBtnFont];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
    }
    return self;
}

- (NSString *)getText
{
    return _textField.text;
}

#pragma mark - private
- (BOOL)becomeFirstResponder
{
    [_textField becomeFirstResponder];
    if (_textField.text.length > 0) {
        [self textFieldDidChange:self];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [_textField resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark - click
- (void)cancelBtnClick:(UIButton *)sender
{
    [_textField resignFirstResponder];
    if (self.delegate) {
        [self.delegate searchBarCancel];
    }
}

- (void)textFieldDidChange:(id)sender
{
    // 是否实时搜索
    if (self.delegate && !_noRealTime) {
        NSString *text = _textField.text;
        [self.delegate searchBar:self textDidChange:text];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate) {
        [self.delegate searchBarTextDidEndEditing];
    }
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate) {
        [self.delegate searchBarTextDidBeginEditing];
    }
}

// 是否要过滤某些输入
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
*/

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate != nil && !_noRealTime) {
        _textField.text = @"";
        [self.delegate searchBar:self textDidChange:@""];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.delegate != nil) {
        NSString *text = _textField.text;
        [self.delegate searchBar:self textDidChange:text];
    }
    [_textField resignFirstResponder];
    return YES;
}

@end
