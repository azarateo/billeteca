//
//  billetecaLoadingViewController.h
//  billeteca
//
//  Created by azarateo on 26/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface billetecaLoadingViewController : UIViewController{
    sqlite3 *db;
    NSString *ruta;
    
}

@end
