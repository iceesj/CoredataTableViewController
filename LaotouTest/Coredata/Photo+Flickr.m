//
//  Photo+Flickr.m
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-5-2.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"

@implementation Photo (Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)flickInfo inManagedObjectContext:(NSManagedObjectContext *)context{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",[flickInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count]>1)) {
        
    }else if ([matches count] == 0){
        
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickInfo valueForKey:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickInfo format:FlickrPhotoFormatLarge]absoluteString];
        photo.whoTook = [Photographer photographerWithName:[flickInfo objectForKey:FLICKR_PHOTO_OWNER] inManagedObjectContext:context];
        
    }else{
        photo = [matches lastObject];
    }
    return photo;
}

@end
