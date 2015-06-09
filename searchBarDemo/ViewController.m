//
//  ViewController.m
//  searchBarDemo
//
//  Created by zwm on 15/5/29.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "ViewController.h"
#import "WMSearchBar.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

@interface ViewController () <WMSearchBarDelegate>
{
    WMSearchBar *_searchBar;
    
    NSMutableArray *_cellInfo;
    NSMutableArray *_cellTemp;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomLayout;
@end

@implementation ViewController
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _searchBar = [[WMSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - 15, 44)];
    _searchBar.delegate = self;
    
    // 放navigationBar 要隐藏掉返回，并且推出推入的时候删除
    //[self.navigationController.navigationBar addSubview:_searchBar];
    
    // 放titleView 区域不好控制
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearView];
    NSLog(@"%@", self.navigationItem.leftBarButtonItem);
    self.navigationItem.titleView = _searchBar;
    
    _cellInfo = @[].mutableCopy;
    for (int i = 0; i < 1000; i++) {
        [_cellInfo addObject:[NSString stringWithFormat:@"%d", i]];
    }
    _cellTemp = _cellInfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WMSearchBarDelegate
- (void)searchBarCancel
{
    //[_searchBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        _cellTemp = @[].mutableCopy;
        for (NSString *word in _cellInfo) {
            if (([word rangeOfString:searchText].length != 0) ) {
                [_cellTemp addObject:word];
            }
        }
    } else {
        _cellTemp = _cellInfo;
    }
    [_tableView reloadData];
}

- (void)searchBarTextDidEndEditing
{
    _BottomLayout.constant = 0;
    [self.view layoutIfNeeded];
//    CGRect frame = _tableView.frame;
//    frame.size.height += kChineseKeyboardHeight;
//    [_tableView setFrame:frame];
}

- (void)searchBarTextDidBeginEditing
{
    _BottomLayout.constant = kChineseKeyboardHeight;
    [self.view layoutIfNeeded];
//    CGRect frame = _tableView.frame;
//    frame.size.height -= kChineseKeyboardHeight;
//    [_tableView setFrame:frame];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellTemp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _cellTemp[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    UIViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    detailVC.title = _cellTemp[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
