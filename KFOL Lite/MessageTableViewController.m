//
//  MessageTableViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/2/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "MessageTableViewController.h"

@implementation MessageTableViewController

@synthesize isReceivebox;

-(void)boxChange
{
    MessageTableViewController *otherMessageTableController=[[MessageTableViewController alloc]init];
    if(isReceivebox==YES)
    otherMessageTableController.isReceivebox=NO;
    else
        otherMessageTableController.isReceivebox=YES;
//    UINavigationController *othreNav=[[UINavigationController alloc]initWithRootViewController:otherMessageTableController];
    [UIView transitionFromView:self.tableView toView:otherMessageTableController.tableView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL done){}];
}

-(void)loadHTMLContents
{
    messageArray=[[NSMutableArray alloc]init];
    NSMutableString *processingNSString;
    if(isReceivebox==YES)
        processingNSString=[[NSMutableString alloc]initWithData:[@"message.php?action=receivebox" getWithStringContent:nil returnResponse:nil error:nil] encoding:0x80000632];
    else
        processingNSString=[[NSMutableString alloc]initWithData:[@"message.php?action=sendbox" getWithStringContent:nil returnResponse:nil error:nil] encoding:0x80000632];
    
    if ([processingNSString rangeOfString:@"<span style=\"color:#FF0000;font-weight:bold;font-size:14px;\">您还没有登录或注册"].location!=NSNotFound) {
        Login=NO;
        return;
    }
    
    for(;;)
    {
        if ([processingNSString rangeOfString:@"&mid="].location==NSNotFound) {
            break;
        }
        NSMutableDictionary *messageDetails=[[NSMutableDictionary alloc]init];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"&mid="].location+5];
        [messageDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"MessageID"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\">"])];
        [messageDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"MessageTitle"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"&uid="])];
        [messageDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"SenderUID"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\">"].location+2];
        [messageDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"SenderUserName"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"&uid="])];
        [messageDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"ReceiverUID"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\">"].location+2];
        [messageDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"ReceiverUserName"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"<td>"].location+4];
        [messageDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, 16)] forKey:@"MessageDate"];
        [messageArray addObject:messageDetails];
    }
    [messageArray writeToFile:[NSHomeDirectory() stringByAppendingString:@"/tmp/message.xml"] atomically:YES];

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
    if (isReceivebox==nil) {
        isReceivebox=YES;
    }
    self.navigationItem.title=@"Receivebox";
    Login=YES;
    if (_refreshHeaderView==nil) {
        EGORefreshTableHeaderView *refreshTableHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        refreshTableHeaderView.delegate=self;
        [self.tableView addSubview:refreshTableHeaderView];
        _refreshHeaderView=refreshTableHeaderView;
        _refreshHeaderView.backgroundColor=[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:1 alpha:1];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
//    MessageTableViewController *sendbox=[[MessageTableViewController alloc]initWithMessagebox:@"sendbox"];
    if(isReceivebox==YES)
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Sendbox" style:UIBarButtonItemStylePlain target:self action:@selector(boxChange)];
    else
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Receivebox" style:UIBarButtonItemStylePlain target:self action:@selector(boxChange)];

    [self loadHTMLContents];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil && Login==YES) {
    
    // Configure the cell...
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.text=[[messageArray objectAtIndex:indexPath.row]objectForKey:@"MessageTitle"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",[[messageArray objectAtIndex:indexPath.row]objectForKey:@"SenderUserName"],[[messageArray objectAtIndex:indexPath.row]objectForKey:@"MessageDate"]];
    cell.textLabel.textColor=[UIColor colorWithRed:0x55/255.0 green:0x11/255.0 blue:0xdd/255.0 alpha:1];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
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
    subController=[[MessageReadTableViewController alloc]initWithMessageDictionary:[messageArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:subController animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self viewDidLoad];
    [self.tableView reloadData];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
