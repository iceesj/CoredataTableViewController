//
//  Photographer+Create.m
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-5-2.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)

+(Photographer *)photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context{
    Photographer *photographer = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *photographers = [context executeFetchRequest:request error:&error];
    
    if (!photographers || [photographers count] >1){
        
    }else if (![photographers count]) {
        photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
        photographer.name = name;
    }else {
        photographer = [photographers lastObject];
    }
    
    return photographer;
}

@end
