//
//  ParticleSystem.m
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "ParticleSystem.h"
#import "ParticleGenerator.h"
#import "Transform.h"
#import "Entity.h"
#import "Physics.h"
#import "Particle.h"

@implementation ParticleSystem

- (id)initWithEntity:(Entity *)entity {
  self = [super initWithEntity:entity];
  if (self) {
    
  }
  return self;
}



- (id)initWithEntity:(Entity *)entity dictionary:(NSDictionary *)data {
  self = [self initWithEntity:entity];
  if (self) {
    particleGenerator_  = [[ParticleGenerator alloc] initWithEmissionTimer:10
                                                         particlesEmitted:500
                                                        standardDeviation:.3];
  }
  return self;
}



- (void)update {
  int numParticles = [particleGenerator_ getNumberOfParticlesGenerated];
  for (int i = 0; i<numParticles; i++) {
    Transform *transform = [entity_ getComponentByString:@"Transform"];
    void (^callback)(Entity *) = ^(Entity *particle){
      Transform  *partTransform   = [particle getComponentByString:@"Transform"];
      Physics    *partPhysics     = [particle getComponentByString:@"Physics"];
      //Particle   *partParticle    = [particle getComponentByString:@"Particle"];
      
      partTransform.position  = transform.position;
      partTransform.previousPosition = transform.position;
      //NSLog(@"Posx: %f, Posy: %f", transform.position.x, transform.position.y);
      partPhysics.velocity    = GLKVector2Make((double)arc4random() / UINT32_MAX * 1.5 - 0.75,
                                               (double)arc4random() / UINT32_MAX * 1.5 - 0.75);
    };
    NSDictionary *data = @{@"type": @"Particle", @"callback": callback};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createEntity"
                                                        object:self
                                                      userInfo:data];
     
  }
}

@end
