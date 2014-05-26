//
//  billetecaTableViewController.h
//  billeteca
//
//  Created by azarateo on 18/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface billetecaTableViewController : UITableViewController{

    sqlite3 *db;
    
}
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;
@property (strong, nonatomic) NSMutableArray *denominations;
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *seriesArray;
@property (strong, nonatomic) NSMutableArray *f8_10;
@property (strong, nonatomic) NSMutableArray *f5_7;
@property (strong, nonatomic) NSMutableArray *f1_4;
@property (strong, nonatomic) NSMutableArray *descriptions;



@property (strong, nonatomic) NSString *denominationString;
@property (strong, nonatomic) NSString *yearString;
@property (strong, nonatomic) NSString *monthString;



@end
