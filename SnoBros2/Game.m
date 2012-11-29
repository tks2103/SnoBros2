//
//  Game.m
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/18/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Game.h"
#import "Entity.h"
#import "Camera.h"

#import "EntityManager.h"
#import "InputSystem.h"
#import "CollisionSystem.h"
#import "RenderSystem.h"
#import "SelectionSystem.h"

#import "Transform.h"

@implementation Game

@synthesize camera          = camera_;
@synthesize entityManager   = entityManager_;
@synthesize selectionSystem = selectionSystem_;

- (id)init {
  self = [super init];
  if (self) {
    timestepAccumulatorRatio_ = 1.f;

    camera_          = [[Camera alloc] init];
    entityManager_   = [[EntityManager alloc] init];
    selectionSystem_ = [[SelectionSystem alloc]
                        initWithEntityManager:entityManager_];
    collisionSystem_ = [[CollisionSystem alloc]
                        initWithEntityManager:entityManager_];
    renderSystem_    = [[RenderSystem alloc]
                        initWithEntityManager:entityManager_ camera:camera_];

    [entityManager_ loadEntityTypesFromFile:@"entities"];
    [entityManager_ buildAndAddEntity:@"Map"];

    for (int i = 1; i <= 1; i++) {
      Entity *e = [entityManager_ buildAndAddEntity:@"Unit1"];
      Transform *transform = [e getComponentByString:@"Transform"];
      transform.position = GLKVector2Make(0.f, 60.f * i);
    }

    for (int i = 1; i <= 0; i++) {
      Entity *e = [entityManager_ buildAndAddEntity:@"Unit2"];
      Transform *transform = [e getComponentByString:@"Transform"];
      transform.position = GLKVector2Make(100.f, 60.f * i);
    }

    GLKVector2    target  = GLKVector2Make(60.f, 120.f);
    NSDictionary *panData = @{@"target": [NSValue value:&target
                                           withObjCType:@encode(GLKVector2)]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panCameraToTarget"
                                                        object:self
                                                      userInfo:panData];
  }
  return self;
}



- (void)update:(NSTimeInterval)elapsedTime {
  //NSLog(@"accumulator pre addition: %f Elapsed time: %f", timestepAccumulator_, elapsedTime);
  timestepAccumulator_ += elapsedTime;
  totalTimeElapsed_ += elapsedTime;
  //NSLog(@"accumulator post addtion: %f Elapsed time: %f", timestepAccumulator_, elapsedTime);
  int numSteps = MIN(timestepAccumulator_ / TIMESTEP_INTERVAL, MAX_STEPS);
  //NSLog(@"numSteps: %d", numSteps);
  if (numSteps > 0) {
    timestepAccumulator_ -= numSteps * TIMESTEP_INTERVAL;
  }
  //NSLog(@"accumulator post sub: %f numSteps * TI: %f", timestepAccumulator_, numSteps * TIMESTEP_INTERVAL);
  //NSLog(@"interval :%f", TIMESTEP_INTERVAL);
  timestepAccumulatorRatio_ = timestepAccumulator_ / TIMESTEP_INTERVAL;
  //NSLog(@"ratio: %f", timestepAccumulator_/TIMESTEP_INTERVAL);
  for (int i = 0; i < numSteps; i++) {
    [self step];
  }
  //NSLog(@"Total Time Elapsed %f", totalTimeElapsed_);
}



- (void)step {
  //NSLog(@"# of Entities: %d", [[entityManager_ allEntities] count]);
  for (Entity *e in [entityManager_ allEntities]) {
    [e update];
  }
  [collisionSystem_ update];
  [camera_ update];
  [entityManager_ processQueue];
  [entityManager_ update];
}



- (void)render {
  [renderSystem_ renderEntitieswithInterpolationRatio:timestepAccumulatorRatio_];
}

@end