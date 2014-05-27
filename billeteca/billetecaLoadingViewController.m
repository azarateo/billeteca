//
//  billetecaLoadingViewController.m
//  billeteca
//
//  Created by azarateo on 26/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import "billetecaLoadingViewController.h"
#import <Parse/Parse.h>



@interface billetecaLoadingViewController ()

@end

@implementation billetecaLoadingViewController



- (void)viewDidLoad
{
    
#pragma mark parse notification app registration
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"collectionists" forKey:@"channels"];
    [currentInstallation saveInBackground];
    
#pragma mark database creation Opening
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self creaRuta];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:ruta];

    if(fileExists){
        NSLog(@"Ya existe la base de datos");
    }else{
        NSLog(@"Creando la base de datos");
    [self creaTabla];
    [self insertaDatos];
    }

}

-(void)creaRuta{

    ruta = [[NSString alloc] init];
    NSArray *arregloUbicaciones = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    ruta = [[arregloUbicaciones objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"];
    NSLog(@"Numero de archivos %lu", (unsigned long)[arregloUbicaciones count]);
    
}

-(void)creaTabla{

 
    
    if(sqlite3_open([ruta UTF8String], &db)){
        sqlite3_close(db);
        NSLog(@"No se pudo abrir la base de datos");
    }
    else{
        NSLog(@"Abrió la base de datos");
    }
    
    
    NSString *consulta = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS billete(objectId varchar(20), denominacion varchar(10), year text(10), month text(10), day text(10), serie text(10), f8_10 varchar(20), f5_7 varchar(20), f1_4 varchar(20), descripcion text);"];
    
    char *error;
    
    if(sqlite3_exec(db, [consulta UTF8String], NULL, NULL, &error) != SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"No se creó la tabla");
    }
    else{
        NSLog(@"Se creó la tabla");
        
    }

    
}


-(void)insertaDatos{
    
    if(sqlite3_open([ruta UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"No se pudo abrir la base de datos");
    }
    else{
        NSLog(@"Abrió la base de datos");
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"billeteca"];
    query.limit = 1000;
    [query whereKey:@"denominacion" notEqualTo:@""];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Billetes encontrados %lu", (unsigned long)objects.count);
            // Do something with the found objects
            int i = 0;
            for (PFObject *object in objects) {
                NSLog(@"%d",i);
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
                //NSLog(@"Consulta de inserción: %@",consultainsercion);
                if(sqlite3_exec(db, [consultainsercion UTF8String], NULL, NULL, &error2) != SQLITE_OK){
                    sqlite3_close(db);
                    NSLog(@"NO INSERTO");
                    //NSLog(@"ERROR: %s",sqlite3_errmsg(db));
                }
                else{
                    //NSLog(@"INSERTO");
                    
                }
                i++;
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Billeteca: Error in query to cloud databases: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

@end
