//
//  indexTableViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "indexTableViewController.h"


@implementation indexTableViewController

@synthesize index_php_html;
@synthesize threadParts;
@synthesize messageTable;

-(void)logout:(id)sender
{
    logout();
    [self viewDidLoad];
    [self.tableView reloadData];
    [messageTable viewDidLoad];
    [messageTable.tableView reloadData];
    
}

-(void)login:(id)sender
{
    LoginTableView *theLoginView=[[LoginTableView alloc]initWithStyle:UITableViewStyleGrouped];
    theLoginView.messageTable=messageTable;
//    theLoginView.indexTable=self;
    [theLoginView setIndexTable:self];
    UINavigationController *loginNav=[[UINavigationController alloc]initWithRootViewController:theLoginView];
    [self presentModalViewController:loginNav animated:YES];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"Welcome to KFOL";
    

    //load index content
    self.index_php_html=[@"index.php" getWithStringContent:nil returnResponse:nil error:nil];
    NSMutableString *processingNSString=[[NSMutableString alloc]initWithData:self.index_php_html encoding:0x80000632];
    if(processingNSString.length==0)
    {
        return;
    }
    
    //logined or not
    if ([processingNSString rangeOfString:@"您尚未　<a href=\"login.php\">"].location!=NSNotFound) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
        self.navigationItem.leftBarButtonItem=nil;
    }
    else
    {
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
        self.navigationItem.rightBarButtonItem=nil;
    }
    
    
    
    self.threadParts=[[NSMutableArray alloc]init];
    NSMutableDictionary *threadDetails;
    NSMutableArray *threadListSubarray;
    
    //thread list part 1
    threadListSubarray=[[NSMutableArray alloc]init];
    
    processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"<div id=\"divtitle1\" style=\"width:90%;\">"].location+@"<div id=\"divtitle1\" style=\"width:90%;\">".length];
    [threadListSubarray addObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</div>"].location)]];
    for(;;)
    {
        threadDetails=[[NSMutableDictionary alloc]init];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<a href=\"thread.php?fid="])];
        [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, 3)] forKey:@"ThreadFID"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"px;\">"].location+5];
        [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"ThreadName"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\"color:"].location+7];
        [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, 7)] forKey:@"ThreadDescriptionColor"];
        processingNSString=[processingNSString substringFromIndex:9];
        [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</span>"].location)] forKey:@"ThreadDescription"];
        
        [threadListSubarray addObject:threadDetails];
        if ([processingNSString rangeOfString:@"<a href="].location > [processingNSString rangeOfString:@"</div></div>"].location) 
        {
            break;
        }
    }
    
    [self.threadParts addObject:threadListSubarray];
    threadListSubarray=nil;
    //thread list part 2
    
    processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"px;\">"].location+5];
//    [threadListSubarray addObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\r\n"].location)]];
     
    for(;;)
    {
        if([processingNSString rangeOfString:@"width=\"100\">"].location < [processingNSString rangeOfString:@"width=\"220\">"].location)
        {
            if (threadListSubarray!=nil) 
                [threadParts addObject:threadListSubarray];
            threadListSubarray=[[NSMutableArray alloc]init];
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\">&nbsp;"])];
            [threadListSubarray addObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</td>"].location)]];
        }
        else
        {
            threadDetails=[[NSMutableDictionary alloc]init];
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<a href=\"thread.php?fid="])];
            [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"ThreadFID"];
            processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"color:"].location+6];
            [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, 7)] forKey:@"ThreadNameColor"];
            processingNSString=[processingNSString substringFromIndex:10];
            [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"ThreadName"];
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<a href=\"read.php?tid="])];
            [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"&"].location)] forKey:@"LastPostTID"];
            processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\">"].location+2];
            [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"LastPost"];
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"</a>"])+1];
            [threadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, 16)] forKey:@"LastPostDate"];
            [threadListSubarray addObject:threadDetails];
            
        }
        if([processingNSString rangeOfString:@"width=\"220\""].location==NSNotFound)
            break;
        
    }
    
    [self.threadParts addObject:threadListSubarray];
    [threadParts addObject:[threadParts objectAtIndex:0]];
    [threadParts removeObjectAtIndex:0];
    
    [self.threadParts writeToFile:[NSHomeDirectory() stringByAppendingString:@"/tmp/index.plist"] atomically:YES];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/*-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *sectionTiles=[[NSMutableArray alloc]init];
    for (int n=1; n!=-1; n--) {
        for(id sectionTitle in [threadParts objectAtIndex:n])
        {
            if ([sectionTitle isKindOfClass:[NSString class]]) {
                [sectionTiles addObject:sectionTitle];
            }
        }
    }
    return sectionTiles;
}*/

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[threadParts objectAtIndex:section]objectAtIndex:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return threadParts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[threadParts objectAtIndex:section] count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text=[[[threadParts objectAtIndex:indexPath.section]objectAtIndex:indexPath.row+1]objectForKey:@"ThreadName"];
        if (indexPath.section+1==threadParts.count) {
            cell.textLabel.textColor=[UIColor colorWithRed:0x55/255.0 green:0x11/255.0 blue:0xdd/255.0 alpha:1];
        }else
        {
            cell.textLabel.textColor=[UIColor redColor];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    }
    
    // Configure the cell...
        
    
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    subController=[[ThreadTableViewController alloc]initWithThreadDictionary:[[threadParts objectAtIndex:indexPath.section]objectAtIndex:indexPath.row+1]];
    UINavigationController *navIndex;
    if (self.navigationController==nil) {
        navIndex=[[UINavigationController alloc]initWithRootViewController:self];
        [navIndex pushViewController:subController animated:YES];
        }
    else
        [self.navigationController pushViewController:subController animated:YES];
    
    
}

@end
