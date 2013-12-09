//
//  AppDelegate.m
//  NSTextViewWritingDirection
//
//  Created by Kyle Sluder on 12/8/13.
//  Copyright (c) 2013 Kyle Sluder. All rights reserved.
//

#import "AppDelegate.h"
#import "NSAttributedString+WritingDirectionAttribute.h"

@interface AppDelegate () <NSTextViewDelegate>
@property (assign) IBOutlet NSTextView *editableTextView;
@property (assign) IBOutlet NSTextView *readOnlyTextView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_editableTextView.textStorage setAttributedString:[[NSAttributedString alloc] init]];
    _editableTextView.typingAttributes = nil;
    
    _editableTextView.string = [NSString defaultText];
    [self _updateReadOnlyTextView];
}

- (void)textDidChange:(NSNotification *)notification;
{
    [self _updateReadOnlyTextView];
}

- (void)_updateReadOnlyTextView;
{
    [_readOnlyTextView.textStorage setAttributedString:[_editableTextView.attributedString attributedStringWithVisibleWritingDirection]];
}

@end
