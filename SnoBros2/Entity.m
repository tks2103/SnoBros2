//
//  Entity.m
//  Component
//
//  Created by Chad Jablonski on 11/1/12.
//  Copyright (c) 2012 Attack Slug. All rights reserved.
//

#import "Entity.h"

#import "Sprite.h"
#import "Component.h"

@implementation Entity

NSArray *COMPONENT_LOAD_ORDER = nil;
+ (void)initialize {
  if (!COMPONENT_LOAD_ORDER) {
    COMPONENT_LOAD_ORDER = [NSArray arrayWithObjects:@"SceneGraph",
                                                     @"Health",
                                                     @"Behavior",
                                                     @"Selectable",
                                                     @"Physics",
                                                     @"Transform",
                                                     @"Collision",
                                                     @"Pathfinding",
                                                     @"StandardCollider",
                                                     @"Team",
                                                     @"Attack",
                                                     @"UnitCollider",
                                                     @"Movement",
                                                     @"Projectile",
                                                     nil];
  }
}

@synthesize uuid        = uuid_;
@synthesize type         = type_;

@synthesize components  = components_;

- (id)init {
  return [self initWithType:@"untagged"];
}



- (id)initWithType:(NSString *)type {
  self = [super init];
  if (self) {
    type_ = type;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    uuid_ = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    components_ = [[NSMutableDictionary alloc] init];
  }
  return self;
}



- (id)initWithDictionary:(NSDictionary *)data {
  self = [self initWithType:[data valueForKey:@"Type"]];
  if (self) {
    NSDictionary *components = data[@"Components"];
    for (NSString *componentName in COMPONENT_LOAD_ORDER) {
      NSString *className  = components[componentName][@"Type"];
      // most entities wont have all the components listed in COMPONENT_LOAD_ORDER. we skip them here
      if (className == nil) {
        continue;
      }
      Class componentClass = NSClassFromString(className);
      if (componentClass == nil) {
        NSLog(@"ERROR: Attempted to load nonexistent class with name %@ in entity loader", className);
        exit(0);
      }

      NSDictionary *attributes = [components valueForKey:componentName];
      Component *component     = [[componentClass alloc] initWithEntity:self
                                                           dictionary:attributes];

      [self setComponent:component withString:className];
    }
  }
  return self;
}



- (void)update {
  [components_ enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
    [object update];
  }];
}



- (id)getComponentByString:(NSString *)string {
  return [components_ objectForKey:string];
}



- (void)setComponent:(Component *)component withString:(NSString *)string {
  [components_ setObject:component forKey:string];
}



- (BOOL)hasComponent:(NSString *)string {
  return [components_ objectForKey:string] != nil;
}

@end