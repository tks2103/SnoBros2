//
//  Particle.m
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Particle.h"

@implementation Particle

- (id)initWithEntity:(Entity *)entity {
  self = [super initWithEntity:entity];
  if (self) {
    
  }
  return self;
}



- (id)initWithEntity:(Entity *)entity dictionary:(NSDictionary *)data {
  self = [self initWithEntity:entity];
  if (self) {
    lifetime_ = [data[@"Lifetime"] floatValue];
    timelived_ = 0;
  }
  return self;
}



- (void)update {
  timelived_ += 1/60.f;
  if (timelived_ > lifetime_) {
    //NSLog(@"time");
    [self destroy];
  }
}



- (void)destroy {
  NSDictionary *destroyData = @{@"entity": entity_};
  [[NSNotificationCenter defaultCenter] postNotificationName:@"destroyEntity"
                                                      object:self
                                                    userInfo:destroyData];
  //NSLog(@"TIMED OUT!");
}

@end
