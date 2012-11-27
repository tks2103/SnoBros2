//
//  RenderSystem.m
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/24/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "RenderSystem.h"

#import "Entity.h"
#import "EntityManager.h"
#import "Camera.h"
#import "Transform.h"
#import "Sprite.h"
#import "SpriteManager.h"
#import "SceneGraph.h"
#import "SceneNode.h"

@implementation RenderSystem

- (id)initWithEntityManager:(EntityManager *)entityManager camera:(Camera *)camera {
  self = [super init];
  if (self) {
    entityManager_  = entityManager;
    spriteManager_  = [[SpriteManager alloc] init];
    [spriteManager_ loadEntityTypesFromFile:@"sprites"];
    [spriteManager_ debug];
    camera_         = camera;
  }
  return self;
}



- (void)renderEntitieswithInterpolationRatio:(double)ratio {
  for (Entity *e in [entityManager_ allSortedByLayer]) {
    [self renderEntity:e withInterpolationRatio:ratio];
  }
}



- (void)renderEntity:(Entity *)entity withInterpolationRatio:(double)ratio {
  Transform   *transform  = [entity getComponentByString:@"Transform"];
  SceneGraph  *sceneGraph = [entity getComponentByString:@"SceneGraph"];
  GLKVector2  position    = GLKVector2Lerp(transform.previousPosition,
                                           transform.position,
                                           ratio);
  GLKMatrix4  modelViewMatrix = GLKMatrix4MakeTranslation(position.x,
                                                          position.y,
                                                          sceneGraph.layer);
  [sceneGraph updateRootModelViewMatrix:modelViewMatrix];
  [self renderSceneGraph:sceneGraph];
}



- (void)renderSceneGraph:(SceneGraph *)sceneGraph {
  [self renderSceneNode:sceneGraph.rootNode];
}



- (void)renderSceneNode:(SceneNode *)sceneNode {
  if (sceneNode.visible == FALSE) {
    return;
  }
  GLKBaseEffect *effect = [self generateBaseEffectWithSceneNode:sceneNode];
  Sprite        *sprite = [spriteManager_ getSpriteWithRef:sceneNode.spriteRef];
  [effect prepareToDraw];
  [self drawSprite:sprite];
  if (sceneNode.children != nil) {
    for (SceneNode *child in sceneNode.children) {
      [self renderSceneNode:child];
    }
  }
}



- (GLKBaseEffect *)generateBaseEffectWithSceneNode:(SceneNode *)sceneNode {
  GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
  Sprite *sprite = [spriteManager_ getSpriteWithRef:sceneNode.spriteRef];
  
  effect.texture2d0.envMode = GLKTextureEnvModeReplace;
  effect.texture2d0.target  = GLKTextureTarget2D;
  effect.texture2d0.name    = sprite.texture.name;
  
  float left   = camera_.position.x;
  float right  = camera_.viewport.x + camera_.position.x;
  float bottom = camera_.viewport.y + camera_.position.y;
  float top    = camera_.position.y;
  float near   = -16.f;
  float far    =  16.f;
  
  effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, near, far);
  effect.transform.modelviewMatrix  = sceneNode.modelViewMatrix;
  return effect;
}



- (void)drawSprite:(Sprite *)sprite {
  glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
  glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT,
                        GL_FALSE, 0, sprite.uvMap);
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT,
                        GL_FALSE, 0, sprite.vertices);
  
  glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
  glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

@end