//
//  UGCContentStrategyCell.m
//  strategyDemo
//
//  Created by Courser on 2019/2/20.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCContentStrategyCell.h"

#define textFontSize 15

@interface UGCContentStrategyCell () <UITextViewDelegate>

@property (nonatomic, assign) BOOL isFirstResponder;
@property (nonatomic, assign) float currentLineNum;

@end

@implementation UGCContentStrategyCell

@synthesize isFirstResponder = _isFirstResponder;
@synthesize viewModel = _viewModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textView = [[UGCBaseStrategyTextView alloc] initWithFrame:self.contentView.bounds];
        self.textView.bounces = NO;
        self.textView.font = [UIFont systemFontOfSize:textFontSize];
        self.textView.delegate = self;
//        self.textView.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.textView];
        self.currentLineNum = 1; //默认文本框显示一行文字
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
    self.textView.text = ((CPSDTextNode *)viewModel.node).text;
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
    
    ((CPSDTextNode *)self.viewModel.node).text = textView.text;
    
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.contentView.bounds;
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
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
