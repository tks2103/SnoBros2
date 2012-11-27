//
//  CollisionSystem.h
//  SnoBros2
//
//  Created by Chad Jablonski on 11/20/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entity;
@class EntityManager;

@interface CollisionSystem : NSObject {
  EntityManager *entityManager_;
}

- (id)initWithEntityManager:(EntityManager *)entityManager;

- (void)update;
- (void)checkCollisionsFor:(Entity *)entity;
- (bool)didEntity:(Entity *)entity collideWith:(Entity *)other;

@end