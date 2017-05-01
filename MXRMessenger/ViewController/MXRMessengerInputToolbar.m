//
//  MXRMessengerInputToolbar.m
//  Mixer
//
//  Created by Scott Kensell on 3/3/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/MXRMessengerInputToolbar.h>

#import <MXRMessenger/UIColor+MXRMessenger.h>

@implementation MXRMessengerInputToolbar {
    ASImageNode* _textInputBackgroundNode;
    UIEdgeInsets _textInputInsets;
}

- (instancetype)init {
    return [self initWithFont:[UIFont systemFontOfSize:16.0f] placeholder:@"Type a message" tintColor:[UIColor mxr_fbMessengerBlue]];
}

- (instancetype)initWithFont:(UIFont *)font placeholder:(NSString *)placeholder tintColor:(UIColor*)tintColor {
    self = [super init];
    if (self) {
        NSAssert(font, @"You forgot to provide a font to init %@", NSStringFromClass(self.class));
        self.automaticallyManagesSubnodes = YES;
        self.backgroundColor = [UIColor whiteColor];
        _font = font;
        _tintColor = tintColor;
        // #8899a6 alpha 0.85
        UIColor* placeholderGray = [UIColor colorWithRed:0.53 green:0.60 blue:0.65 alpha:0.85];
        // #f5f8fa
        UIColor* veryLightGray = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.0];;
        
        CGFloat topPadding = ceilf(0.33f * font.lineHeight);
        CGFloat bottomPadding = topPadding;
        CGFloat heightOfTextNode = ceilf(topPadding + bottomPadding + font.lineHeight);
        _heightOfTextNodeWithOneLineOfText = heightOfTextNode;
        CGFloat cornerRadius = floorf(heightOfTextNode / 2.0f);
        
        _textInputInsets = UIEdgeInsetsMake(topPadding, 0.7f*cornerRadius, bottomPadding, 0.7f*cornerRadius);
        
        _textInputBackgroundNode = [[ASImageNode alloc] init];
        _textInputBackgroundNode.image = [UIImage as_resizableRoundedImageWithCornerRadius:cornerRadius cornerColor:[UIColor whiteColor] fillColor:veryLightGray borderColor:placeholderGray borderWidth:0.5f];
        _textInputBackgroundNode.displaysAsynchronously = NO; // otherwise it doesnt appear until viewDidAppear
        
        _textInputNode = [[MXRGrowingEditableTextNode alloc] init];
        _textInputNode.tintColor = tintColor;
        _textInputNode.maximumLinesToDisplay = 6;
        _textInputNode.typingAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
        NSDictionary* placeholderAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: placeholderGray};
        _textInputNode.attributedPlaceholderText = [[NSAttributedString alloc] initWithString:(placeholder ? : @"") attributes:placeholderAttributes];
        _textInputNode.style.flexGrow = 1.0f;
        _textInputNode.style.flexShrink = 1.0f;
        _textInputNode.clipsToBounds = YES;
        
        _defaultSendButton = [MXRMessengerIconButtonNode buttonWithIcon:[[MXRMessengerSendIconNode alloc] init] matchingToolbar:self];
        _rightButtonsNode = _defaultSendButton;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec* inputBar = [ASStackLayoutSpec horizontalStackLayoutSpec];
    inputBar.alignItems = ASStackLayoutAlignItemsEnd;
    NSMutableArray* inputBarChildren = [[NSMutableArray alloc] init];
    if (_leftButtonsNode) [inputBarChildren addObject:_leftButtonsNode];
    
    ASInsetLayoutSpec* textInputInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:_textInputInsets child:_textInputNode];
    ASBackgroundLayoutSpec* textInputWithBackground = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:textInputInset background:_textInputBackgroundNode];
    textInputWithBackground.style.flexGrow = 1.0f;
    textInputWithBackground.style.flexShrink = 1.0f;
    if (!_leftButtonsNode) textInputWithBackground.style.spacingBefore = 8.0f;
    if (!_rightButtonsNode) textInputWithBackground.style.spacingAfter = 8.0f;
    [inputBarChildren addObject:textInputWithBackground];
    
    if (_rightButtonsNode) [inputBarChildren addObject:_rightButtonsNode];
    inputBar.children = inputBarChildren;
    
    ASInsetLayoutSpec* inputBarInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 0, 10, 0) child:inputBar];
    return inputBarInset;
}

- (NSString*)clearText {
    NSString* text = [_textInputNode.attributedText.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _textInputNode.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:_textInputNode.typingAttributes];
    return text;
}

@end


@implementation MXRMessengerIconNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.opaque = NO;
        self.clipsToBounds = NO;
    }
    return self;
}

- (UIColor *)color { return _color ? : (_color = [UIColor blackColor]); }

- (id<NSObject>)drawParametersForAsyncLayer:(_ASDisplayLayer *)layer {
    return [self color];
}

@end


@implementation MXRMessengerSendIconNode

+ (void)drawRect:(CGRect)bounds withParameters:(id<NSObject>)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat halfStrokeWidth = 1.0f;
    CGFloat hsw = halfStrokeWidth;
    
    CGFloat sw = bounds.size.width / 44.0f;
    CGFloat sh = bounds.size.height / 44.0f;
    CGPoint p0 = CGPointMake(hsw, hsw);
    CGPoint p1 = CGPointMake(44.0f*sw - hsw, 22.0f*sh);
    CGPoint p2 = CGPointMake(hsw, 44.0f*sh - hsw);
    CGPoint p3 = CGPointMake(6.0f*sw, 27.0f*sh);
    CGPoint p4 = CGPointMake(32.0f*sw, 22.0f*sh);
    CGPoint p5 = CGPointMake(6.0f*sw, 17.0f*sh);
    
    CGPoint points[6] = { p0, p1, p2, p3, p4, p5 };
    
    UIColor* color = (UIColor*)parameters;
    [color setFill];
    [color setStroke];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:2*halfStrokeWidth];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path moveToPoint:p0];
    for (int i = 1; i < 6; i++) {
        [path addLineToPoint:points[i]];
    }
    [path closePath];
    [path fill];
    [path stroke];
    
    CGContextRestoreGState(context);
}

@end


@implementation MXRMessengerPlusIconNode 

+ (void)drawRect:(CGRect)bounds withParameters:(id<NSObject>)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIColor* color = (UIColor*)parameters;
    [color setStroke];
    [color setFill];
    CGFloat strokeWidth = 2.0f;
    CGFloat halfPlusLength = ceilf(0.15f*bounds.size.width);
    
    CGRect circleContainerRect = CGRectInset(bounds, strokeWidth/2.0f, strokeWidth/2.0f);
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:circleContainerRect];
    [circlePath setLineWidth:strokeWidth];
    [circlePath stroke];
    [circlePath fill];
    
    UIBezierPath* plusPath = [UIBezierPath bezierPath];
    [plusPath setLineWidth:strokeWidth];
    [plusPath setLineCapStyle:kCGLineCapRound];
    CGFloat centerX = CGRectGetMidX(bounds);
    CGFloat centerY = CGRectGetMidY(bounds);
    
    [plusPath moveToPoint:CGPointMake(centerX, centerY - halfPlusLength)];
    [plusPath addLineToPoint:CGPointMake(centerX, centerY + halfPlusLength)];
    [plusPath moveToPoint:CGPointMake(centerX - halfPlusLength, centerY)];
    [plusPath addLineToPoint:CGPointMake(centerX + halfPlusLength, centerY)];
    
    [[UIColor whiteColor] setStroke];
    [plusPath stroke];
    
    CGContextRestoreGState(context);
}

@end


@implementation MXRMessengerIconButtonNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY child:_icon];
}


+ (instancetype)buttonWithIcon:(MXRMessengerIconNode *)icon matchingToolbar:(MXRMessengerInputToolbar *)toolbar {
    MXRMessengerIconButtonNode* button = [[MXRMessengerIconButtonNode alloc] init];
    button.icon = icon;
    icon.displaysAsynchronously = NO; // otherwise it doesnt appear until viewDidAppear
    button.displaysAsynchronously = NO;
    icon.color = toolbar.tintColor;
    CGFloat iconWidth = ceilf(toolbar.font.lineHeight) + 2.0f;
    icon.style.preferredSize = CGSizeMake(iconWidth, iconWidth);
    button.style.preferredSize = CGSizeMake(iconWidth + 22.0f, toolbar.heightOfTextNodeWithOneLineOfText);
    button.hitTestSlop = UIEdgeInsetsMake(-4.0f, 0, -10.0f, 0.0f);
    return button;
}

@end
