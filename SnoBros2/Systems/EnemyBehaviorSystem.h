//
//  EnemyBehaviorSystem.h
//  SnoBros2
//
//  Created by Cjab on 12/10/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameSystem.h"

@class EntityManager;
@class Quadtree;

@interface EnemyBehaviorSystem : NSObject <GameSystem> {
  EntityManager *entityManager_;
}

- (id)initWithEntityManager:(EntityManager *)entityManager;

- (void)update;

@end