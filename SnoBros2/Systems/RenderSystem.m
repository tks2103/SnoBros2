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
#import "Health.h"
#import "Particle.h"

@implementation RenderSystem

- (id)initWithEntityManager:(EntityManager *)entityManager camera:(Camera *)camera {
  self = [super init];
  if (self) {
    entityManager_  = entityManager;
    spriteManager_  = [[SpriteManager alloc] init];
    [spriteManager_ loadEntityTypesFromFile:@"sprites"];
    camera_         = camera;
    effect_         = [[GLKBaseEffect alloc] init];
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
  Health      *health     = [entity getComponentByString:@"Health"];
  Particle    *particle   = [entity getComponentByString:@"Particle"];

  GLKVector2  scale             = transform.scale;
  GLKVector2  position          = GLKVector2Lerp(transform.previousPosition,
                                                 transform.position,
                                                 ratio);
  GLKMatrix4  translationMatrix = GLKMatrix4MakeTranslation(position.x,
                                                            position.y,
                                                            sceneGraph.layer);
  GLKMatrix4  scaleMatrix       = GLKMatrix4MakeScale(scale.x, scale.y, 1.f);
  GLKMatrix4  modelViewMatrix   = GLKMatrix4Multiply(translationMatrix,
                                                     scaleMatrix);

  if (health != nil) {
    [self transformHealthBar:[sceneGraph getNodeByName:health.spriteName] withHealthComponent:health];
  }
  
  if (particle != nil) {
    [self transformParticle:[sceneGraph getNodeByName:@"Particle"] withParticleComponent:particle];
  }

  [sceneGraph updateRootModelViewMatrix:modelViewMatrix];
  [self renderSceneGraph:sceneGraph];
}



- (void)renderSceneGraph:(SceneGraph *)sceneGraph {
  [self renderSceneNode:sceneGraph.rootNode];
}



- (void)renderSceneNode:(SceneNode *)node {
  if (node.visible == FALSE) {
    return;
  }
  [self generateBaseEffectWithSceneNode:node];
  Sprite *sprite = [spriteManager_ getSpriteWithRef:node.spriteName];
  [effect_ prepareToDraw];
  [self drawSprite:sprite];
  if (node.children != nil) {
    for (SceneNode *child in node.children) {
      [self renderSceneNode:child];
    }
  }
}



- (void)transformHealthBar:(SceneNode *)node withHealthComponent:(Health *)health {
  Sprite *parentSprite = [spriteManager_ getSpriteWithRef:node.parent.spriteName];
  float percent = health.health / health.maxHealth;
  float ytrans = -(parentSprite.height/2.f) -5;

  node.modelViewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeScale(percent, 1, 1),
                                            GLKMatrix4MakeTranslation(0, ytrans, 0));
  node.visible = health.visible;
}



- (void)transformParticle:(SceneNode *)node withParticleComponent:(Particle *)particle {
  node.GLKTextureEnvMode = GLKTextureEnvModeModulate;
  node.color = particle.color;
}



- (void)generateBaseEffectWithSceneNode:(SceneNode *)node {
  //GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
  Sprite *sprite = [spriteManager_ getSpriteWithRef:node.spriteName];

  effect_.texture2d0.envMode = node.GLKTextureEnvMode;
  effect_.texture2d0.target  = GLKTextureTarget2D;
  effect_.texture2d0.name    = sprite.texture.name;
  effect_.useConstantColor   = YES;
  effect_.constantColor      = node.color;

  float left   = camera_.position.x;
  float right  = camera_.viewport.x + camera_.position.x;
  float bottom = camera_.viewport.y + camera_.position.y;
  float top    = camera_.position.y;
  float near   = -16.f;
  float far    =  16.f;

  effect_.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, near, far);
  effect_.transform.modelviewMatrix  = node.modelViewMatrix;
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
