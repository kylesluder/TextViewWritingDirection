//
//  NSAttributedString+WritingDirectionAttribute.m
//  UITextViewWritingDirection
//
//  Created by Kyle Sluder on 12/8/13.
//  Copyright (c) 2013 Kyle Sluder. All rights reserved.
//

#import "NSAttributedString+WritingDirectionAttribute.h"

#import <TargetConditionals.h>

@implementation NSString (DefaultText)

+ (NSString *)defaultText;
{
    return @"Twee messenger bag McSweeney's VHS, bicycle rights viral selfies Pinterest plaid High Life sriracha readymade tofu. Photo booth McSweeney's slow-carb, VHS Marfa flannel gastropub wolf hashtag selfies church-key.\n\nVegan beard craft beer, selvage flannel American Apparel salvia swag fixie slow-carb dreamcatcher. Organic literally photo booth, synth chia church-key four loko Intelligentsia. Echo Park High Life tote bag synth Williamsburg +1.";
}

@end

@implementation NSAttributedString (WritingDirectionAttribute)

+ (NSAttributedString *)defaultTextWithNaturalWritingDirection;
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
    
    return [[NSAttributedString alloc] initWithString:[NSString defaultText] attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
}

- (NSAttributedString *)attributedStringWithVisibleWritingDirection;
{
    static id redColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_IPHONE
        redColor = [UIColor redColor];
#else
        redColor = [NSColor redColor];
#endif
    });
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    
    NSRange paragraphStyleAttributeRange;
    NSRange searchRange = NSMakeRange(0, self.length);
    while (searchRange.length > 0) {
        NSParagraphStyle *paragraphStyle = [self attribute:NSParagraphStyleAttributeName atIndex:searchRange.location longestEffectiveRange:&paragraphStyleAttributeRange inRange:searchRange];
        
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
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:writingDirectionStringRepresentation attributes:@{NSForegroundColorAttributeName : redColor}]];
        }
        
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[self.string substringWithRange:paragraphStyleAttributeRange]]];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"¶" attributes:@{NSForegroundColorAttributeName : redColor}]];
        
        searchRange.location += paragraphStyleAttributeRange.length;
        searchRange.length -= paragraphStyleAttributeRange.length;
    }
    
    return result;
}

@end
