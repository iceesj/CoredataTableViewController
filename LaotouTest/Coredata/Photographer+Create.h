//
//  Photographer+Create.h
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-5-2.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)

+(Photographer *)photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
