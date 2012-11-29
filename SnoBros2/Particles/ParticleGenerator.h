//
//  ParticleGenerator.h
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import <Foundation/Foundation.h>

// takes 3 parameters: targetEmissionTimer, particlesEmitted, standardDeviation
// particlegenerator tries to generate particlesEmitter particles over a time period of targetEmissionTimer
// particlegenerator figures out the average number of particles that would need to be emitted each update cycle in order to emit particlesEmitted particles over targetEmissionTimer seconds
// particlegenerator then fits a gaussian distribution centered around the average number of particles that should be emitted each update with a standard deviation of standardDeviation. it uses that distribution to determine the number of particles actually emitted each update.

@interface ParticleGenerator : NSObject {
  float targetEmissionTimer_;
  float particlesEmitted_;
  float particleEmissionRate_;
  float standardDeviation_;
  float totalTime_;
  float particlesGenerated_;
  float accumulator_;
}

- (id)initWithEmissionTimer:(float)targetEmissionTimer
           particlesEmitted:(float)particlesEmitted
          standardDeviation:(float)standardDeviation;
- (void)update;
- (void)pause;
- (void)unpause;
- (int)getNumberOfParticlesGenerated;
- (float)randomGaussian;

@end
