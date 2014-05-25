//
//  billetecaViewController.h
//  billeteca
//
//  Created by azarateo on 17/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface billetecaViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{

    sqlite3 *db;
    
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *denominacion;
- (IBAction)findBanknotes:(id)sender;




@end
