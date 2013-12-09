//
//  ViewController.m
//  TextViewBidiAttributes
//
//  Created by Kyle Sluder on 12/8/13.
//  Copyright (c) 2013 Kyle Sluder. All rights reserved.
//

#import "ViewController.h"

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
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
    _editableTextView.attributedText = [[NSAttributedString alloc] initWithString:@"some text" attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    
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
    NSAttributedString *attributedText = _editableTextView.attributedText;
    if (attributedText.length == 0) {
        _readOnlyTextView.text = @"";
        return;
    }
    
    NSMutableAttributedString *readOnlyString = [NSMutableAttributedString new];
    
    NSRange paragraphStyleAttributeRange;
    NSRange searchRange = NSMakeRange(0, attributedText.length);
    while (searchRange.length > 0) {
        NSParagraphStyle *paragraphStyle = [attributedText attribute:NSParagraphStyleAttributeName atIndex:searchRange.location longestEffectiveRange:&paragraphStyleAttributeRange inRange:searchRange];
        
        if (paragraphStyle) {
            NSString *writingDirectionStringRepresentation;
            switch (paragraphStyle.baseWritingDirection) {
                case NSWritingDirectionNatural:
                    writingDirectionStringRepresentation = @"<NAT>";
                    break;
                case NSWritingDirectionLeftToRight:
                    writingDirectionStringRepresentation = @"<LTR>";
                    break;
                case NSWritingDirectionRightToLeft:
                    writingDirectionStringRepresentation = @"<RTL>";
                    break;
            }
            [readOnlyString appendAttributedString:[[NSAttributedString alloc] initWithString:writingDirectionStringRepresentation attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
        }
        
        [readOnlyString appendAttributedString:[[NSAttributedString alloc] initWithString:[attributedText.string substringWithRange:paragraphStyleAttributeRange]]];
        [readOnlyString appendAttributedString:[[NSAttributedString alloc] initWithString:@"¶" attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
        
        searchRange.location += paragraphStyleAttributeRange.length;
        searchRange.length -= paragraphStyleAttributeRange.length;
    }
    
    _readOnlyTextView.attributedText = readOnlyString;
}

@end
