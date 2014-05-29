//
//  billetecaViewController.m
//  billeteca
//
//  Created by azarateo on 17/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import "billetecaViewController.h"
#import "billetecaTableViewController.h"
#import <Parse/Parse.h>

@interface billetecaViewController ()

@property NSMutableArray *arrayDenomination;
@property NSMutableArray *arrayYears;
@property NSMutableArray *arrayMonths;

@end

@implementation billetecaViewController
@synthesize denominacion;
@synthesize arrayDenomination;
@synthesize arrayYears;
@synthesize arrayMonths;

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    ruta = [[NSString alloc] init];
    NSArray *arregloUbicaciones = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    ruta = [[arregloUbicaciones objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"];
    NSLog(@"Numero de archivos %lu", (unsigned long)[arregloUbicaciones count]);
    
#pragma mark variable initialization
    arrayDenomination = [[NSMutableArray alloc] initWithObjects:@"", nil];
    arrayYears = [[NSMutableArray alloc] initWithObjects:@"", nil];
    arrayMonths = [[NSMutableArray alloc] initWithObjects:@"", nil];
    
    if(sqlite3_open([ruta UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"No se pudo abrir la base de datos");
    }
    else{
        NSLog(@"Abrió la base de datos");
    }

    sqlite3_stmt *statement;
    NSString *denominationsQuery = @"select distinct denominacion from billete where denominacion is not null order by denominacion asc";
    NSString *yearQuery = @"select distinct year from billete where denominacion is not null order by year asc";
    
    [self queryDataBaseWithQuery:denominationsQuery withStatement:statement InsertingInArray:arrayDenomination];
    [self queryDataBaseWithQuery:yearQuery withStatement:statement InsertingInArray:arrayYears];
    [super viewDidLoad];

    self.arrayMonths = [[NSMutableArray alloc] initWithObjects:@"",@"Enero",@"Febrero",@"Marzo",@"Abril",@"Mayo",@"Junio",@"Julio",@"Agosto",@"Septiembre",@"Octubre",@"Noviembre",@"Diciembre",nil];
    sqlite3_close(db);


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [arrayDenomination count];
    }
    if (component == 1) {
        return [arrayYears count];
    }
    
    return [arrayMonths count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [arrayDenomination objectAtIndex:row];
    }
    if (component == 1) {
        return [arrayYears objectAtIndex:row];
    }
    return [arrayMonths objectAtIndex:row];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        
    }
    // Fill the label text here
    if (component == 0) {
        tView.text = [arrayDenomination objectAtIndex:row];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.font = [UIFont systemFontOfSize:18];

    }
    if (component == 1) {
        tView.text = [arrayYears objectAtIndex:row];
        tView.textAlignment = NSTextAlignmentRight;
        tView.textColor = [UIColor blueColor];
        tView.font = [UIFont systemFontOfSize:16];


    }
    if (component == 2){
        tView.text = [arrayMonths objectAtIndex:row];
        tView.textAlignment = NSTextAlignmentRight;
        tView.textColor = [UIColor blueColor];
        tView.font = [UIFont systemFontOfSize:15];


    }
    return tView;
}


-(void)queryDataBaseWithQuery:(NSString *)theQuery withStatement:(sqlite3_stmt *)theStatement InsertingInArray:(NSMutableArray *)theArray{

    
    ruta = [[NSString alloc] init];
    NSArray *arregloUbicaciones = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    ruta = [[arregloUbicaciones objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"];
    NSLog(@"Numero de archivos %lu", (unsigned long)[arregloUbicaciones count]);
    
    if(sqlite3_open([ruta UTF8String], &db)){
        sqlite3_close(db);
        NSLog(@"No se pudo abrir la base de datos");
    }
    else{
        NSLog(@"Abrió la base de datos");
    }
    
    
    if(sqlite3_prepare(db, [theQuery UTF8String], -1, &theStatement, nil) == SQLITE_OK){
        
        NSLog(@"Consultando base");

        while (sqlite3_step(theStatement) == SQLITE_ROW) {
            
            char *dataChar = (char *) sqlite3_column_text(theStatement, 0);
            NSString *dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [theArray addObject:dataString];
            
        }
        
    }
    
    sqlite3_close(db);
    
}

- (IBAction)findBanknotes:(id)sender {
    
    NSLog(@"Denominacion %@", [arrayDenomination objectAtIndex:[denominacion selectedRowInComponent:0]]);
    NSLog(@"Año %@", [arrayYears objectAtIndex:[denominacion selectedRowInComponent:1]]);
    NSLog(@"Mes %@", [arrayMonths objectAtIndex:[denominacion selectedRowInComponent:2]]);


}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([[segue identifier] isEqualToString:@"foundBanknotes"]){
        
        if([[segue destinationViewController] isKindOfClass:[billetecaTableViewController class]]){
            [[segue destinationViewController] setDenominationString:[arrayDenomination objectAtIndex:[denominacion selectedRowInComponent:0]]];
            [[segue destinationViewController] setYearString:[arrayYears objectAtIndex:[denominacion selectedRowInComponent:1]]];
            [[segue destinationViewController] setMonthString:[arrayMonths objectAtIndex:[denominacion selectedRowInComponent:2]]];

        }
        
    }
    

}

@end
