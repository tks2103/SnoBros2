//
//  SelectionSystem.m
//  SnoBros2
//
//  Created by Chad Jablonski on 11/27/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "SelectionSystem.h"

#import "Entity.h"
#import "EntityManager.h"
#import "Selectable.h"
#import "Health.h"

@implementation SelectionSystem

- (id)initWithEntityManager:(EntityManager *)entityManager {
  self = [super init];
  if (self) {
    entityManager_ = entityManager;
  }
  return self;
}



- (NSArray *)findAllSelected {
  NSMutableArray *found = [[NSMutableArray alloc] init];

  for (Entity *e in [entityManager_ findAllWithComponent:@"Selectable"]) {
    Selectable *selectable = [e getComponentByString:@"Selectable"];
    if (selectable.selected == TRUE) {
      [found addObject:e];
    }
  }
  return found;
}



- (BOOL)isEntitySelected {
  for (Entity *e in [entityManager_ findAllWithComponent:@"Selectable"]) {
    Selectable *selectable = [e getComponentByString:@"Selectable"];
    if (selectable.selected == TRUE) {
      return TRUE;
    }
  }
  return FALSE;
}



- (void)selectEntity:(Entity *)entity {
  Selectable *selectable  = [entity getComponentByString:@"Selectable"];
  Health *health          = [entity getComponentByString:@"Health"];

  [selectable selectUnit];
  if (selectable != nil) {
    [health showHealthBar];
  }

  leader_ = entity;
}



- (void)selectAllWithinBoundingBox:(BoundingBox *)boundingBox {
  for (Entity *entity in [entityManager_ findAllWithinBoundingBox:boundingBox]) {
    [self selectEntity:entity];
  }
}



- (Entity *)selectEntityDisplayedAtPosition:(GLKVector2)target {
  Entity *entity = [entityManager_ findEntityDisplayedAtPosition:target];
  [self selectEntity:entity];
  return entity;
}



- (void)deselectAll {
  for (Entity *e in [entityManager_ findAllWithComponent:@"Selectable"]) {
    Selectable *selectable = [e getComponentByString:@"Selectable"];
    Health     *health     = [e getComponentByString:@"Health"];

    [selectable deselectUnit];
    if (health != nil) {
      [health hideHealthBar];
    }
  }
}

@end