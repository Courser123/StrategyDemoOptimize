//
//  UGCBaseStrategyCell.m
//  strategyDemo
//
//  Created by Courser on 2019/1/28.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyCell.h"
//#import "UGCBaseStrategyTextView.h"

#define textFontSize 15

@interface UGCBaseStrategyCell () <UITextViewDelegate>

//@property (nonatomic, strong) UGCBaseStrategyTextView *textView;
@property (nonatomic, assign) BOOL isFirstResponder;
@property (nonatomic, assign) float currentLineNum;
@property (nonatomic, assign) BOOL hasRemovedObserver;

@end

@implementation UGCBaseStrategyCell

@synthesize isFirstResponder = _isFirstResponder;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.showsReorderControl = NO;
        self.textView = [[UGCBaseStrategyTextView alloc] initWithFrame:self.contentView.bounds];
        self.textView.bounces = NO;
        self.textView.font = [UIFont systemFontOfSize:textFontSize];
        self.textView.delegate = self;
        self.textView.textColor = [UIColor blueColor];
        __weak typeof(self) weakSelf = self;
        self.textView.deleteBackwardCallBack = ^{
            
            CGRect cursorRect;
            
            if (weakSelf.textView.selectedTextRange) {
                
                cursorRect = [weakSelf.textView caretRectForPosition:weakSelf.textView.selectedTextRange.start];
                
            } else {
                
                cursorRect = CGRectZero;
            }
            
            if (cursorRect.origin.x < 5 && cursorRect.origin.y < cursorRect.size.height) {
                if (weakSelf.viewModel.blendContent) {
                    weakSelf.viewModel.blendContent(weakSelf.index, weakSelf.viewModel.lastViewModel, weakSelf.viewModel);
                }
            }
            
        };
        [self.contentView addSubview:self.textView];
        self.currentLineNum = 1; //默认文本框显示一行文字
        self.hasRemovedObserver = NO;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textView.text = @"test";
    self.viewModel = [UGCBaseStrategyViewModel new];
}

- (void)setViewModel:(UGCBaseStrategyViewModel *)viewModel {
    _viewModel = viewModel;
    self.textView.text = viewModel.model.content;
//    self.dispose = [[self.textView rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        viewModel.model.content = x;
//    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.viewModel.textViewDidBeginEditing) {
        self.viewModel.textViewDidBeginEditing(self.index);
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    self.viewModel.selectedRange = textView.selectedRange;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self performSelector:@selector(textViewDidChange:) withObject:textView afterDelay:0.1f]; //准确获取光标位置
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.viewModel.model.content = textView.text;
    
//    if (self.lastCursorRect.origin.x == 0 && self.lastCursorRect.origin.y == 0 && cursorRect.origin.x == 0 && cursorRect.origin.y == 0) {
//        if (self.viewModel.blendContent) {
//            self.viewModel.blendContent(self.index, self.viewModel.lastViewModel, self.viewModel);
//        }
//    }
//
//    self.lastCursorRect = cursorRect;
//
    if (self.viewModel.getCursorRect) {
        CGRect cursorRect;
        
        if (textView.selectedTextRange) {
            
            cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
            
        } else {
            
            cursorRect = CGRectZero;
        }
        self.viewModel.getCursorRect(cursorRect);
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"UGCBaseStrategyCell scrollViewDidScroll");
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isEditing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Edit"].location != NSNotFound) {
                view.frame = CGRectZero;
            }
            if ([NSStringFromClass([view class]) rangeOfString:@"Content"].location != NSNotFound) {
                view.frame = self.bounds;
            }
        }
    }
    self.textView.frame = self.contentView.bounds;
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated:YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = nil;
                    }
                }
            }
        }
    }
    
}

- (void)becomeFirstResponder {
    [self.textView becomeFirstResponder];
    self.isFirstResponder = YES;
}

- (void)resignFirstResponder {
    [self.textView resignFirstResponder];
    self.isFirstResponder = NO;
}

+ (CGFloat)originHeight {
    NSDictionary *dict= @{NSFontAttributeName:[UIFont systemFontOfSize:textFontSize]};
    CGSize contentSize = [@"C" sizeWithAttributes:dict];
    return contentSize.height + 10;
}

- (void)dealloc {
    
}

@end
