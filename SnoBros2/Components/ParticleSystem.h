//
//  ParticleSystem.h
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Component.h"

@class ParticleGenerator;

@interface ParticleSystem : Component {
  ParticleGenerator *particleGenerator_;
}

- (id)initWithEntity:(Entity *)entity;
- (id)initWithEntity:(Entity *)entity dictionary:(NSDictionary *)data;

- (void)update;

@end
