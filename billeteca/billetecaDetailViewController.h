//
//  billetecaDetailViewController.h
//  billeteca
//
//  Created by azarateo on 25/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface billetecaDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *denominationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *f8_10;
@property (weak, nonatomic) IBOutlet UILabel *f5_7;
@property (weak, nonatomic) IBOutlet UILabel *f1_4;


@property (weak, nonatomic) NSString *denominationString;
@property (weak, nonatomic) NSString *dateString;
@property (weak, nonatomic) NSString *descriptionString;
@property (weak, nonatomic) NSString *seriesString;
@property (weak, nonatomic) NSString *f8_10String;
@property (weak, nonatomic) NSString *f5_7String;
@property (weak, nonatomic) NSString *f1_4String;

@end
