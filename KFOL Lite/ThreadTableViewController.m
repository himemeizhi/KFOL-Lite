//
//  ThreadTableViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "ThreadTableViewController.h"


@implementation ThreadTableViewController

-(id)initWithThreadDictionary:(NSDictionary *)ThreadDetail
{
    self=[self init];
    theThread=ThreadDetail;
    self.title=[theThread objectForKey:@"ThreadName"];
    reloadCount=-1;
    return self;
}

-(void)newTopic
{
    NewTopicViewController *newTopicViewController=[[NewTopicViewController alloc]init];
    newTopicViewController.threadDictionary=theThread;
    newTopicViewController.tableView.scrollEnabled=NO;
    UINavigationController *subNav=[[UINavigationController alloc]initWithRootViewController:newTopicViewController];
    [self presentModalViewController:subNav animated:YES];
}

-(void)loadHTMLContents
{
    reloadCount++;
    
    NSMutableString *processingNSString=[[NSMutableString alloc]initWithData:thread_php_html encoding:0x80000632];
    
    if ([processingNSString rangeOfString:@">首页</a>"].location!=NSNotFound) {
        
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<b> "])];
        [pagesInfo setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@" "].location)] forKey:@"PageNow"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\">"].location+2];
        [pagesInfo setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"PageNext"];
        if ([[pagesInfo objectForKey:@"PageNext"]compare:@"后10页"]==NSOrderedSame) {
            [pagesInfo removeObjectForKey:@"PageNext"];
        }
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"页码: ( "])];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"/"].location+1];
        [pagesInfo setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@" )"].location)] forKey:@"PageMax"];
    }
    
    
    if ([processingNSString rangeOfString:@"子版块"].location!=NSNotFound) {
        subThreadDetails=[[NSMutableDictionary alloc]init];
        
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"><a href=\"thread.php?fid="])];
        [subThreadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"ThreadFID"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@" color=\""])];
        [subThreadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, 7)] forKey:@"ThreadNameColor"];
        processingNSString=[processingNSString substringFromIndex:9];
        [subThreadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</font>"].location)] forKey:@"ThreadName"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<a href=\"read.php?tid="])];
        [subThreadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"&"].location)] forKey:@"LastPostTID"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\">"].location+2];
        [subThreadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"LastPostName"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"作者："])];
        [subThreadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@" 时间"].location)] forKey:@"LastPostUserName"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"时间："])];
        [subThreadDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, 16)] forKey:@"LastPostDate"];
        if([ThreadPHP indexOfObject:subThreadDetails]==NSNotFound)
        [ThreadPHP addObject:subThreadDetails];
    }
    
    
    for(;;)
    {
        
        NSMutableDictionary *postProperties=[[NSMutableDictionary alloc]init];
        if ([processingNSString rangeOfString:@"<tr><td><a title=\"打开新窗口\" href=\""].location==NSNotFound) {
            NSString *getVerify=[[NSString alloc]initWithData:[[NSString stringWithFormat:@"post.php?fid=%@",[theThread objectForKey:@"ThreadFID"]]getWithStringContent:nil returnResponse:nil error:nil] encoding:0x80000632];
            int verify=NSMaxRange([getVerify rangeOfString:@"\"verify\" value=\""]);
            if (verify!=NSNotFound)
                [theThread setObject:[getVerify substringWithRange:NSMakeRange(verify, 8)] forKey:@"verify"];
            else
                self.navigationItem.rightBarButtonItem=nil;
            break;
        }
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<tr><td><a title=\"打开新窗口\" href=\"read.php?tid="])];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"TopicID"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"/welcome/thread/"])];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"'"].location)] forKey:@"TopicType"];
        if ([processingNSString rangeOfString:@"/welcome/file/headtopic"].location!=NSNotFound) {
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"/welcome/file/"])];
            [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, 15)] forKey:@"HeadTopic"];
            [headArray addObject:postProperties];
        }
        else
            [postArray addObject:postProperties];
        
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"<a href=\"read.php?tid="].location+9];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@">"].location+1];
        if([processingNSString rangeOfString:@"<b>"].location < [processingNSString rangeOfString:@"</a>"].location)
        {
            [postProperties setObject:@"Bold" forKey:@"Bold"];
            processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@">"].location+1];
            //            processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"red>"].location+4];
            //            [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</font>"].location)] forKey:@"PostName"];
        }
        if([processingNSString rangeOfString:@"<font"].location < [processingNSString rangeOfString:@"</a>"].location)
        {
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@" color="])];
            [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@">"].location)] forKey:@"PostColor"];
            processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@">"].location+1];
        }
        [postProperties setObject:[[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</"].location)]stringByDecodingHTMLEntities] forKey:@"PostName"];
        
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<td><a href=\"profile.php?action=show&uid="])];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\">"].location)] forKey:@"UserID"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\">"].location+2];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a><br />"].location)] forKey:@"UserName"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"</a><br />"].location+10];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, 10)] forKey:@"PostDate"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"<td>"].location+4];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</td>"].location)] forKey:@"Reposts"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"<td>"].location+4];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</td>"].location)] forKey:@"PageViews"];
        /*processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"<a href=\""].location+9];
         [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\">"].location)] forKey:@"LastRepostURL"];*/        
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"\"> "].location+3];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, 16)] forKey:@"LastRepostDate"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"by: "].location+4];
        [postProperties setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</td>"].location)] forKey:@"LastRepostUserName"];
        
        //        [postProperties setObject:[theThread objectForKey:@"ThreadFID"] forKey:@"ThreadFID"];
        //        [postArray addObject:postProperties];
    }
    if (headArray.count!=0 && [ThreadPHP indexOfObject:headArray]==NSNotFound) {
        [ThreadPHP addObject:headArray];
    }
    if([ThreadPHP indexOfObject:postArray]==NSNotFound)
    [ThreadPHP addObject:postArray];
    [ThreadPHP writeToFile:[NSHomeDirectory() stringByAppendingString:@"/tmp/thread.plist"] atomically:YES];
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
//    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"KFOL" style:UIBarButtonItemStyleBordered target:nil action:nil];
    if (([[theThread objectForKey:@"ThreadFID"]compare:@"9"]==NSOrderedSame)|| ([[theThread objectForKey:@"ThreadFID"]compare:@"98"]==NSOrderedSame)) {
        UIAlertView *Aler=[[UIAlertView alloc]initWithTitle:@">A<" message:@"这个板块施工中⋯⋯" delegate:nil cancelButtonTitle:@"所以暂时不能看⋯⋯" otherButtonTitles: nil];
        [Aler show];
        return;
    }
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"NewTopic" style:UIBarButtonItemStylePlain target:self action:@selector(newTopic)];
    self.tableView.backgroundColor=[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:1 alpha:1];
    if (_refreshHeaderView==nil) {
        EGORefreshTableHeaderView *refreshTableHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        refreshTableHeaderView.delegate=self;
        [self.tableView addSubview:refreshTableHeaderView];
        _refreshHeaderView=refreshTableHeaderView;
    }
    [_refreshHeaderView refreshLastUpdatedDate];

//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"KFOL" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
    
    
    thread_php_html=[[NSString stringWithFormat:@"thread.php?fid=%@",[theThread objectForKey:@"ThreadFID"]] getWithStringContent:nil returnResponse:nil error:nil];
    postArray=[[NSMutableArray alloc]init];
    ThreadPHP=[[NSMutableArray alloc]init];
    headArray=[[NSMutableArray alloc]init];
    pagesInfo=[[NSMutableDictionary alloc]init];
    
    [self loadHTMLContents];
    
    if (_addMoreFooterView==nil && [pagesInfo objectForKey:@"PageNext"]!=nil) {
        _addMoreFooterView=[[EGORefreshTableHeaderView alloc]initWithFrameInBottom:CGRectMake(0, -460, 0, 0)];
        _addMoreFooterView.delegate=self;
        [self.tableView addSubview:_addMoreFooterView];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (subThreadDetails!=nil && indexPath.section==0) {
        return self.tableView.rowHeight;
    }
    return self.tableView.rowHeight+[[[[ThreadPHP objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"PostName"]sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]].height * ([[[[ThreadPHP objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"PostName"]lengthOfBytesUsingEncoding:0x80000632]/[@"[v0.352更新公告]板块调整+成" lengthOfBytesUsingEncoding:0x80000632]+1);
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (ThreadPHP.count==3) {
        switch (section) {
            case 0:
                return nil;
            case 1:
                return @"置顶帖";
            default:
                return @"话题";
        }
    }
    if (ThreadPHP.count==2) {
        switch (section) {
            case 0:
                return @"置顶帖";
            default:
                return @"话题";
        }
    }
    if (ThreadPHP.count==1) {
        return @"话题";
    }
}       



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return ThreadPHP.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([ThreadPHP objectAtIndex:section]==subThreadDetails) {
        return 1;
    }
    return [[ThreadPHP objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d_%d_%d",indexPath.section,indexPath.row,reloadCount];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
    // Configure the cell...
    if([ThreadPHP objectAtIndex:indexPath.section]==postArray)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text=[[postArray objectAtIndex:indexPath.row]objectForKey:@"PostName"];
        if ([[postArray objectAtIndex:indexPath.row]objectForKey:@"Bold"]!=nil) {
            cell.textLabel.font=[UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        }
        cell.textLabel.lineBreakMode=UILineBreakModeCharacterWrap;
        cell.detailTextLabel.text=[[[postArray objectAtIndex:indexPath.row]objectForKey:@"UserName"]stringByAppendingFormat:@"｜%@｜%@/%@",[[postArray objectAtIndex:indexPath.row]objectForKey:@"PostDate"],[[postArray objectAtIndex:indexPath.row]objectForKey:@"Reposts"],[[postArray objectAtIndex:indexPath.row]objectForKey:@"PageViews"]];
        if ([[postArray objectAtIndex:indexPath.row]objectForKey:@"PostColor"]==nil) {
            cell.textLabel.textColor=[UIColor colorWithRed:0x55/255.0 green:0x11/255.0 blue:0xdd/255.0 alpha:1];
        }else
        if ([[[postArray objectAtIndex:indexPath.row]objectForKey:@"PostColor"]compare:@"red"]==NSOrderedSame) {
            cell.textLabel.textColor=[UIColor redColor];
        }else
            if ([[[postArray objectAtIndex:indexPath.row]objectForKey:@"PostColor"]compare:@"blue"]==NSOrderedSame) {
                cell.textLabel.textColor=[UIColor blueColor];
            }else
                if ([[[postArray objectAtIndex:indexPath.row]objectForKey:@"PostColor"]compare:@"green"]==NSOrderedSame) {
                    cell.textLabel.textColor=[UIColor greenColor];
                }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image=[UIImage imageNamed:[[postArray objectAtIndex:indexPath.row]objectForKey:@"TopicType"]];
        cell.textLabel.numberOfLines=[[[postArray objectAtIndex:indexPath.row]objectForKey:@"PostName"]lengthOfBytesUsingEncoding:0x80000632]/[@"[v0.352更新公告]板块调整+成" lengthOfBytesUsingEncoding:0x80000632]+1;
        
        if (indexPath.row+1==[[ThreadPHP objectAtIndex:indexPath.section] count] && indexPath.section+1==ThreadPHP.count) {
            [_addMoreFooterView setFrame:CGRectMake(0, tableView.contentSize.height+65, tableView.frame.size.width, tableView.bounds.size.height)];
        }
        
        return cell;
    }
    
    if([ThreadPHP objectAtIndex:indexPath.section]==headArray)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text=[[headArray objectAtIndex:indexPath.row]objectForKey:@"PostName"];
        if ([[headArray objectAtIndex:indexPath.row]objectForKey:@"Bold"]!=nil) {
            cell.textLabel.font=[UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        }
        cell.textLabel.lineBreakMode=UILineBreakModeCharacterWrap;
        NSString *username=[[headArray objectAtIndex:indexPath.row]objectForKey:@"UserName"];
//        int length=[username lengthOfBytesUsingEncoding:0x80000632];
//        for(int n=0;n!=14-length;n++){NSLog(@"%d",n);
//            username=[username stringByAppendingString:@" "];         }
        cell.detailTextLabel.text=[username stringByAppendingFormat:@"｜%@｜%@/%@",[[headArray objectAtIndex:indexPath.row]objectForKey:@"PostDate"],[[headArray objectAtIndex:indexPath.row]objectForKey:@"Reposts"],[[headArray objectAtIndex:indexPath.row]objectForKey:@"PageViews"]];
        if ([[[headArray objectAtIndex:indexPath.row]objectForKey:@"PostColor"]compare:@"red"]==NSOrderedSame) {
            cell.textLabel.textColor=[UIColor redColor];
        }else
            if ([[[headArray objectAtIndex:indexPath.row]objectForKey:@"PostColor"]compare:@"blue"]==NSOrderedSame) {
                cell.textLabel.textColor=[UIColor blueColor];
            }else
                if ([[[headArray objectAtIndex:indexPath.row]objectForKey:@"PostColor"]compare:@"green"]==NSOrderedSame) {
                    cell.textLabel.textColor=[UIColor greenColor];
                }else
                    cell.textLabel.textColor=[UIColor colorWithRed:0x55/255.0 green:0x11/255.0 blue:0xdd/255.0 alpha:1];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if ([[[headArray objectAtIndex:indexPath.row]objectForKey:@"TopicType"]compare:@"topiclock.gif"]==NSOrderedSame) {
            cell.imageView.image=[UIImage imageNamed:@"topiclock.gif"];
        }
        else
            cell.imageView.image=[UIImage imageNamed:[[headArray objectAtIndex:indexPath.row]objectForKey:@"HeadTopic"]];
        cell.textLabel.numberOfLines=[[[postArray objectAtIndex:indexPath.row]objectForKey:@"PostName"]lengthOfBytesUsingEncoding:0x80000632]/[@"[v0.352更新公告]板块调整+成" lengthOfBytesUsingEncoding:0x80000632]+1;
        if (indexPath.row+1==[[ThreadPHP objectAtIndex:indexPath.section] count] && indexPath.section+1==ThreadPHP.count) {
            [_addMoreFooterView setFrame:CGRectMake(0, tableView.contentSize.height+65, tableView.frame.size.width, tableView.bounds.size.height)];
        }
        return cell;
    }
        
    if ([ThreadPHP objectAtIndex:indexPath.section]==subThreadDetails)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text=[subThreadDetails objectForKey:@"ThreadName"];
        cell.textLabel.textColor=[UIColor redColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    [[[UIAlertView alloc]initWithTitle:@"error" message:@"处理主题列表发生错误" delegate:nil cancelButtonTitle:@"仕方ないね" otherButtonTitles:nil]show];
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
    if (subThreadDetails!=nil && indexPath.section==0) {
        subController=[[ThreadTableViewController alloc]initWithThreadDictionary:subThreadDetails];
    }
    else{
        subController=[[PostTableViewController alloc]initWithPostDictionary:[[ThreadPHP objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        subController.threadFID=[theThread objectForKey:@"ThreadFID"];
    }
    [self.navigationController pushViewController:subController animated:YES];
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self loadHTMLContents];
    [self.tableView reloadData];
    [_refreshHeaderView refreshLastUpdatedDate];
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
    thread_php_html=[[NSString stringWithFormat:@"thread.php?fid=%@&page=%@",[theThread objectForKey:@"ThreadFID"],[pagesInfo objectForKey:@"PageNext"]]getWithStringContent:nil returnResponse:nil error:nil];
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
/*
- (NSDate*)egoAddMoreTableFooterDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}*/

@end