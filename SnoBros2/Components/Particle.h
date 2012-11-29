//
//  Particle.h
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Component.h"

@interface Particle : Component {
  float lifetime_;
  float timelived_;
}

- (id)initWithEntity:(Entity *)entity;
- (id)initWithEntity:(Entity *)entity dictionary:(NSDictionary *)data;

- (void)update;
- (void)destroy;

@end
