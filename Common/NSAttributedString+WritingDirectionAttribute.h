//
//  NSAttributedString+WritingDirectionAttribute.h
//  UITextViewWritingDirection
//
//  Created by Kyle Sluder on 12/8/13.
//  Copyright (c) 2013 Kyle Sluder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DefaultText)
+ (NSString *)defaultText;
@end

@interface NSAttributedString (WritingDirectionAttribute)
+ (NSAttributedString *)defaultTextWithNaturalWritingDirection;
- (NSAttributedString *)attributedStringWithVisibleWritingDirection;
@end
