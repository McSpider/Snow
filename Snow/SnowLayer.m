//
//  HelloWorldLayer.m
//  Snow
//
//  Created by Ben K on 2013-10-25.
//  Copyright Ben K 2013. All rights reserved.
//


// Import the interfaces
#import "SnowLayer.h"

// HelloWorldLayer implementation
@implementation SnowLayer

+ (CCScene *)scene
{
  // 'scene' is an autorelease object.
  CCScene *scene = [CCScene node];
  
  // 'layer' is an autorelease object.
  SnowLayer *layer = [SnowLayer node];
  
  // add layer as a child to scene
  [scene addChild: layer];
  
  // return the scene
  return scene;
}

// on "init" you need to initialize your instance
- (id)init
{
  if ((self = [super init])) {
    [self scheduleUpdateWithPriority:0];
    [self schedule:@selector(addSnowFlake) interval:0.05];

    snowflakes = [[NSMutableArray alloc] init];
    [self addChild:[[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 100)] z:-1];
    
    
    eventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask | NSRightMouseDraggedMask | NSLeftMouseDraggedMask handler:^(NSEvent * mouseEvent) {
      [self mouseMoved:mouseEvent];
    }];

  }
  return self;
}

- (void)update:(ccTime)deltaTime
{
  cursorPos = [NSEvent mouseLocation];
  CGSize size = [[CCDirector sharedDirector] winSize];
  
  NSMutableArray *removeFlakes = [[NSMutableArray alloc] init];
  for (CCSprite *flake in snowflakes) {
    if (flake.tag == 999) {
      [removeFlakes addObject:flake];
      continue;
    }
    if (flake.tag > 50)
      flake.rotation += ((uint)flake.tag-50) * deltaTime;
    else {
      flake.rotation -= ((uint)flake.tag) * deltaTime;
    }
    
    int cursorMargin = size.width;
    
    if (flake.position.x + cursorMargin > cursorPos.x && flake.position.x - cursorMargin < cursorPos.x &&
        flake.position.y > 1 && (flake.tag < 75 && flake.tag > 25)) {

      if (flake.position.x + cursorMargin > cursorPos.x && flake.position.x + 0 < cursorPos.x) {
        float offset = (50 * deltaTime) * (size.width - (cursorPos.x - flake.position.x))/(size.width/1);
        flake.position = CGPointMake(flake.position.x - offset, flake.position.y);
      } if (flake.position.x - cursorMargin < cursorPos.x && flake.position.x - 0 > cursorPos.x) {
        float offset = (50 * deltaTime) * (size.width - (flake.position.x - cursorPos.x))/(size.width/1);
        flake.position = CGPointMake(flake.position.x + offset, flake.position.y);
      }
    }
  }
  [snowflakes removeObjectsInArray:removeFlakes];
  [removeFlakes release];
}

- (void)spriteMoveFinished:(id)sender
{
  CCSprite *sprite = (CCSprite *)sender;
  [snowflakes removeObject:sender];
  [self removeChild:sprite cleanup:YES];
}

-(void)addSnowFlake
{
  CGSize size = [[CCDirector sharedDirector] winSize];
  int screenWidth = size.width;
  int screenHeight = size.height;
  
  int y = screenHeight + 16;
  
  CCSprite *snowflake = [CCSprite spriteWithFile:[NSString stringWithFormat:@"snowflake%i.png",(arc4random() % 3) + 1]];
  [snowflake setTag:(arc4random() % 100)];
  
  int snowFlakeX = (arc4random() % (screenWidth+200))-100;
  
  snowflake.position = ccp(snowFlakeX, y);
  int RandOpacity = (arc4random() % 155) + 100;
  
  snowflake.opacity = RandOpacity;
  
  int scalesnow = (arc4random() % 3);
  
  if (scalesnow == 0) {
    snowflake.scale = .85;
  } if (scalesnow == 1) {
    snowflake.scale = 0.75;
  }  if (scalesnow == 2) {
    snowflake.scale = 0.65;
  }
  
  snowflake.rotation = 10;
  
  // Determine speed of the target
  int minDuration = 5.0;
  int maxDuration = 10.0;
  int rangeDuration = (maxDuration - minDuration) + minDuration;
  
  int actualDuration = (arc4random() % rangeDuration) + minDuration;
  
  // Create the actions
  CGPoint targetPos = ccp(snowFlakeX + ((arc4random() % (screenWidth/2))-(screenWidth/4)), (arc4random() % 16));
  id actionMove = [CCMoveTo actionWithDuration:actualDuration position:targetPos];
  id actionFreeze = [CCCallFuncN actionWithTarget:self selector:@selector(freezeFlake:)];
  id actionFade = [CCFadeTo actionWithDuration:(arc4random() % 8) + 2 opacity:0];
  id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
  CCSequence *seq = [CCSequence actions:actionMove, actionFreeze, actionFade, actionMoveDone, nil];
  seq.tag = 1;
  [snowflake runAction:seq];
  [self addChild:snowflake];
  [snowflakes addObject:snowflake];
}

- (void)freezeFlake:(id)sender
{
  CCSprite *sprite = (CCSprite *)sender;
  sprite.tag = 999;
}

- (void)checkTerminateState {
  cursorPos = [NSEvent mouseLocation];
  CGSize size = [[CCDirector sharedDirector] winSize];

  if (NSPointInRect(cursorPos, NSMakeRect(50, 0, size.width-100, 1))) {
    [[[[[CCDirector sharedDirector] view] window] animator] setAlphaValue:0.0f];
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:1];
  }
}

- (void)mouseMoved:(NSEvent *)event
{
  cursorPos = [event locationInWindow];
  CGSize size = [[CCDirector sharedDirector] winSize];

  if (NSPointInRect(cursorPos, NSMakeRect(50, 0, size.width-100, 1))) {
    [self performSelector:@selector(checkTerminateState) withObject:nil afterDelay:3];
  } else {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkTerminateState) object:nil];
  }
}


// on "dealloc" you need to release all your retained objects
- (void)dealloc
{
  // in case you have something to dealloc, do it in this method
  // in this particular example nothing needs to be released.
  // cocos2d will automatically release all the children (Label)
  [NSEvent removeMonitor:eventHandler];
  
  // don't forget to call "super dealloc"
  [super dealloc];
}
@end
