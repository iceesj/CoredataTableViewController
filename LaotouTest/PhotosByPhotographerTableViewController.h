//
//  PhotosByPhotographerTableViewController.h
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-4-30.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photographer.h"
#import "CoreDataTableViewController.h"

@interface PhotosByPhotographerTableViewController : CoreDataTableViewController

@property (nonatomic, strong) Photographer *photographer;

@end
