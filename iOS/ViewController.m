//
//  ViewController.m
//  UITextViewWritingDirection
//
//  Created by Kyle Sluder on 12/8/13.
//  Copyright (c) 2013 Kyle Sluder. All rights reserved.
//

#import "ViewController.h"
#import "NSAttributedString+WritingDirectionAttribute.h"

@interface ViewController () <UITextViewDelegate>

@property (assign) IBOutlet UITextView *editableTextView;
@property (assign) IBOutlet UITextView *readOnlyTextView;

@end

@implementation ViewController

- (void)textViewDidChange:(UITextView *)textView;
{
    [self _updateReadOnlyTextView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    _readOnlyTextView.contentOffset = _editableTextView.contentOffset;
}

- (void)viewDidLoad
{
    _editableTextView.attributedText = nil;
    _editableTextView.text = [NSString defaultText];
    [self _updateReadOnlyTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidLoad];
}

static void _updateEdgeInsets(UITextView *view, CGFloat keyboardHeight)
{
    UIEdgeInsets insets = view.contentInset;
    insets.bottom = keyboardHeight;
    view.contentInset = insets;
    
    UIEdgeInsets scrollInsets = view.scrollIndicatorInsets;
    scrollInsets.bottom = keyboardHeight;
    view.scrollIndicatorInsets = scrollInsets;
}

- (void)_keyboardFrameWillChange:(NSNotification *)note;
{
    CGFloat keyboardHeight = ((NSValue *)[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]).CGRectValue.size.height;
    
    _updateEdgeInsets(_editableTextView, keyboardHeight);
    _updateEdgeInsets(_readOnlyTextView, keyboardHeight);
}

- (void)_keyboardWillHide:(NSNotification *)note;
{
    _updateEdgeInsets(_editableTextView, 0);
    _updateEdgeInsets(_readOnlyTextView, 0);
}

- (void)_updateReadOnlyTextView;
{
    _readOnlyTextView.attributedText = [_editableTextView.attributedText attributedStringWithVisibleWritingDirection];
}

@end
