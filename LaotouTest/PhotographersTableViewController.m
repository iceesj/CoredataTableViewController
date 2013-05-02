//
//  PhotographersTableViewController.m
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-4-30.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import "PhotographersTableViewController.h"
#import "FlickrFetcher.h"

#import "Photo+Flickr.h"
#import "Photographer.h"


@interface PhotographersTableViewController ()

@end

@implementation PhotographersTableViewController
@synthesize photoDatabase = _photoDatabase;


-(void)fetchFlickrDataIntoDocument:(UIManagedDocument *)document{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
        [document.managedObjectContext performBlock:^{
            
            for (NSDictionary *flickInfo in photos){
//                NSManagedObject *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:document.managedObjectContext];
//                [photo setValue:[flickInfo objectForKey:FLICKR_PHOTO_TITLE]  forKey:@"title"];
//                Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:document.managedObjectContext];
//                photo.title = [flickInfo objectForKey:FLICKR_PHOTO_TITLE];
                //返回photo
                [Photo photoWithFlickrInfo:flickInfo inManagedObjectContext:document.managedObjectContext];
            }
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        }];
    });
    
}

-(void)setupFetchedResultsController{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    //predicate
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.photoDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

-(void)useDocument{
    if (![[NSFileManager defaultManager]fileExistsAtPath:[self.photoDatabase.fileURL path]]){
        [self.photoDatabase saveToURL:self.photoDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        [self setupFetchedResultsController];
        [self fetchFlickrDataIntoDocument:self.photoDatabase];//自动发现并更新我的 table
        }];
    }else if (self.photoDatabase.documentState == UIDocumentStateClosed){
        [self.photoDatabase openWithCompletionHandler:^(BOOL success){
        [self setupFetchedResultsController];
        }];
    }else if (self.photoDatabase.documentState == UIDocumentStateNormal){
        [self setupFetchedResultsController];
    }
}

-(void)setPhotoDatabase:(UIManagedDocument *)photoDatabase{
    if (_photoDatabase != photoDatabase){
        _photoDatabase = photoDatabase;
        [self useDocument];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.photoDatabase){
        NSURL *url = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];//搜索目录的NSDocumentDirectory
        url = [url URLByAppendingPathComponent:@"Default Photo Database"];
        self.photoDatabase = [[UIManagedDocument alloc]initWithFileURL:url];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photographer Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photographer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [photographer.photos count]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexpath];
    //如果目标viewcontroller 响应setPhotographer，我就segue
    if([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]){
        [segue.destinationViewController performSelector:@selector(setPhotographer:) withObject:photographer];
    }
}

@end
