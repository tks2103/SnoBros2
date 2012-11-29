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
    NSScanner *scanner;
    unsigned int rgbVal;
    
    scanner = [NSScanner scannerWithString:data[@"StartColor"]];
    [scanner scanHexInt:&rgbVal];
    color_        = GLKVector4Make(((float) ((rgbVal & 0xFF000000) >> 24))/255.f,
                                   ((float) ((rgbVal & 0xFF0000  ) >> 16))/255.f,
                                   ((float) ((rgbVal & 0xFF00    ) >>  8))/255.f,
                                    (float)  (rgbVal & 0xFF      )        /255.f);

    scanner = [NSScanner scannerWithString:data[@"EndColor"]];
    [scanner scanHexInt:&rgbVal];
    targetColor_  = GLKVector4Make(((float) ((rgbVal & 0xFF000000) >> 24))/255.f,
                                   ((float) ((rgbVal & 0xFF0000  ) >> 16))/255.f,
                                   ((float) ((rgbVal & 0xFF00    ) >>  8))/255.f,
                                    (float)  (rgbVal & 0xFF      )        /255.f);
    
    timelived_ = 0;
  }
  return self;
}



- (void)update {
  timelived_ += 1/60.f;
  if (timelived_ > lifetime_) {
    [self destroy];
  }
  float q = GLKVector4Distance(color_, targetColor_);
  int p = ceil(GLKVector4Distance(color_, targetColor_));
  if ( GLKVector4Distance(color_, targetColor_) > 0.01) {
    GLKVector4 heading = GLKVector4Subtract(targetColor_, color_);
    GLKVector4 unitHeading = GLKVector4Normalize(heading);
    GLKVector4 displacement = GLKVector4DivideScalar(unitHeading, 50);
    [self translateColor:displacement];
  } else {
    /*targetColor_ = GLKVector4Make(color_.r + 0.1,
                                  color_.g + (float)arc4random() / UINT32_MAX / 10 - 0.05,
                                  color_.b + (float)arc4random() / UINT32_MAX / 10 - 0.05,
                                  0.4);
    targetColor_ = GLKVector4Make((float)arc4random() / UINT32_MAX,
                                  (float)arc4random() / UINT32_MAX,
                                  (float)arc4random() / UINT32_MAX,
                                  (float)arc4random() / UINT32_MAX);*/
  }
}



- (void)destroy {
  NSDictionary *destroyData = @{@"entity": entity_};
  [[NSNotificationCenter defaultCenter] postNotificationName:@"destroyEntity"
                                                      object:self
                                                    userInfo:destroyData];
}



- (void)translateColor:(GLKVector4)colorTranslation {
  color_ = GLKVector4Add(color_, colorTranslation);
}

@end
