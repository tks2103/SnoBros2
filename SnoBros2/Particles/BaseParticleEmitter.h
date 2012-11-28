//
//  BaseParticleEmitter.h
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseParticleEmitter : NSObject {
  CGPoint     origin;
  float       particleLifetime;
  float       emissionRate;
  
}

@end
