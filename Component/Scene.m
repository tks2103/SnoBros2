//
//  Scene.m
//  Component
//
//  Created by Cjab on 11/6/12.
//  Copyright (c) 2012 Cjab. All rights reserved.
//

#import "Scene.h"
#import "LeftPlayer.h"
#import "RightPlayer.h"

@implementation Scene


- (id)init {
  self = [super init];
  if (self) {
    entities_      = [[NSMutableArray alloc] init];
    inputHandlers_ = [[NSMutableArray alloc] init];
    [entities_ addObject:[self setupMap]];
    [entities_ addObject:[self setupLeftPlayer]];
    [entities_ addObject:[self setupRightPlayer]];
  }
  return self;
}



- (void)update {
  for (Entity *e in entities_) {
    [e update];
  }
}



- (void)render {
  for (Entity *e in entities_) {
    [e render];
  }
}



- (void)addEntity:(Entity *)entity {
  [entities_ addObject:entity];
}



- (void)removeEntity:(Entity *)entity {
  [entities_ removeObject:entity];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UIResponder *input in inputHandlers_) {
    [input touchesBegan:touches withEvent:event];
  }
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UIResponder *input in inputHandlers_) {
    [input touchesBegan:touches withEvent:event];
  }
}



- (Entity *)setupLeftPlayer {
  Entity *player   = [[Entity alloc]    init];
  player.transform = [[Transform alloc] initWithEntity:player];
  player.sprite    = [[Sprite alloc]    initWithFile:@"player.png"];
  player.physics   = [[Physics alloc]   initWithEntity:player
                                             transform:player.transform];
  player.renderer  = [[Renderer alloc]  initWithEntity:player
                                             transform:player.transform
                                                sprite:player.sprite];
  player.behavior  = [[LeftPlayer alloc] initWithEntity:player
                                              transform:player.transform
                                                physics:player.physics
                                                  scene:self];
  player.input     = [[Input alloc]     initWithEntity:player
                                              behavior:player.behavior];
  
  [inputHandlers_ addObject:player.input];
  return player;
}



- (Entity *)setupRightPlayer {
  Entity *player   = [[Entity alloc]    init];
  player.transform = [[Transform alloc] initWithEntity:player];
  player.sprite    = [[Sprite alloc]    initWithFile:@"player.png"];
  player.physics   = [[Physics alloc]   initWithEntity:player
                                             transform:player.transform];
  player.renderer  = [[Renderer alloc]  initWithEntity:player
                                             transform:player.transform
                                                sprite:player.sprite];
  player.behavior  = [[RightPlayer alloc] initWithEntity:player
                                               transform:player.transform
                                                 physics:player.physics
                                                   scene:self];
  player.input     = [[Input alloc]     initWithEntity:player
                                              behavior:player.behavior];
  
  player.transform.position = GLKVector2Make(player.renderer.width,
                                             player.renderer.height);
  
  [inputHandlers_ addObject:player.input];
  return player;
}



- (Entity *)setupMap {
  Entity *map   = [[Entity alloc] init];
  map.transform = [[Transform alloc] initWithEntity:map];
  map.sprite    = [[Sprite alloc]    initWithFile:@"map.png"];
  map.renderer  = [[Renderer alloc]  initWithEntity:map
                                          transform:map.transform
                                             sprite:map.sprite];
  map.transform.position = GLKVector2Make(map.renderer.width  / 2.f,
                                          map.renderer.height / 2.f);
  return map;
}


@end