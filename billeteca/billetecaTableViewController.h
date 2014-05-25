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
@property (strong, nonatomic) NSString *denominationString;
@property (strong, nonatomic) NSString *yearString;
@property (strong, nonatomic) NSString *monthString;



@end
