//
//  UGCBaseStrategyViewController.m
//  strategyDemo
//
//  Created by Courser on 2019/1/28.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyViewController.h"
#import "UGCContentStrategyCell.h"
#import "UGCPicStrategyCell.h"
#import <ReactiveObjC.h>
#import "UGCBaseStrategyViewModel.h"
#import "UGCBaseStrategyParseTool.h"
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
@property (nonatomic, strong) UGCBaseStrategyParseTool *parseTool;
@property (nonatomic, assign) BOOL isSorting;
@property (nonatomic, strong) NSIndexPath *proposedDestinationIndexPath;

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
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:self.tableView];
    
    [self setupNavigationBar];
    
    self.tableView.editing = YES;
    self.tableView.bounces = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, self.view.bounds.size.width, 100)];
    topView.backgroundColor = [UIColor blueColor];
    [self.tableView addSubview:topView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // fake data
    self.parseTool = [UGCBaseStrategyParseTool new];
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
    CGRect footerViewFrame = self.tableFooterView.frame;
    footerViewFrame.size.height = rect.size.height;
    self.tableFooterView.frame = footerViewFrame;
    
    UGCContentStrategyCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    
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
        self.tableFooterView.frame = CGRectZero;
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
        if ([self.dataSource objectAtIndex:indexPath.item].height > [self.dataSource objectAtIndex:indexPath.item].sortingHeight) {
            return [self.dataSource objectAtIndex:indexPath.item].sortingHeight;
        }else {
            return [self.dataSource objectAtIndex:indexPath.item].height;
        }
    }
    
    if (self.dataSource.count == 1 && [self.dataSource objectAtIndex:0].height < self.tableView.bounds.size.height) {
        return self.tableView.bounds.size.height;
    }
    if ([self.dataSource objectAtIndex:indexPath.item].height) {
        return [self.dataSource objectAtIndex:indexPath.item].height;
    }
    return [UGCContentStrategyCell originHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGCBaseStrategyViewModel *viewModel = [self.dataSource objectAtIndex:indexPath.item];
    [viewModel reset];

    __weak typeof(self) weakSelf = self;
    
    if (viewModel.node.nodeType == CPSDNodeTypeText) {
        
        UGCContentStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if (!cell) {
            cell = [[UGCContentStrategyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"content"];
        }
        
        __weak typeof(cell) weakCell = cell;
        
        cell.sortingState = self.isSorting;
        
        cell.index = indexPath.item;
    
        cell.viewModel = viewModel;
        
        if (indexPath.item - 1 >= 0) {
            viewModel.lastViewModel = [self.dataSource objectAtIndex:(indexPath.item - 1)];
        }
        
        if (indexPath.item + 1 < self.dataSource.count) {
            viewModel.nextViewModel = [self.dataSource objectAtIndex:(indexPath.item + 1)];
        }
        
        viewModel.addPicDataSource = ^(NSInteger index, UGCBaseStrategyViewModel * _Nonnull firstViewModel, UGCBaseStrategyViewModel * _Nonnull insertViewModel, UGCBaseStrategyViewModel * _Nonnull lastViewModel) {
            NSMutableArray *tempArr = weakSelf.dataSource.mutableCopy;
            [tempArr replaceObjectAtIndex:index withObject:firstViewModel];
            [tempArr insertObject:insertViewModel atIndex:(index + 1)];
            [tempArr insertObject:lastViewModel atIndex:(index + 2)];
            weakSelf.dataSource = tempArr.mutableCopy;
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index + 1 inSection:0],[NSIndexPath indexPathForItem:index + 2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView layoutIfNeeded]; // 强制重绘保证下面的代码在reloadData完成后执行
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index + 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        };
        
        viewModel.textViewDidBeginEditing = ^(NSInteger index) {
            weakSelf.currentIndex = index;
        };
        
        CPSDTextNode *textNode = (CPSDTextNode *)viewModel.node;
        
        viewModel.dispose = [RACObserve(textNode, text) subscribeNext:^(NSString *content) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                [[weakCell.textView layoutManager] ensureLayoutForTextContainer:[weakCell.textView textContainer]];
                UIEdgeInsets insets = weakCell.textView.textContainerInset;
                CGRect textFrame = [[weakCell.textView layoutManager] usedRectForTextContainer:[weakCell.textView textContainer]];
                CGFloat originHeight = viewModel.height;
                if (viewModel.height != textFrame.size.height + insets.top + insets.bottom) {
                    viewModel.height = textFrame.size.height + insets.top + insets.bottom;
                    [weakSelf.tableView beginUpdates];
                    [weakSelf.tableView endUpdates];
                    
                    CGRect footerViewFrame = weakSelf.tableFooterView.frame;
                    footerViewFrame.size.height += (viewModel.height - originHeight);
                    weakSelf.tableFooterView.frame = footerViewFrame;
                    if (weakSelf.keyboardShowed) {
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
                CGFloat originHeight = viewModel.height;
                if (viewModel.height != weakCell.textView.contentSize.height) {
                    viewModel.height = weakCell.textView.contentSize.height;
                    [weakSelf.tableView beginUpdates];
                    [weakSelf.tableView endUpdates];
                    CGRect footerViewFrame = weakSelf.tableFooterView.frame;
                    footerViewFrame.size.height += (viewModel.height - originHeight);
                    weakSelf.tableFooterView.frame = footerViewFrame;
                    if (weakSelf.keyboardShowed) {
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
        
    }else if (viewModel.node.nodeType == CPSDNodeTypeImage) {
        
        UGCPicStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pic"];
        if (!cell) {
            cell = [[UGCPicStrategyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pic"];
        }
        
        __weak typeof(cell) weakCell = cell;
        
        cell.index = indexPath.item;
        
        [self.dataSource objectAtIndex:indexPath.item].height = 200;
        
        cell.sortingState = self.isSorting;
        
        cell.viewModel = viewModel;
        
        cell.longPressCallBack = ^(UIView * _Nonnull sortView) {
            
            CGRect sortingFrame = [weakSelf.tableView convertRect:CGRectMake(weakCell.frame.origin.x, weakCell.frame.origin.y, weakCell.frame.size.width, sortView.frame.origin.y + sortView.frame.size.height) toView:[UIApplication sharedApplication].keyWindow];
            weakSelf.dataSource = [weakSelf.parseTool splitDataSource:weakSelf.dataSource.copy].mutableCopy;
            weakSelf.isSorting = YES;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView layoutIfNeeded]; // 强制重绘保证下面的代码在reloadData完成后执行
            self.proposedDestinationIndexPath = [NSIndexPath indexPathForItem:weakCell.index inSection:0];
            CGRect sortedFrame = [weakSelf.tableView convertRect:CGRectMake(weakCell.frame.origin.x, weakCell.frame.origin.y, weakCell.frame.size.width, sortView.frame.origin.y + sortView.frame.size.height) toView:[UIApplication sharedApplication].keyWindow];
            CGFloat contentOffSetY = sortedFrame.origin.y + sortedFrame.size.height - sortingFrame.origin.y - sortingFrame.size.height;
            CGPoint contentOffset = weakSelf.tableView.contentOffset;
            contentOffset.y += contentOffSetY;
//            [weakSelf.tableView setContentOffset:contentOffset animated:NO];

        };
        
        cell.restore = ^(BOOL changeDataSource) {
            if (changeDataSource && self.proposedDestinationIndexPath) {
                [self.dataSource exchangeObjectAtIndex:weakCell.index withObjectAtIndex:self.proposedDestinationIndexPath.row];
            }
            weakSelf.isSorting = NO;
            weakSelf.dataSource = [weakSelf.parseTool blendDataSource:weakSelf.dataSource.copy].mutableCopy;
            weakSelf.tableFooterView.frame = CGRectZero;
            [weakSelf.tableView reloadData];
        };
        
        return cell;
        
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGCContentStrategyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    self.proposedDestinationIndexPath = proposedDestinationIndexPath;
    return proposedDestinationIndexPath;
}

// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:self.proposedDestinationIndexPath.row];
    self.isSorting = NO;
    self.dataSource = [self.parseTool blendDataSource:self.dataSource.copy].mutableCopy;
    self.tableFooterView.frame = CGRectZero;
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
