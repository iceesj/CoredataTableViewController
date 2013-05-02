//
//  Photo+Flickr.h
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-5-2.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)flickInfo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
