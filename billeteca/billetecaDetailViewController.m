//
//  billetecaDetailViewController.m
//  billeteca
//
//  Created by azarateo on 25/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import "billetecaDetailViewController.h"

@interface billetecaDetailViewController ()

@end

@implementation billetecaDetailViewController
@synthesize denominationLabel;
@synthesize dateLabel;
@synthesize seriesLabel;
@synthesize descriptionLabel;
@synthesize f8_10;
@synthesize f5_7;
@synthesize f1_4;

@synthesize denominationString;
@synthesize dateString;
@synthesize descriptionString;
@synthesize seriesString;
@synthesize f8_10String;
@synthesize f5_7String;
@synthesize f1_4String;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self actualizarUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)actualizarUI{
    self.denominationLabel.text = denominationString;
    self.dateLabel.text = dateString;
    self.descriptionLabel.text = descriptionString;
    self.seriesLabel.text = seriesString;
    self.f8_10.text = f8_10String;
    self.f5_7.text = f5_7String;
    self.f1_4.text = f1_4String;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
