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
@synthesize receivebox;
@synthesize sentbox;
/*
-(id)init
{
    self=[super init];
    
    
    return self;
}*/

-(id)initWithReceiveBox:(BOOL)isRBox
{
    self=[self init];
    if (isRBox==YES) {
        isReceivebox=YES;
    }
    else{
        isReceivebox=NO;
//        ((UIScrollView *)self.tableView.superview).contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
    }
    
    Login=YES;
    if (_refreshHeaderView==nil) {
        EGORefreshTableHeaderView *refreshTableHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        refreshTableHeaderView.delegate=self;
        [self.tableView addSubview:refreshTableHeaderView];
        _refreshHeaderView=refreshTableHeaderView;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Sentbox" style:UIBarButtonItemStylePlain target:self action:@selector(boxChange)];
    
    return self;
}

-(void)boxChange
{
    /*
    [UIView transitionFromView:isReceivebox?receivebox.tableView:sentbox.tableView toView:isReceivebox?sentbox.tableView:receivebox.tableView duration:1.0f options:isReceivebox?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL done){}];*/
    if (isReceivebox==YES) {
        isReceivebox=NO;
    }
    else
        isReceivebox=YES;
    
    [self viewDidLoad];
    [self.tableView reloadData];
}

-(void)loadHTMLContents
{
    
    NSMutableString *processingNSString;
    
    processingNSString=[[NSString alloc]initWithData:[messageBoxURLString getWithStringContent:nil returnResponse:nil error:nil] encoding:0x80000632];
    
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

    if ([processingNSString rangeOfString:@">首页</a>"].location!=NSNotFound) {
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<b> "])];
        [pagesInfo setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@" </b>"].location)] forKey:@"PageNow"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\">"].location+2];
        [pagesInfo setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"PageNext"];
        if ([[pagesInfo objectForKey:@"PageNext"]compare:@"后10页"]==NSOrderedSame) {
            [pagesInfo removeObjectForKey:@"PageNext"];
        }
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"页码: ( "])];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"/"].location+1];
        [pagesInfo setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@" )"].location)] forKey:@"PageMax"];
    }
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
    
    if(isReceivebox==YES){
        self.navigationItem.title=@"Receivebox";
    self.navigationItem.leftBarButtonItem.title=@"Sentbox";
    }
    if(isReceivebox==NO){
        self.navigationItem.title=@"Sentbox";
    self.navigationItem.leftBarButtonItem.title=@"Receivebox";
    }

    messageArray=[[NSMutableArray alloc]init];
    messageBoxURLString=[[NSString alloc]initWithFormat:@"message.php?action=%@",isReceivebox?@"receivebox":@"scout"];
    pagesInfo=[[NSMutableDictionary alloc]init];
    
    [self loadHTMLContents];
    
    if (pagesInfo!=nil && [[pagesInfo objectForKey:@"PageNow"] intValue]<[[pagesInfo objectForKey:@"PageMax"] intValue] && [pagesInfo objectForKey:@"PageNext"]!=nil && _addMoreFooterView==nil) {
            EGORefreshTableHeaderView *addMoreTableFooterView=[[EGORefreshTableHeaderView alloc]initWithFrameInBottom:CGRectMake(0, -460, 0, 0)];
            addMoreTableFooterView.delegate=self;
            [self.tableView addSubview:addMoreTableFooterView];
            _addMoreFooterView=addMoreTableFooterView;
    }
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
    NSString *CellIdentifier;
    if (isReceivebox) {
        CellIdentifier = [NSString stringWithFormat:@"Cell%d_1",indexPath.row];
    }
    else
        CellIdentifier = [NSString stringWithFormat:@"Cell%d_0",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil && Login==YES) {
    
    // Configure the cell...
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.text=[[messageArray objectAtIndex:indexPath.row]objectForKey:@"MessageTitle"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",[[messageArray objectAtIndex:indexPath.row]objectForKey:@"SenderUserName"],[[messageArray objectAtIndex:indexPath.row]objectForKey:@"MessageDate"]];
    cell.textLabel.textColor=[UIColor colorWithRed:0x55/255.0 green:0x11/255.0 blue:0xdd/255.0 alpha:1];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row+1==messageArray.count){
        [_addMoreFooterView setFrame:CGRectMake(0, tableView.contentSize.height+65, tableView.frame.size.width, tableView.bounds.size.height)];
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
    subController.isReceivebox=isReceivebox;
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
    [_addMoreFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_addMoreFooterView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark Data Source Adding Methods

- (void)addMoreTablewViewDataSourece{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    messageBoxURLString=nil;
    messageBoxURLString=[NSString stringWithFormat:@"message.php?action=%@&page=%@",isReceivebox?@"receivebox":@"scout",[pagesInfo objectForKey:@"PageNext"]];
    [self loadHTMLContents];
    [self.tableView reloadData];
	_adding = YES;
	
}

- (void)doneAddMoreTableViewData{
	
	//  model should call this when its done loading
	_adding = NO;
    if([pagesInfo objectForKey:@"PageNext"]==nil){
        [_addMoreFooterView removeFromSuperview];
    }
    else{
        [_addMoreFooterView setFrame:CGRectMake(0, self.tableView.contentSize.height+65, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
    }
	[_addMoreFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark EGOAddMoreTableFooterDelegate Methods

- (void)egoAddMoreTableFooterDidTriggerAddMore:(EGORefreshTableHeaderView*)view{
    
	[self addMoreTablewViewDataSourece];
	[self performSelector:@selector(doneAddMoreTableViewData) withObject:nil afterDelay:0.0];
	
}

- (BOOL)egoAddMoreTableFooterDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _adding; // should return if data source model is reloading
	
}

@end
