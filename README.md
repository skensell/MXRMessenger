# MXRMessenger

<!-- [![CI Status](http://img.shields.io/travis/Scott Kensell/MXRMessenger.svg?style=flat)](https://travis-ci.org/Scott Kensell/MXRMessenger) -->
[![Version](https://img.shields.io/cocoapods/v/MXRMessenger.svg?style=flat)](http://cocoapods.org/pods/MXRMessenger)
[![License](https://img.shields.io/cocoapods/l/MXRMessenger.svg?style=flat)](http://cocoapods.org/pods/MXRMessenger)
[![Platform](https://img.shields.io/cocoapods/p/MXRMessenger.svg?style=flat)](http://cocoapods.org/pods/MXRMessenger)

## Why Another Chat Library?

MXRMessenger is a customizable chat library meant to provide a smooth-scrolling, responsive experience.  I felt the need to write it because

- [NMessenger](https://github.com/eBay/NMessenger) is Swift-only: see https://github.com/eBay/NMessenger/issues/40
- [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) is UIKit-based and was the library we were using until we experienced stability and performance issues.  It is also no longer being maintained.
- I could not find another [Texture](http://texturegroup.org) (or ASDK) chat library which was lightweight and customizable enough. Sometimes they depend on [SlackTextViewController](https://github.com/slackhq/slacktextviewcontroller#core) which is a good library, but I thought probably overkill for our needs.

That said, if you have never worked with [Texture](http://texturegroup.org), you are probably better off choosing one of the more mature libraries linked above. This library is also hardly tested and used by only 1 app so far in production, so use at your own risk. 

## Features

<div>
    <img alt="Screenshot 1" src="http://i.imgur.com/ZDwOu2j.png" width="325px" />
    <img alt="Screenshot 2" src="http://i.imgur.com/7EYT5HQ.png" width="325px" />
</div>

The `MXRMessengerViewController` is like a baby version of the [SlackTextViewController](https://github.com/slackhq/slacktextviewcontroller#core) and can be included on its own with `pod 'MXRMessenger/ViewController'`. It features

- An input toolbar which you can dismiss interactively.
- A growing input text node with a max number of lines.
- Customizable fonts, colors, and buttons.

The other subspec `pod 'MXRMessenger/MessageCell'` provides Facebook-style bubbles and a friendly factory. Main features:

- Send text, image, video, or multiple images/video at the same time.
- Rounded corners which dynamically update to group messages from the same sender.
- Automatic date formatting.
- Images dynamically update their size to true aspect ratio when sent 1 at a time.
- Copy, Delete, and easy opt-in menu items.
- Tap/gesture callbacks.
- Fully customizable, whether it's left-to-right, no avatar, spacing issues, font or color issues, a lot is customizable.

And since we are dependent on [Texture](http://texturegroup.org), you get 60 fps smoothness for free.

## Installation

MXRMessenger is available through [CocoaPods](http://cocoapods.org).

For the full chat library, add `pod 'MXRMessenger'` to your Podfile.

For just the ViewController add `pod 'MXRMessenger/ViewController'`.

For just the Facebook-style bubbles add `pod 'MXRMessenger/MessageCell'`.

Where necessary, add

```Obj-C
#import <MXRMessenger/MXRMessenger.h>
```

## Use

Subclass `MXRMessengerViewController`.  Then, the easiest way to instantiate message cells is with the provided `MXRMessageCellFactory`. So create a strong property:

```Obj-C
@property (nonatomic, strong) MXRMessageCellFactory* cellFactory;
```

Most customizations happen at init.  You can copy-paste the following code and just remove or customize whatever you want. And then implement the delegate or datasource methods the compiler complains about.

```Obj-C
- (instancetype)init {
    MXRMessengerInputToolbar* toolbar = [[MXRMessengerInputToolbar alloc] initWithFont:[UIFont systemFontOfSize:16.0f] placeholder:@"Type a message" tintColor:[UIColor mxr_fbMessengerBlue]];
    self = [super initWithToolbar:toolbar];
    if (self) {
        // add extra buttons to toolbar
        MXRMessengerIconButtonNode* addPhotosBarButtonButtonNode = [MXRMessengerIconButtonNode buttonWithIcon:[[MXRMessengerPlusIconNode alloc] init] matchingToolbar:self.toolbar];
        [addPhotosBarButtonButtonNode addTarget:self action:@selector(tapAddPhotos:) forControlEvents:ASControlNodeEventTouchUpInside];
        self.toolbar.leftButtonsNode = addPhotosBarButtonButtonNode;
        [self.toolbar.defaultSendButton addTarget:self action:@selector(tapSend:) forControlEvents:ASControlNodeEventTouchUpInside];    
    
        // delegate must be self for interactive keyboard, datasource can be whatever
        self.node.tableNode.delegate = self;
        self.node.tableNode.dataSource = self;
        [self customizeCellFactory];
    }
    return self
}

- (void)customizeCellFactory {
    MXRMessageCellLayoutConfiguration* layoutConfigForMe = [MXRMessageCellLayoutConfiguration rightToLeft];
    MXRMessageCellLayoutConfiguration* layoutConfigForOthers = [MXRMessageCellLayoutConfiguration leftToRight];
    
    MXRMessageAvatarConfiguration* avatarConfigForMe = nil;
    MXRMessageAvatarConfiguration* avatarConfigForOthers = [[MXRMessageAvatarConfiguration alloc] init];
    
    MXRMessageTextConfiguration* textConfigForMe = [[MXRMessageTextConfiguration alloc] initWithFont:nil textColor:[UIColor whiteColor] backgroundColor:[UIColor mxr_fbMessengerBlue]];
    MXRMessageTextConfiguration* textConfigForOthers = [[MXRMessageTextConfiguration alloc] initWithFont:nil textColor:[UIColor blackColor] backgroundColor:[UIColor mxr_bubbleLightGrayColor]];
    CGFloat maxCornerRadius = textConfigForMe.maxCornerRadius;
    
    MXRMessageImageConfiguration* imageConfig = [[MXRMessageImageConfiguration alloc] init];
    imageConfig.maxCornerRadius = maxCornerRadius;
    MXRMessageMediaCollectionConfiguration* mediaCollectionConfig = [[MXRMessageMediaCollectionConfiguration alloc] init];
    mediaCollectionConfig.maxCornerRadius = maxCornerRadius;
    
    textConfigForMe.menuItemTypes |= MXRMessageMenuItemTypeDelete;
    textConfigForOthers.menuItemTypes |= MXRMessageMenuItemTypeDelete;
    imageConfig.menuItemTypes |= MXRMessageMenuItemTypeDelete;
    imageConfig.showsUIMenuControllerOnLongTap = YES;
    CGFloat s = [UIScreen mainScreen].scale;
    imageConfig.borderWidth = s > 0 ? (1.0f/s) : 0.5f;
    
    MXRMessageCellConfiguration* cellConfigForMe = [[MXRMessageCellConfiguration alloc] initWithLayoutConfig:layoutConfigForMe avatarConfig:avatarConfigForMe textConfig:textConfigForMe imageConfig:imageConfig mediaCollectionConfig:mediaCollectionConfig];
    MXRMessageCellConfiguration* cellConfigForOthers = [[MXRMessageCellConfiguration alloc] initWithLayoutConfig:layoutConfigForOthers avatarConfig:avatarConfigForOthers textConfig:textConfigForOthers imageConfig:imageConfig mediaCollectionConfig:mediaCollectionConfig];
    
    self.cellFactory = [[MXRMessageCellFactory alloc] initWithCellConfigForMe:cellConfigForMe cellConfigForOthers:cellConfigForOthers];
    self.cellFactory.dataSource = self;
    self.cellFactory.contentNodeDelegate = self;
    self.cellFactory.mediaCollectionDelegate = self;
}

```

To create the message cells, you can implement the `ASTableDataSource` method like so
```Obj-C
- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message* message = self.messages[indexPath.row];
    if (message.media.count > 1) {
        return [self.cellFactory cellNodeBlockWithMedia:message.media tableNode:tableNode row:indexPath.row];
    } else if (message.media.count == 1) {
        MessageMedium* medium = message.media.firstObject;
        return [self.cellFactory cellNodeBlockWithImageURL:medium.photoURL showsPlayButton:(medium.videoURL != nil) tableNode:tableNode row:indexPath.row];
    } else {
        return [self.cellFactory cellNodeBlockWithText:message.text tableNode:tableNode row:indexPath.row];
    }
}
```
and to send a new message or update the table with new/old messages there is just one method on the `cellFactory`:
```Obj-C
- (void)updateTableNode:(ASTableNode*)tableNode animated:(BOOL)animated withInsertions:(NSArray<NSIndexPath*>*)insertions deletions:(NSArray<NSIndexPath*>*)deletions reloads:(NSArray<NSIndexPath*>*)reloads completion:(void(^)(BOOL))completion;

```


There are a few key assumptions to keep in mind:

- There is only one section: 0.
- The table is [inverted](http://texturegroup.org/docs/inversion.html) so insert new messages at (0,0).
- Timestamp headers are automatically shown for messages with a gap greater than 15 minutes, but you can disable this if you want. You can show/hide them programmatically through a method on the `cellFactory` (e.g. when the user taps the cell).
- Corner-rounding management happens by calling the `MXRMessageCellFactoryDataSource` methods for the current indexPath as well as its neighbors.  That means you should keep those methods quick - ideally they are just dictionary lookups.
- Showing media on tap is outside the scope of this library.  I have a Texture-based media viewer which I use and will hopefully open source some day.

For more details, it's probably best to check the example project.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory which has a `Podfile`.  Then open the `*.xcworkspace` file and build.

## Requirements

Texture 2.X and iOS 8+.

## Contributing

There are no tests at present. Keep PRs very small please.

## Author

Scott Kensell, skensell@gmail.com

## License

MXRMessenger is available under the MIT license. See the LICENSE file for more info.
