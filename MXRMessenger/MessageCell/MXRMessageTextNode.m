//
//  MXRMessageTextNode.m
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageTextNode.h"

#import "UIImage+MXRMessenger.h"
#import "UIColor+MXRMessenger.h"
#import "MXRMessageContentNode+Subclasses.h"

@interface MXRMessageTextNode () <ASTextNodeDelegate>

@end

@implementation MXRMessageTextNode {
    MXRMessageTextConfiguration* _configuration;
    UIRectCorner _cornersHavingRadius;
    
    BOOL _delegateImplementsTapURL;
    BOOL _hasLinks;
    BOOL _isTouchingURL;
}

- (instancetype)initWithText:(NSString *)text configuration:(MXRMessageTextConfiguration *)configuration cornersToApplyMaxRadius:(UIRectCorner)cornersHavingRadius {
    self = [super initWithConfiguration:configuration];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        _configuration = configuration;
        _cornersHavingRadius = cornersHavingRadius;
        
        _textNode = [[ASTextNode alloc] init];
        _textNode.layerBacked = YES;
        NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:(text ? : @"") attributes:_configuration.textAttributes];
        if (_configuration.isLinkDetectionEnabled && _configuration.linkAttributes && text.length > 0) {
            NSArray* links = [MXRMessageTextNode applyAttributes:_configuration.linkAttributes toLinksInMutableAttributedString:attributedText];
            _hasLinks = links.count > 0;
        }
        _textNode.attributedText = attributedText;
        _backgroundImageNode = [[ASImageNode alloc] init];
        _backgroundImageNode.layerBacked = YES;
        [self redrawBubble];
    }
    return self;
}

- (instancetype)init {
    ASDISPLAYNODE_NOT_DESIGNATED_INITIALIZER();
    return [self initWithText:nil configuration:nil cornersToApplyMaxRadius:UIRectCornerAllCorners];
}

- (instancetype)initWithConfiguration:(MXRMessageNodeConfiguration *)configuration {
    ASDISPLAYNODE_NOT_DESIGNATED_INITIALIZER();
    return [self initWithText:nil configuration:nil cornersToApplyMaxRadius:UIRectCornerAllCorners];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec* textInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:_configuration.textInset child:_textNode];
    return [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:textInset background:_backgroundImageNode];
}

- (void)didLoad {
    [super didLoad];
    if (_hasLinks) {
        _textNode.highlightStyle = ASTextNodeHighlightStyleDark;
        [_textNode.layer as_setAllowsHighlightDrawing:YES];
    }
}

- (void)redrawBubble {
    [self redrawBubbleImageWithColor:_configuration.backgroundColor];
}

- (void)redrawBubbleImageWithColor:(UIColor*)color {
    _backgroundImageNode.image = [UIImage mxr_bubbleImageWithMaximumCornerRadius:_configuration.maxCornerRadius minimumCornerRadius:_configuration.minCornerRadius color:color cornersToApplyMaxRadius:_cornersHavingRadius];
}

#pragma mark - MXRMessageContentNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_hasLinks) {
        _isTouchingURL = [self urlTouched:touches performHighlight:YES] != nil;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isTouchingURL) {
        [_textNode setHighlightRange:NSMakeRange(0, 0) animated:NO];
    }
    _isTouchingURL = NO;
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_isTouchingURL) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    _isTouchingURL = NO;
    [_textNode setHighlightRange:NSMakeRange(0, 0) animated:NO];
    NSURL* url = [self urlTouched:touches performHighlight:NO];
    if (url) {
        if (_delegateImplementsTapURL) {
            [self.delegate messageContentNode:self didTapURL:url];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (_isTouchingURL) {
        return;
    }
    BOOL didChange = highlighted != self.highlighted;
    [super setHighlighted:highlighted];
    if (didChange) {
        if (highlighted) {
            [self redrawBubbleImageWithColor:[_configuration.backgroundColor mxr_darkerColor]];
        } else {
            [self redrawBubbleImageWithColor:_configuration.backgroundColor];
        }
    }
}

- (void)setDelegate:(id<MXRMessageContentNodeDelegate>)delegate {
    [super setDelegate:delegate];
    _delegateImplementsTapURL = [delegate respondsToSelector:@selector(messageContentNode:didTapURL:)];
}

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.textNode.attributedText.string];
    [super copy:sender];
}

- (void)redrawBubbleWithCorners:(UIRectCorner)cornersHavingRadius {
    _cornersHavingRadius = cornersHavingRadius;
    [self redrawBubble];
}

- (NSURL*)urlTouched:(NSSet<UITouch *> *)touches performHighlight:(BOOL)highlight {
    CGPoint pointInTextNode = [self convertPoint:[[touches anyObject] locationInView:self.view] toNode:_textNode];
    NSRange range = NSMakeRange(0, 0);
    id linkAttributeValue = [_textNode linkAttributeValueAtPoint:pointInTextNode attributeName:NULL range:&range];
    if (range.length == 0 || ![linkAttributeValue isKindOfClass:[NSURL class]]) {
        return nil;
    }
    if (highlight) {
        [_textNode setHighlightRange:range animated:NO];
    }
    return linkAttributeValue;
}

#pragma mark - Helper

+ (NSArray*)applyAttributes:(NSDictionary*)attributes toLinksInMutableAttributedString:(NSMutableAttributedString*)attributedString {
    NSString* text = attributedString.string;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray <NSTextCheckingResult*>*matches = [linkDetector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult* match in matches) {
        if (match.range.location == NSNotFound || !match.URL) continue;
        NSMutableDictionary* linkAttrs = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        linkAttrs[NSLinkAttributeName] = match.URL;
        [attributedString addAttributes:linkAttrs range:match.range];
    }
    return matches;
}

@end


@implementation MXRMessageTextConfiguration

- (instancetype)init {
    return [self initWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] backgroundColor:[UIColor mxr_bubbleLightGrayColor]];
}

- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
    return [self initWithTextAttributes:@{NSFontAttributeName: (font ? : [UIFont systemFontOfSize:15]), NSForegroundColorAttributeName: (textColor ? : [UIColor blackColor])} backgroundColor:backgroundColor];
}

- (instancetype)initWithTextAttributes:(NSDictionary *)attributes backgroundColor:(UIColor *)backgroundColor {
    self = [super init];
    if (self) {
        NSMutableDictionary* attrsMutable = [(attributes ? : @{}) mutableCopy];
        attrsMutable[NSFontAttributeName] = attrsMutable[NSFontAttributeName] ? : [UIFont systemFontOfSize:15];
        attrsMutable[NSForegroundColorAttributeName] = attrsMutable[NSForegroundColorAttributeName] ? : [UIColor blackColor];
        self.showsUIMenuControllerOnLongTap = YES;
        self.menuItemTypes |= MXRMessageMenuItemTypeCopy;
        self.backgroundColor = backgroundColor;
        _textAttributes = [attrsMutable copy];
        _textInset = UIEdgeInsetsMake(8, 12, 8, 12);
        [self setTextInset:UIEdgeInsetsMake(8, 12, 8, 12) adjustMaxCornerRadiusToKeepCircular:YES];
        _isLinkDetectionEnabled = YES;
        NSMutableDictionary* linkAttributes = [[NSMutableDictionary alloc] initWithDictionary:(_textAttributes ? : @{})];
        linkAttributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
        linkAttributes[NSUnderlineColorAttributeName] = attributes[NSForegroundColorAttributeName];
        _linkAttributes = [linkAttributes copy];
    }
    return self;
}

- (void)setTextInset:(UIEdgeInsets)textInset {
    [self setTextInset:textInset adjustMaxCornerRadiusToKeepCircular:YES];
}

- (void)setTextInset:(UIEdgeInsets)textInset adjustMaxCornerRadiusToKeepCircular:(BOOL)adjustMaxCornerRadius {
    _textInset = textInset;
    if (adjustMaxCornerRadius) {
        UIFont* font = self.textAttributes[NSFontAttributeName];
        if (font) {
            self.maxCornerRadius = (ceilf(font.lineHeight) + _textInset.top + _textInset.bottom)/2.0f;
        }
    }
}

@end
