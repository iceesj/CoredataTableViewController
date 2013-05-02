//
//  PhotosByPhotographerTableViewController.m
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-4-30.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import "PhotosByPhotographerTableViewController.h"
#import "Photo.h"
#import "ImageViewController.h"

@interface PhotosByPhotographerTableViewController ()

@end

@implementation PhotosByPhotographerTableViewController

@synthesize photographer = _photographer;



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupFetchedResultsController{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"whoTook.name = %@",self.photographer.name];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.photographer.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
}

-(void)setPhotographer:(Photographer *)photographer{
    if (_photographer != photographer){
        _photographer = photographer;
    }
    self.title = photographer.name;
    
    [self setupFetchedResultsController];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Photo *photo =[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    
    return cell;
}


#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"Show Photo"]){
        [segue.destinationViewController setImageURL:[NSURL URLWithString:photo.imageURL]];
        [segue.destinationViewController setTitle:photo.title];
    }
}

@end
