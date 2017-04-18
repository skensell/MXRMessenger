//
//  MXRGrowingEditableTextNode.h
//  Mixer
//
//  Created by Scott Kensell on 3/5/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

/**
 * An editable text node which observes changes to the underlying textView's
 * text and notifies whenever a line break occurs.
 */
@interface MXRGrowingEditableTextNode : ASEditableTextNode

@end
