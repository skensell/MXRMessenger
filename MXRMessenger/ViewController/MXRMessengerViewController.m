//
//  MXRMessengerViewController.m
//  Mixer
//
//  Created by Scott Kensell on 2/22/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/MXRMessengerViewController.h>

#import <MXRMessenger/_MXRMessengerInputToolbarContainerView.h>

@interface MXRMessengerViewController ()

@property (nonatomic, strong) MXRMessengerInputToolbarContainerView* toolbarContainerView;
@property (nonatomic, strong) NSNumber* calculatedOffsetFromInteractiveKeyboardDismissal;
@property (nonatomic, assign) CGFloat minimumBottomInset;
@property (nonatomic, assign) CGFloat topInset;

@end

@implementation MXRMessengerViewController

- (instancetype)init {
    return [self initWithNode:[[MXRMessengerNode alloc] init] toolbar:[[MXRMessengerInputToolbar alloc] init]];
}

- (instancetype)initWithToolbar:(MXRMessengerInputToolbar *)toolbar {
    return [self initWithNode:[[MXRMessengerNode alloc] init] toolbar:toolbar];
}

- (instancetype)initWithNode:(ASDisplayNode *)node {
    NSAssert(NO, @"You did not call the designated initializer of %@", NSStringFromClass([self class]));
    return [self initWithNode:[[MXRMessengerNode alloc] init] toolbar:[[MXRMessengerInputToolbar alloc] init]];
}

- (instancetype)initWithNode:(MXRMessengerNode *)node toolbar:(MXRMessengerInputToolbar *)toolbar {
    self = [super initWithNode:node];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _toolbar = toolbar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11, *)) {
        self.node.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _toolbarContainerView = [[MXRMessengerInputToolbarContainerView alloc] initWithMessengerInputToolbar:self.toolbar constrainedSize:ASSizeRangeMake(CGSizeMake(screenWidth, 0), CGSizeMake(screenWidth, CGFLOAT_MAX))];
    _minimumBottomInset = self.toolbarContainerView.toolbarNode.calculatedSize.height;
    _topInset = [self calculateTopInset];
    
    self.node.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.node.tableNode.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.node.tableNode.contentInset = UIEdgeInsetsMake(_minimumBottomInset, 0, _topInset, 0);
    self.node.tableNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(_minimumBottomInset, 0, _topInset, 0);
    self.node.tableNode.delegate = self;

    [self observeKeyboardChanges];
    [self observeAppStateChanges];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dismissKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismissKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
}

- (void)dealloc {
    [self stopObservingKeyboard];
    [self stopObservingAppStateChanges];
}

- (CGFloat)calculateTopInset {
    CGFloat t = 6.0f;
    if (!self.prefersStatusBarHidden) {
        t += [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    if (self.navigationController && !self.navigationController.isNavigationBarHidden) {
        t += self.navigationController.navigationBar.frame.size.height;
    }
    return t;
}

#pragma mark - NSNotificationCenter

- (void)observeKeyboardChanges {
    [self stopObservingKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mxr_messenger_didReceiveKeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)stopObservingKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)observeAppStateChanges {
    [self stopObservingAppStateChanges];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mxr_messenger_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mxr_messenger_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)stopObservingAppStateChanges {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - Target-Action AppState

- (void)mxr_messenger_applicationWillResignActive:(id)sender {
    [self stopObservingKeyboard];
}

- (void)mxr_messenger_applicationDidBecomeActive:(id)sender {
    [self observeKeyboardChanges];
}

#pragma mark - Target-Action Keyboard

- (void)mxr_messenger_didReceiveKeyboardWillChangeFrameNotification:(NSNotification*)notification {
    if (self.isBeingDismissed || (self.navigationController && self.navigationController.topViewController != self)) {
        return;
    }
    UITableView* tableView = self.node.tableNode.view;
    CGFloat keyboardEndHeight = [UIScreen mainScreen].bounds.size.height - [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat keyboardStartHeight = tableView.contentInset.top; // this is more reliable than the startFrame in userInfo
    CGFloat changeInHeight = keyboardEndHeight - keyboardStartHeight;
    if (changeInHeight == 0) return; // e.g. when an interactive dismiss is cancelled
    if (keyboardEndHeight < self.minimumBottomInset) return; // e.g. when we present media viewer, it dismisses the toolbar
    BOOL willDismissKeyboard = changeInHeight < 0;
    CGFloat newOffset = tableView.contentOffset.y - changeInHeight;
    CGFloat offsetAtBottom = -keyboardEndHeight;
    if (fabs(newOffset - offsetAtBottom) < 400.0f) {
        newOffset = offsetAtBottom; // keep them on the most recent message when they're near it
    }
    if (tableView.isDragging && willDismissKeyboard) {
        self.calculatedOffsetFromInteractiveKeyboardDismissal = @(newOffset);
    } else {
        tableView.contentOffset = CGPointMake(0, newOffset);
    }
    tableView.contentInset = UIEdgeInsetsMake(keyboardEndHeight, 0, self.topInset, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(keyboardEndHeight, 0, self.topInset, 0);
}

- (void)dismissKeyboard {
    if ([self.toolbar.textInputNode isFirstResponder]) [self.toolbar.textInputNode resignFirstResponder];
}

#pragma mark - ASTableDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.calculatedOffsetFromInteractiveKeyboardDismissal) {
        *targetContentOffset = CGPointMake(0, self.calculatedOffsetFromInteractiveKeyboardDismissal.doubleValue);
        self.calculatedOffsetFromInteractiveKeyboardDismissal = nil;
    }
}

#pragma mark - Toolbar

- (BOOL)canBecomeFirstResponder { return YES; }
- (UIView *)inputAccessoryView { return self.toolbarContainerView; }


@end
