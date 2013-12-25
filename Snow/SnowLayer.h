//
//  HelloWorldLayer.h
//  Snow
//
//  Created by Ben K on 2013-10-25.
//  Copyright Ben K 2013. All rights reserved.
//


// HelloWorldLayer
@interface SnowLayer : CCLayer {
  NSMutableArray *snowflakes;
  
  NSPoint cursorPos;
  
  NSEvent *eventHandler;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (void)mouseMoved:(NSEvent *)event;

@end
