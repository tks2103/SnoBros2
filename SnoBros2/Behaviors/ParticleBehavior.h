//
//  ParticleBehavior.h
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/29/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Behavior.h"

@interface ParticleBehavior : Behavior

- (id)initWithEntity:(Entity *)entity;
- (id)initWithEntity:(Entity *)entity dictionary:(NSDictionary *)data;

- (void)update;

@end
