//
//  PhotographersTableViewController.h
//  LaotouTest
//
//  Created by 曹 盛杰 on 13-4-30.
//  Copyright (c) 2013年 曹 盛杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface PhotographersTableViewController : CoreDataTableViewController

@property (nonatomic,strong) UIManagedDocument *photoDatabase;
@end
