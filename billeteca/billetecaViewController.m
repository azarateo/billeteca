//
//  billetecaViewController.m
//  billeteca
//
//  Created by azarateo on 17/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import "billetecaViewController.h"
#import <Parse/Parse.h>

@interface billetecaViewController ()

@property NSArray *arrayDenomination;
@property NSArray *arrayYears;
@property NSArray *arrayMonths;

@end

@implementation billetecaViewController
@synthesize arrayDenomination;
@synthesize arrayYears;
@synthesize arrayMonths;

- (void)viewDidLoad
{
    //Registration for push notificacions
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"collectionists" forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    NSString *ruta = [[NSString alloc] init];
    NSArray *arregloUbicaciones = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    ruta = [[arregloUbicaciones objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"];
    
    if(sqlite3_open([ruta UTF8String], &db)){
        sqlite3_close(db);
        NSLog(@"No se pudo abrir la base de datos");
    }
    else{
        NSLog(@"Abrió la base de datos");
    }
    
    NSString *consulta = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS billete(objectId varchar(20), denominacion varchar(10), year text(10), month text(10), day text(10), f8_10 varchar(20), f5_7 varchar(20), f1_4 varchar(20), descripcion text);"];
    char *error;
    
    if(sqlite3_exec(db, [consulta UTF8String], NULL, NULL, &error) != SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"No se creó la tabla");
    }
    else{
        NSLog(@"Se creó la tabla");
        
    }
    
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
                NSString *denominacion = [object objectForKey:@"denominacion"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"denominacion"]];
                NSString *year = [object objectForKey:@"ano"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"ano"]];
                NSString *month = [object objectForKey:@"mes"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"mes"]];
                NSString *day = [object objectForKey:@"dia"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"dia"]];
                NSString *f8_10 = [object objectForKey:@"f8_10"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"f8_10"]];
                NSString *f5_7 = [object objectForKey:@"f5_7"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"f5_7"]];
                NSString *f1_4 = [object objectForKey:@"f1_4"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"f1_4"]];
                NSString *descripcion = [object objectForKey:@"descripcion"] == nil ? @"" : [NSString stringWithString:[object objectForKey:@"descripcion"]];
                NSString *consultainsercion = [NSString stringWithFormat:@"INSERT INTO billete(objectId,denominacion,year,month,day,f8_10,f5_7,f1_4,descripcion)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@');",objectId,denominacion,year,month,day,f8_10,f5_7,f1_4,descripcion];
                char *error2;
                if(sqlite3_exec(db, [consultainsercion UTF8String], NULL, NULL, &error2) != SQLITE_OK){
                    sqlite3_close(db);
                    NSLog(@"No se insertó la fila");
                }
                else{
                    NSLog(@"Se insertó la fila");
                }
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Billeteca: Error in query to cloud databases: %@ %@", error, [error userInfo]);
        }
    }];
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //User Interface load
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.arrayDenomination = [[NSArray alloc] initWithObjects:@"1/2",@"1",nil];
    self.arrayYears = [[NSArray alloc] initWithObjects:@"1923",@"1924",nil];
    self.arrayMonths = [[NSArray alloc] initWithObjects:@"Enero",@"Febrero",nil];
    
    
    
    
    
    
    

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

@end
