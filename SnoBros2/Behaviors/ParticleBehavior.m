//
//  ParticleBehavior.m
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/29/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "ParticleBehavior.h"
#import "Entity.h"
#import "Particle.h"

@implementation ParticleBehavior

- (id)initWithEntity:(Entity *)entity {
  return [super initWithEntity:entity];
}



- (id)initWithEntity:(Entity *)entity dictionary:(NSDictionary *)data {
  return [self initWithEntity:entity];
}



- (void)update {
}

@end
