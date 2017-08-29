//
//  MXRMessenger.h
//  Pods
//
//  Created by Scott Kensell on 8/28/17.
//
//

#ifndef MXRMessenger_h
#define MXRMessenger_h

#ifndef MXR_MESSAGE_CELL
#define MXR_MESSAGE_CELL __has_include(<MXRMessenger/MXRMessageCell.h>)
#endif

#ifndef MXR_MESSENGER_VC
#define MXR_MESSENGER_VC __has_include(<MXRMessenger/MXRMessengerViewController.h>)
#endif

// core
#import <MXRMessenger/MXRGrowingEditableTextNode.h>
#import <MXRMessenger/MXRMessengerMedium.h>
#import <MXRMessenger/UIBezierPath+MXRMessenger.h>
#import <MXRMessenger/UIColor+MXRMessenger.h>
#import <MXRMessenger/UIImage+MXRMessenger.h>


// message cell
#if MXR_MESSAGE_CELL
#import <MXRMessenger/MXRMessageCell.h>
#endif


// view controller
#if MXR_MESSENGER_VC
#import <MXRMessenger/MXRMessengerViewController.h>
#import <MXRMessenger/MXRMessengerNode.h>
#import <MXRMessenger/MXRMessengerInputToolbar.h>
#endif

#endif /* MXRMessenger_h */
