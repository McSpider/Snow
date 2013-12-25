//
//  AppDelegate.h
//  Snow
//
//  Created by Ben K on 2013-10-24.
//  Copyright (c) 2013 Ben K. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TransparentWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
  TransparentWindow *fullWindow;
  IBOutlet CCGLView	*glView;
  IBOutlet NSView *fullView;  
}

@property (assign) IBOutlet NSWindow *window;


@end
