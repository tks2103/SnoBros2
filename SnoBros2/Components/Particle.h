//
//  Particle.h
//  SnoBros2
//
//  Created by Tanoy Sinha on 11/28/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Component.h"
#import <GLKit/GLKit.h>

@interface Particle : Component {
  float       lifetime_;
  float       timelived_;
  GLKVector4  color_;
  GLKVector4  targetColor_;
}

@property (nonatomic) GLKVector4 color;
@property (nonatomic) GLKVector4 targetColor;
@property (nonatomic) float      lifetime;

- (id)initWithEntity:(Entity *)entity;
- (id)initWithEntity:(Entity *)entity dictionary:(NSDictionary *)data;

- (void)update;
- (void)destroy;
- (void)translateColor:(GLKVector4)colorTranslation;

@end
