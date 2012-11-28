//
//  ParticleGenerator.m
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "ParticleGenerator.h"

@implementation ParticleGenerator

- (id)initWithEmissionTimer:(float)targetEmissionTimer
           particlesEmitted:(float)particlesEmitted
          standardDeviation:(float)standardDeviation {
  self = [super init];
  if (self) {
    targetEmissionTimer_  = targetEmissionTimer;
    particlesEmitted_     = particlesEmitted;
    standardDeviation_    = standardDeviation;
    particleEmissionRate_ = particlesEmitted / targetEmissionTimer * 1/60.f;
  }
  return self;
}



- (int)getNumberOfParticlesGenerated {
  return MAX(round([self randomGaussian] * standardDeviation_ + particleEmissionRate_), 0);
}



- (float)randomGaussian {
  float u1 = (double)arc4random() / UINT32_MAX; // uniform distribution
  float u2 = (double)arc4random() / UINT32_MAX; // uniform distribution
  float f1 = sqrt(-2 * log(u1));
  float f2 = 2 * M_PI * u2;
  float g1 = f1 * cos(f2); // gaussian distribution
  return g1;
}

@end
