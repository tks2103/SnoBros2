//
//  Sprite.m
//  Component
//
//  Created by Chad Jablonski on 11/4/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

@synthesize vertices        = vertices_;
@synthesize uvMap           = uvMap_;
@synthesize texture         = texture_;
@synthesize tag             = tag_;
@synthesize children        = children_;
@synthesize parent          = parent_;
@synthesize visible         = visible_;

- (id)initWithFile:(NSString *)filePath tag:(NSString *)tag {
  self = [super init];
  if (self) {
    texture_  = [GLKTextureLoader
                 textureWithCGImage:[UIImage imageNamed:filePath].CGImage
                 options:nil
                 error:nil];
    
    float halfWidth  = texture_.width  / 2.f;
    float halfHeight = texture_.height / 2.f;
    
    vertices_    = malloc(sizeof(GLKVector2) * 4);
    vertices_[0] = GLKVector2Make(-halfWidth,  halfHeight);
    vertices_[1] = GLKVector2Make(-halfWidth, -halfHeight);
    vertices_[2] = GLKVector2Make( halfWidth, -halfHeight);
    vertices_[3] = GLKVector2Make( halfWidth,  halfHeight);
    
    
    uvMap_    = malloc(sizeof(GLKVector2) * 4);
    uvMap_[0] = GLKVector2Make(0, 1);
    uvMap_[1] = GLKVector2Make(0, 0);
    uvMap_[2] = GLKVector2Make(1, 0);
    uvMap_[3] = GLKVector2Make(1, 1);
    
    modelViewMatrix_  = GLKMatrix4Identity;
    children_         = [[NSMutableArray alloc] init];
    parent_           = nil;
    visible_          = TRUE;
    tag_              = tag;
  }
  return self;
}



- (void)dealloc {
  free(vertices_);
  free(uvMap_);
}



- (void)addChild:(Sprite *)child {
  child.parent = self;
  [children_ addObject:child];
}



- (void)addChildren:(NSMutableArray *)children {
  for (Sprite *child in children) {
    [self addChild:child];
  }
}



- (unsigned)width {
  return texture_.width;
}



- (unsigned)height {
  return texture_.height;
}



- (GLKMatrix4)modelViewMatrix {
  if (parent_ != nil) {
    return GLKMatrix4Multiply(parent_.modelViewMatrix, modelViewMatrix_);
  }
  return modelViewMatrix_;
}



- (void)translate:(GLKVector2)translation {
  modelViewMatrix_ = GLKMatrix4Translate(modelViewMatrix_, translation.x, translation.y, 0);
}



- (void)cropByPercent:(float)percent {
  int halfWidth = self.width / 2.f;
  int halfHeight = self.height / 2.f;
  
  int cropEdge = MIN(percent * 2 * halfWidth - halfWidth, halfWidth);
  vertices_[0] = GLKVector2Make(-halfWidth,  halfHeight);
  vertices_[1] = GLKVector2Make(-halfWidth, -halfHeight);
  vertices_[2] = GLKVector2Make(  cropEdge, -halfHeight);
  vertices_[3] = GLKVector2Make(  cropEdge,  halfHeight);
}

@end