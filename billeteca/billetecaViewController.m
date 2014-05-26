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
    
#pragma mark variable initialization
    arrayDenomination = [[NSMutableArray alloc] init];
    arrayYears = [[NSMutableArray alloc] init];
    arrayMonths = [[NSMutableArray alloc] init];
    
    
    #pragma mark parse notification app registration
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"collectionists" forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    #pragma mark database creation Opening
    
    NSString *ruta = [[NSString alloc] init];
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
    
    
    #pragma mark table Create
    
    
    
    NSString *consulta = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS billete(objectId varchar(20), denominacion varchar(10), year text(10), month text(10), day text(10), serie text(10), f8_10 varchar(20), f5_7 varchar(20), f1_4 varchar(20), descripcion text);"];
    char *error;
    
    if(sqlite3_exec(db, [consulta UTF8String], NULL, NULL, &error) != SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"No se creó la tabla");
    }
    else{
        NSLog(@"Se creó la tabla");
        
    }
    
    #pragma mark download data from Parse

    
    PFQuery *query = [PFQuery queryWithClassName:@"billeteca"];
    query.limit = 1000;
    [query whereKey:@"denominacion" notEqualTo:@""];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Billetes encontrados %lu", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                
                //NSLog(@"Objeto resultado %@",object);
                NSString *objectId = [object objectId] == nil ? @"" : [NSString stringWithString:[object objectId]];
                NSString *denominacions = [object objectForKey:@"denominacion"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"denominacion"]];
                NSString *year = [object objectForKey:@"ano"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"ano"]];
                NSString *month = [object objectForKey:@"mes"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"mes"]];
                NSString *day = [object objectForKey:@"dia"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"dia"]];
                NSString *series = [object objectForKey:@"serie"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"serie"]];
                NSString *f8_10 = [object objectForKey:@"f8_10"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"f8_10"]];
                NSString *f5_7 = [object objectForKey:@"f5_7"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"f5_7"]];
                NSString *f1_4 = [object objectForKey:@"f1_4"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"f1_4"]];
                NSString *descripcion = [object objectForKey:@"descripcion"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"descripcion"]];
                NSString *consultainsercion = [NSString stringWithFormat:@"INSERT INTO billete(objectId,denominacion,year,month,day,serie,f8_10,f5_7,f1_4,descripcion)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",objectId,denominacions,year,month,day,series,f8_10,f5_7,f1_4,descripcion];
                char *error2;
                if(sqlite3_exec(db, [consultainsercion UTF8String], NULL, NULL, &error2) != SQLITE_OK){
                    sqlite3_close(db);
                    NSLog(@"No se insertó la fila");
                }
                else{
                    
                }
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Billeteca: Error in query to cloud databases: %@ %@", error, [error userInfo]);
        }
    }];
    sqlite3_close(db);


    #pragma mark retreive data from SQLite DB
    
    
    
   

    sqlite3_stmt *statement;
    NSString *denominationsQuery = @"select distinct denominacion from billete where denominacion is not null order by denominacion asc";
    NSString *yearQuery = @"select distinct year from billete where denominacion is not null order by year asc";
    
    [self queryDataBaseWithQuery:denominationsQuery withStatement:statement InsertingInArray:arrayDenomination];
    [self queryDataBaseWithQuery:yearQuery withStatement:statement InsertingInArray:arrayYears];

    
    
    
    
    [super viewDidLoad];

    self.arrayMonths = [[NSMutableArray alloc] initWithObjects:@"Enero",@"Febrero",@"Marzo",@"Abril",@"Mayo",@"Junio",@"Julio",@"Agosto",@"Septiembre",@"Octubre",@"Noviembre",@"Diciembre",nil];
    
    
    
    
    
    
    

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
        tView.font = [UIFont systemFontOfSize:14];
        
    }
    // Fill the label text here
    if (component == 0) {
        tView.text = [arrayDenomination objectAtIndex:row];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    if (component == 1) {
        tView.text = [arrayYears objectAtIndex:row];
        tView.textAlignment = NSTextAlignmentRight;
        tView.textColor = [UIColor blueColor];

    }
    if (component == 2){
        tView.text = [arrayMonths objectAtIndex:row];
        tView.textAlignment = NSTextAlignmentRight;
        tView.textColor = [UIColor redColor];

    }
    return tView;
}


-(void)queryDataBaseWithQuery:(NSString *)theQuery withStatement:(sqlite3_stmt *)theStatement InsertingInArray:(NSMutableArray *)theArray{

    
    NSString *ruta = [[NSString alloc] init];
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
