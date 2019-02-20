//
//  UGCBaseStrategyViewController.m
//  strategyDemo
//
//  Created by Courser on 2019/1/28.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyViewController.h"
#import "UGCBaseStrategyCell.h"
#import "UGCPicStrategyCell.h"
#import <ReactiveObjC.h>
#import "UGCBaseStrategyViewModel.h"
#import "UGCParseTool.h"
#import "UGCBaseStrategyTableView.h"

// test
#import "UGCFakeData.h"

@interface UGCBaseStrategyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UGCBaseStrategyTableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat keyboardOriginY;
@property (nonatomic, assign) BOOL keyboardShowed;
@property (nonatomic, assign) BOOL scrolled;
@property (nonatomic, assign) CGFloat scrollDistance;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UGCParseTool *parseTool;
@property (nonatomic, assign) BOOL isSorting;

// test
@property (nonatomic, strong) NSMutableArray <UGCBaseStrategyViewModel *>*dataSource;

@end

@implementation UGCBaseStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyboardShowed = NO;
    self.scrolled = NO;
    self.scrollDistance = 0;
    self.tableView = [[UGCBaseStrategyTableView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentSize = CGSizeMake(0, 10000);
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = self.tableFooterView;
    
    // iOS 11以后这样设置
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:self.tableView];
    
    [self setupNavigationBar];
    
    self.tableView.editing = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // fake data
    self.parseTool = [UGCParseTool new];
    self.dataSource = [self.parseTool blendDataSource:[UGCFakeData new].modelList].mutableCopy;
}

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPic)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(hideKeyboard)];
}

- (void)editMode {
    self.tableView.editing = !self.tableView.isEditing;
    if (self.tableView.isEditing) {
        self.dataSource = [self.parseTool splitDataSource:self.dataSource.copy].mutableCopy;
        [self.tableView reloadData];
    }else {
        self.dataSource = [self.parseTool blendDataSource:self.dataSource.copy].mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)addPic {
    UIImage *image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
    UGCBaseStrategyViewModel *viewModel = [self.dataSource objectAtIndex:self.currentIndex];
    if (viewModel.addPic) {
        viewModel.addPic(self.currentIndex, viewModel.selectedRange, image);
    }
}

- (void)hideKeyboard {
    [self.tableView endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    self.keyboardShowed = YES;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.tableView beginUpdates];
    CGRect footerViewFrame = self.tableFooterView.frame;
    footerViewFrame.size.height = rect.size.height;
    self.tableFooterView.frame = footerViewFrame;
    [self.tableView endUpdates];
    
    UGCBaseStrategyCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    
    __weak typeof(cell) weakCell = cell;
    cell.viewModel.getCursorRect = ^(CGRect cursorRect) {
        CGRect frame = [self.tableView convertRect:CGRectMake(weakCell.frame.origin.x, weakCell.frame.origin.y, weakCell.frame.size.width, cursorRect.origin.y + cursorRect.size.height) toView:[UIApplication sharedApplication].keyWindow];
        self.keyboardOriginY = rect.origin.y;
        if ((frame.origin.y + frame.size.height) > rect.origin.y) {
            self.scrolled = YES;
            CGPoint contentOffset = self.tableView.contentOffset;
            self.scrollDistance = frame.origin.y + frame.size.height - rect.origin.y;
            contentOffset.y += self.scrollDistance;
            [self.tableView setContentOffset:contentOffset animated:YES];
        }
        weakCell.viewModel.getCursorRect = nil;
    };
    
//    CGRect frame = [self.tableView convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    self.keyboardShowed = NO;
    if (self.scrolled) {
        self.scrolled = NO;
        if (self.scrollDistance != 0) {
            CGPoint contentOffset = self.tableView.contentOffset;
            contentOffset.y -= self.scrollDistance;
            [self.tableView setContentOffset:contentOffset animated:YES];
            self.scrollDistance = 0;
        }
        [self.tableView beginUpdates];
        self.tableFooterView.frame = CGRectZero;
        [self.tableView endUpdates];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSorting) {
        if ([self.dataSource objectAtIndex:indexPath.item].model.height > [self.dataSource objectAtIndex:indexPath.item].model.sortingHeight) {
            return [self.dataSource objectAtIndex:indexPath.item].model.sortingHeight;
        }else {
            return [self.dataSource objectAtIndex:indexPath.item].model.height;
        }
    }
    
    if (self.dataSource.count == 1 && [self.dataSource objectAtIndex:0].model.height < self.tableView.bounds.size.height) {
        return self.tableView.bounds.size.height;
    }
    if ([self.dataSource objectAtIndex:indexPath.item].model.height) {
        return [self.dataSource objectAtIndex:indexPath.item].model.height;
    }
    return [UGCBaseStrategyCell originHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGCBaseStrategyViewModel *viewModel = [self.dataSource objectAtIndex:indexPath.item];
    [viewModel reset];

    __weak typeof(self) weakSelf = self;
    
    if (viewModel.model.type == UGCBaseStrategyTypeContent) {
        
        UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if (!cell) {
            cell = [[UGCBaseStrategyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"content"];
        }
        
        __weak typeof(cell) weakCell = cell;
        
        cell.index = indexPath.item;
    
        cell.viewModel = viewModel;
        
        if (indexPath.item - 1 >= 0) {
            viewModel.lastViewModel = [self.dataSource objectAtIndex:(indexPath.item - 1)];
        }
        
        if (indexPath.item + 1 < self.dataSource.count) {
            viewModel.nextViewModel = [self.dataSource objectAtIndex:(indexPath.item + 1)];
        }
        
        viewModel.addPicDataSource = ^(NSInteger index, UGCBaseStrategyViewModel * _Nonnull firstModel, UGCBaseStrategyViewModel * _Nonnull insertModel, UGCBaseStrategyViewModel * _Nonnull lastModel) {
            NSMutableArray *tempArr = weakSelf.dataSource.mutableCopy;
            [tempArr replaceObjectAtIndex:index withObject:firstModel];
            [tempArr insertObject:insertModel atIndex:(index + 1)];
            [tempArr insertObject:lastModel atIndex:(index + 2)];
            weakSelf.dataSource = tempArr.mutableCopy;
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index + 1 inSection:0],[NSIndexPath indexPathForItem:index + 2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView reloadData];
        };
        
        viewModel.textViewDidBeginEditing = ^(NSInteger index) {
            weakSelf.currentIndex = index;
        };
    
        viewModel.dispose = [RACObserve(viewModel.model, content) subscribeNext:^(NSString *content) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                [[weakCell.textView layoutManager] ensureLayoutForTextContainer:[weakCell.textView textContainer]];
                UIEdgeInsets insets = weakCell.textView.textContainerInset;
                CGRect textFrame = [[weakCell.textView layoutManager] usedRectForTextContainer:[weakCell.textView textContainer]];
                CGFloat originHeight = viewModel.model.height;
                if (viewModel.model.height != textFrame.size.height + insets.top + insets.bottom) {
                    viewModel.model.height = textFrame.size.height + insets.top + insets.bottom;
                    [weakSelf.tableView beginUpdates];
                    [weakSelf.tableView endUpdates];
                    
                    CGRect footerViewFrame = weakSelf.tableFooterView.frame;
                    footerViewFrame.size.height += (viewModel.model.height - originHeight);
                    weakSelf.tableFooterView.frame = footerViewFrame;
                    if (weakSelf.keyboardShowed) {
//                        CGRect frame = [weakSelf.tableView convertRect:weakCell.frame toView:[UIApplication sharedApplication].keyWindow];
                        CGRect cursorRect = [weakCell.textView caretRectForPosition:weakCell.textView.selectedTextRange.start];
                        CGRect frame = [weakSelf.tableView convertRect:CGRectMake(weakCell.frame.origin.x, weakCell.frame.origin.y, weakCell.frame.size.width, cursorRect.origin.y + cursorRect.size.height) toView:[UIApplication sharedApplication].keyWindow];
                        if ((frame.origin.y + frame.size.height) > weakSelf.keyboardOriginY) {
                            CGPoint contentOffset = weakSelf.tableView.contentOffset;
                            contentOffset.y += (frame.origin.y + frame.size.height - weakSelf.keyboardOriginY);
                            [weakSelf.tableView setContentOffset:contentOffset animated:YES];
                        }
                    }
                    
                }
            }else {
                CGFloat originHeight = viewModel.model.height;
                if (viewModel.model.height != weakCell.textView.contentSize.height) {
                    viewModel.model.height = weakCell.textView.contentSize.height;
                    [weakSelf.tableView beginUpdates];
                    [weakSelf.tableView endUpdates];
                    CGRect footerViewFrame = weakSelf.tableFooterView.frame;
                    footerViewFrame.size.height += (viewModel.model.height - originHeight);
                    weakSelf.tableFooterView.frame = footerViewFrame;
                    if (weakSelf.keyboardShowed) {
//                        CGRect frame = [weakSelf.tableView convertRect:weakCell.frame toView:[UIApplication sharedApplication].keyWindow];
                        CGRect cursorRect = [weakCell.textView caretRectForPosition:weakCell.textView.selectedTextRange.start];
                        CGRect frame = [weakSelf.tableView convertRect:CGRectMake(weakCell.frame.origin.x, weakCell.frame.origin.y, weakCell.frame.size.width, cursorRect.origin.y + cursorRect.size.height) toView:[UIApplication sharedApplication].keyWindow];
                        if ((frame.origin.y + frame.size.height) > weakSelf.keyboardOriginY) {
                            CGPoint contentOffset = weakSelf.tableView.contentOffset;
                            contentOffset.y += (frame.origin.y + frame.size.height - weakSelf.keyboardOriginY);
                            [weakSelf.tableView setContentOffset:contentOffset animated:YES];
                        }
                    }
                }
            }
        }];
        
        return cell;
        
    }else if (viewModel.model.type == UGCBaseStrategyTypePic) {
        
        UGCPicStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pic"];
        if (!cell) {
            cell = [[UGCPicStrategyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pic"];
        }
        
        __weak typeof(cell) weakCell = cell;
        
        [self.dataSource objectAtIndex:indexPath.item].model.height = 200;
        
        cell.viewModel = viewModel;
        
        cell.longPressCallBack = ^(UIImageView * _Nonnull sortView) {
            
            CGRect sortingFrame = [weakSelf.tableView convertRect:CGRectMake(weakCell.frame.origin.x, weakCell.frame.origin.y, weakCell.frame.size.width, sortView.frame.origin.y + sortView.frame.size.height) toView:[UIApplication sharedApplication].keyWindow];
            weakSelf.dataSource = [weakSelf.parseTool splitDataSource:weakSelf.dataSource.copy].mutableCopy;
            weakSelf.isSorting = YES;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView layoutIfNeeded]; // 强制重绘保证下面的代码在reloadData完成后执行
            weakSelf.isSorting = NO;
            CGRect sortedFrame = [weakSelf.tableView convertRect:CGRectMake(weakCell.frame.origin.x, weakCell.frame.origin.y, weakCell.frame.size.width, sortView.frame.origin.y + sortView.frame.size.height) toView:[UIApplication sharedApplication].keyWindow];
            CGFloat contentOffSetY = sortedFrame.origin.y + sortedFrame.size.height - sortingFrame.origin.y - sortingFrame.size.height;
            CGPoint contentOffset = weakSelf.tableView.contentOffset;
            contentOffset.y += contentOffSetY;
            [weakSelf.tableView setContentOffset:contentOffset animated:NO];

        };
        
        return cell;
        
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGCBaseStrategyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.isFirstResponder) {
        [cell resignFirstResponder];
    }else {
        [cell becomeFirstResponder];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollDistance = 0; // 用户手动滑动页面,则不还原状态
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item == 0 || indexPath.item == 1) {
//        return NO;
//    }
    return YES;
}

// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    self.dataSource = [self.parseTool blendDataSource:self.dataSource.copy].mutableCopy;
    self.tableFooterView.frame = CGRectZero;
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
