//
//  Particle.m
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Particle.h"

@implementation Particle

@synthesize color       = color_;
@synthesize targetColor = targetColor_;
@synthesize lifetime    = lifetime_;

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
    color_        = GLKVector4Make([data[@"StartR"] floatValue],
                                   [data[@"StartG"] floatValue],
                                   [data[@"StartB"] floatValue],
                                   [data[@"StartA"] floatValue]);
    targetColor_  = GLKVector4Make([data[@"EndR"] floatValue],
                                   [data[@"EndG"] floatValue],
                                   [data[@"EndB"] floatValue],
                                   [data[@"EndA"] floatValue]);
    
    timelived_ = 0;
  }
  return self;
}



- (void)update {
  timelived_ += 1/60.f;
  if ( (int)ceil(GLKVector4Distance(color_, targetColor_)) != 0) {
    GLKVector4 heading = GLKVector4Subtract(targetColor_, color_);
    GLKVector4 unitHeading = GLKVector4Normalize(heading);
    GLKVector4 displacement = GLKVector4DivideScalar(unitHeading, 100);
    [self translateColor:displacement];
  }
  if (timelived_ > lifetime_) {
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



- (void)translateColor:(GLKVector4)colorTranslation {
  color_ = GLKVector4Add(color_, colorTranslation);
}

@end
