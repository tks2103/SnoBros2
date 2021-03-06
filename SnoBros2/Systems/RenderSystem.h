//
//  RenderSystem.h
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/24/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "GameSystem.h"

@class EntityManager;
@class ShaderManager;
@class Entity;
@class CameraSystem;
@class Sprite;
@class SpriteManager;
@class SceneGraph;
@class SceneNode;
@class Health;

@interface RenderSystem : NSObject <GameSystem> {
  EntityManager *entityManager_;
  ShaderManager *shaderManager_;
  SpriteManager *spriteManager_;
  CameraSystem        *camera_;
  
  NSMutableArray *entitiesToDraw_;
}

- (id)initWithEntityManager:(EntityManager *)entityManager
              spriteManager:(SpriteManager *)spriteManager
                     camera:(CameraSystem *)camera;

- (void)renderEntitieswithInterpolationRatio:(double)ratio;
- (void)renderEntity:(Entity *)entity withInterpolationRatio:(double)ratio;
- (void)renderSceneGraph:(SceneGraph *)sceneGraph;
- (void)renderSceneNode:(SceneNode *)node;

- (void)transformHealthBar:(SceneNode *)node withHealthComponent:(Health *)health;
- (void)update;
- (void)updateViewableEntities;

@end