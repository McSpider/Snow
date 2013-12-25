//
//  AppDelegate.m
//  Snow
//
//  Created by Ben K on 2013-10-24.
//  Copyright (c) 2013 Ben K. All rights reserved.
//

#import "AppDelegate.h"
#import "SnowLayer.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  fullWindow = [[TransparentWindow alloc] initWithContentRect:[[NSScreen mainScreen] frame]
                                                    styleMask:NSBorderlessWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:YES screen:[NSScreen mainScreen]];
  
  [fullWindow setLevel:kCGDesktopIconWindowLevel-1]; //NSScreenSaverWindowLevel
  [fullWindow setOpaque:NO];
  [fullWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary];
  [fullWindow setIsMovable:NO];
    
  [fullWindow setContentView:fullView];
  [fullWindow setDelegate:self];
  [fullWindow setParentWindow:self.window];
  
  [fullWindow setIgnoresMouseEvents:YES];
  [fullWindow setAlphaValue:0];
  
  CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
  
  // enable FPS and SPF
  [director setDisplayStats:NO];
  
  [[glView opaqueAncestor] setAlphaValue:0];
  
  // connect the OpenGL view with the director
  [director setView:glView];
  
  GLint opaque = 0;
  [[NSColor clearColor] set];
  NSRectFill([[director view] bounds]);
  [[[director view] openGLContext] setValues:&opaque forParameter:NSOpenGLCPSurfaceOpacity];
  
  // set value for glClearColor
  glClearColor(0.0f,0.0f,0.0f,0.0f);
  glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

  
  // EXPERIMENTAL stuff.
  // 'Effects' don't work correctly when autoscale is turned on.
  // Use kCCDirectorResize_NoScale if you don't want auto-scaling.
  [director setResizeMode:kCCDirectorResize_NoScale];
  
  [director runWithScene:[SnowLayer scene]];
  
  [fullWindow orderFront:self];
  [[fullWindow animator] setAlphaValue:1.0f];
}

- (void)dealloc
{
  [[CCDirector sharedDirector] end];
  [fullWindow release];
  [super dealloc];
}


@end
