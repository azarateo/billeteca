//
//  billetecaTableViewController.m
//  billeteca
//
//  Created by azarateo on 18/05/14.
//  Copyright (c) 2014 azarateo. All rights reserved.
//

#import "billetecaTableViewController.h"
#import "billetecaDetailViewController.h"

@interface billetecaTableViewController ()

@end

@implementation billetecaTableViewController
@synthesize denominations;
@synthesize years;
@synthesize months;
@synthesize days;
@synthesize seriesArray;
@synthesize f8_10;
@synthesize f5_7;
@synthesize f1_4;
@synthesize descriptions;
@synthesize denominationString;
@synthesize yearString;
@synthesize monthString;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    denominations = [[NSMutableArray alloc] init];
    years = [[NSMutableArray alloc] init];
    months = [[NSMutableArray alloc] init];
    days = [[NSMutableArray alloc] init];
    seriesArray = [[NSMutableArray alloc] init];
    f8_10 = [[NSMutableArray alloc] init];
    f5_7 = [[NSMutableArray alloc] init];
    f1_4 = [[NSMutableArray alloc] init];
    descriptions = [[NSMutableArray alloc] init];
    
    NSLog(@"Denominacion para busqueda %@", denominationString);
    NSLog(@"Año para busqueda %@", yearString);
    NSLog(@"Mes para busqueda %@", monthString);

    sqlite3_stmt *statement;
    NSString *query = @"select distinct * from billete where denominacion = '";
    NSString *query2 = [query stringByAppendingString:denominationString];
    NSString *query3 = [query2 stringByAppendingString:@"' AND year = '"];
    NSString *query4 = [query3 stringByAppendingString:yearString];
    NSString *query5 = [query4 stringByAppendingString:@"' AND month = '"];
    NSString *query6 = [query5 stringByAppendingString:monthString];
    NSString *query7 = [query6 stringByAppendingString:@"';"];
    
    NSLog(@"Se esta realizando la consulta:%@ ",query7);
    
    [self queryDataBaseWithQuery:query7 withStatement:statement];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [denominations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"banknoteFound" forIndexPath:indexPath];
    cell.textLabel.text = [[denominations objectAtIndex:indexPath.row] stringByAppendingString:@" pesos"];
    NSString *yearSpace = [[years objectAtIndex:indexPath.row] stringByAppendingString:@" "];
    NSString *issueDate = [yearSpace stringByAppendingString:[months objectAtIndex:indexPath.row]];
    NSString *issueDate2 = [issueDate stringByAppendingString:@" - "];
    NSString *detalle = [issueDate2 stringByAppendingString:[seriesArray objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = detalle;
    return cell;
}

-(void)queryDataBaseWithQuery:(NSString *)theQuery withStatement:(sqlite3_stmt *)theStatement{
    
    
    NSString *ruta = [[NSString alloc] init];
    NSArray *arregloUbicaciones = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    ruta = [[arregloUbicaciones objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"];
    NSLog(@"Numero de archivos %lu", (unsigned long)[arregloUbicaciones count]);

    
    if(sqlite3_open([ruta UTF8String], &db)){
        sqlite3_close(db);
        NSLog(@"No se pudo abrir la base de datos");
    }
    else{
        NSLog(@"Abrió la base de datos para traer los billetes de la busqueda");
    }
    
    
    if(sqlite3_prepare(db, [theQuery UTF8String], -1, &theStatement, nil) == SQLITE_OK){
        while (sqlite3_step(theStatement) == SQLITE_ROW) {
            
            char *dataChar = (char *) sqlite3_column_text(theStatement, 1);
            NSString *dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [denominations addObject:dataString];
            
            dataChar = (char *) sqlite3_column_text(theStatement, 2);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [years addObject:dataString];
            
            dataChar = (char *) sqlite3_column_text(theStatement, 3);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [months addObject:dataString];
            
            dataChar = (char *) sqlite3_column_text(theStatement, 4);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [days addObject:dataString];
            
            dataChar = (char *) sqlite3_column_text(theStatement, 5);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [seriesArray addObject:dataString];
            
            dataChar = (char *) sqlite3_column_text(theStatement, 6);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [f8_10 addObject:dataString];
            
            dataChar = (char *) sqlite3_column_text(theStatement, 7);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [f5_7 addObject:dataString];
            
            dataChar = (char *) sqlite3_column_text(theStatement, 8);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [f1_4 addObject:dataString];
          
            dataChar = (char *) sqlite3_column_text(theStatement, 9);
            dataString = dataChar == nil ? @"": [[NSString alloc] initWithUTF8String:dataChar];
            [descriptions addObject:dataString];
            
            NSLog(@"Consultando base");
            
        }
        
    }
    
    sqlite3_close(db);
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indice = [_resultsTable indexPathForCell:sender];
        if(indice){
            if([segue.identifier isEqualToString:@"banknoteDetail"]){
                if([segue.destinationViewController isKindOfClass:[billetecaDetailViewController class]]){
                    
                    //Variables para el detalle
                    NSString *sdenominacion = [denominations objectAtIndex:indice.row];
                    NSString *syear = [years objectAtIndex:indice.row];
                    NSString *smonth = [months objectAtIndex:indice.row];
                    NSString *sday = [days objectAtIndex:indice.row];
                    NSString *sseries = [seriesArray objectAtIndex:indice.row];
                    NSString *sf8_10s = [f8_10 objectAtIndex:indice.row];
                    NSString *sf5_7s = [f5_7 objectAtIndex:indice.row];
                    NSString *sf1_4s = [f1_4 objectAtIndex:indice.row];
                    NSString *sdescription = [descriptions objectAtIndex:indice.row];
                    
                    //Configurar la vista de detalle
                    billetecaDetailViewController *vistaDestino = segue.destinationViewController;
                    [self configuraVista:vistaDestino condenominacion:sdenominacion year:syear month:smonth day:sday series:sseries f8_10s:sf8_10s f5_7s:sf5_7s f1_4s:sf1_4s descriptions:sdescription];
                }
            }
        }
    }
    
}

-(void)configuraVista:(billetecaDetailViewController *)vista
      condenominacion:(NSString *)denominacion
                 year:(NSString *)year
                month:(NSString *)month
                  day:(NSString *)day
               series:(NSString *)series
               f8_10s:(NSString *)f8_10s
                f5_7s:(NSString *)f5_7s
                f1_4s:(NSString *)f1_4s
         descriptions:(NSString *)description
{
    
    vista.denominationString = denominacion;
    
    
    NSString *dateS = [NSString stringWithFormat:@"%@ %@ %@",year,month,day];
    vista.dateString= dateS;
    vista.descriptionString = description;
    vista.seriesString = series;
    vista.f8_10String = f8_10s;
    vista.f5_7String = f5_7s;
    vista.f1_4String = f1_4s;
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
