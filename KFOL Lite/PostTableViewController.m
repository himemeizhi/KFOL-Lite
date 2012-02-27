//
//  PostTableViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "PostTableViewController.h"


@implementation PostTableViewController

@synthesize threadFID;
@synthesize loadCount;

-(id)initWithPostDictionary:(NSDictionary *)PostDetail
{
    self=[self init];
    thePost=PostDetail;
    self.title=[thePost objectForKey:@"PostName"];
    return self;
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

-(void)newPost
{
    ReplyViewController *replayview=[[ReplyViewController alloc]init];
    replayview.replyDictionary=thePost;
    replayview.threadFID=threadFID;
    UINavigationController *subNav=[[UINavigationController alloc]initWithRootViewController:replayview];
    [self presentModalViewController:subNav animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[thePost objectForKey:@"TopicType"]compare:@"topiclock.gif"]!=NSOrderedSame)
         self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(newPost)];
    
    post_php_html=[[NSString stringWithFormat:@"read.php?tid=%@",[thePost objectForKey:@"TopicID"]] getWithStringContent:nil returnResponse:nil error:nil];
    NSMutableString *processingNSString=[[NSMutableString alloc]initWithData:post_php_html encoding:0x80000632];
    NSMutableDictionary *postDetails;
    postArray=[[NSMutableArray alloc]init];
    self.tableView.backgroundColor=[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:1 alpha:1];

    
    for(;;)
    {
        postDetails=[[NSMutableDictionary alloc]init];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<a href=\"profile.php?action=show&uid="])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"UserID"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"color:"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(1,6)] forKey:@"UserNameColor"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\">"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"UserName"];
        
        if ([processingNSString rangeOfString:@"版[Lv."].location!=NSNotFound) {
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"版[Lv."])];
            [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"]"].location)] forKey:@"UserLevel"];
        }
        else
        {
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\">"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"&nbsp"].location)] forKey:@"UserLevel"];
        }
        
        if ([processingNSString rangeOfString:@"<img"].location < [processingNSString rangeOfString:@"kf_g"].location) {
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<img src=\""])];
            [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"\""].location)] forKey:@"UserImg"];
        }
        
        if([processingNSString rangeOfString:@"kf_growup"].location!=NSNotFound)
        {
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"kf_growup"].location];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\">"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"UserGrowup"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"kf_no1"].location];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\">"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"UserLevelNum"];
        processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"profile.php"].location];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\">"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</a>"].location)] forKey:@"UserFriends"];
        }
        if ([processingNSString rangeOfString:@"]人关注|我也要关注"].location!=NSNotFound) {
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"随时删除）')\">["])];
            [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"]"].location)] forKey:@"UserFriends"];
        }
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"<b>"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</b>"].location)] forKey:@"StageNum"];
        if([processingNSString rangeOfString:@"kf_vmember.php"].location < [processingNSString rangeOfString:@"发表于："].location)
        {
            [postDetails setObject:@"VIP" forKey:@"VMem"];
        }
        if([processingNSString rangeOfString:@"( "].location < [processingNSString rangeOfString:@"发表于："].location)
        {
            processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"( "])];
            [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [(NSString *)[processingNSString substringWithRange:NSMakeRange(0, @"管理操作通知，请重新设定你的 .. ".length+4)]rangeOfString:@" ) " options:NSBackwardsSearch].location)] forKey:@"UserHonor"];
        }
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"："])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0,16)] forKey:@"PostDate"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"pid="])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"&"].location)] forKey:@"PostID"];
        processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"tpc_content\">"])];
        [postDetails setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</div>\r\n"].location)] forKey:@"PostContent"];
        
        [postArray addObject:postDetails];
        NSLog(postDetails.description);
        if ([processingNSString rangeOfString:@"<a href=\"profile.php?action=show"].location==NSNotFound) {
            if ([processingNSString rangeOfString:@"\"verify\" value=\""].location!=NSNotFound) {
                processingNSString=[processingNSString substringFromIndex:NSMaxRange([processingNSString rangeOfString:@"\"verify\" value=\""])];
                [thePost setObject:[processingNSString substringWithRange:NSMakeRange(0, 8)] forKey:@"verify"];
            }
            else{
                self.navigationItem.rightBarButtonItem=nil;
            }
            break;
        }
        
        
    }
    
    [postArray writeToFile:[NSHomeDirectory() stringByAppendingString:@"/tmp/post.plist"] atomically:YES];
    
    HeightwebView=[[PostReadView alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
    HeightwebView.delegate=HeightwebView;
    HeightwebView.posts=postArray;
    HeightwebView.max=postArray.count;
    HeightwebView.n=0;
    HeightwebView.loadC=&loadCount;
    HeightwebView.tableViewToReload=self.tableView;
    HeightwebView.heights=[[NSMutableArray alloc]init];
    indexPaths=[[NSMutableArray alloc]init];
    HeightwebView.rowsToReload=indexPaths;
    
    NSMutableString *postSizeCheckString=[[NSMutableString alloc]initWithString:[[postArray objectAtIndex:0]objectForKey:@"PostContent"]];
    while([postSizeCheckString rangeOfString:@"if(this.width>'700')this.width='700';"].location!=NSNotFound) {
        [postSizeCheckString replaceCharactersInRange:[postSizeCheckString rangeOfString:@"if(this.width>'700')this.width='700';"] withString:@"if(this.width>'300')this.width='300';"];
    }
    
    [HeightwebView loadHTMLString:[[@"<div id='xxx'>" stringByAppendingString:postSizeCheckString]stringByAppendingString:@"</div>"] baseURL:[NSURL URLWithString:@"http://bbs.9gal.com"]];
    
    
    
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
    switch (indexPath.row%2) {
        case 0:
            return self.tableView.rowHeight;
            break;
            
        default:
            if (HeightwebView.heights.count!=postArray.count) {
                return self.tableView.rowHeight;//NSLog(@"2");
            }
            return [[HeightwebView.heights objectAtIndex:indexPath.row/2]intValue]+5;
            break;
    }
}

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
    return postArray.count*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || loadCount!=0) {
    
    switch (indexPath.row%2) {
        case 0:
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserCell" owner:self options:nil]lastObject];
            [(UILabel *)[cell viewWithTag:101]setText:[[postArray objectAtIndex:indexPath.row/2]objectForKey:@"UserName"]];            
             int color=0;
            sscanf([(NSString *)[[postArray objectAtIndex:indexPath.row/2]objectForKey:@"UserNameColor"]UTF8String], "%x",&color);
            [(UILabel *)[cell viewWithTag:101]setTextColor:[UIColor colorWithRed:((color>>16)&0xff)/255.0 green:((color>>8)&0xff)/255.0 blue:(color&0xff)/255.0 alpha:1]];
            [(UILabel *)[cell viewWithTag:102]setText:[[postArray objectAtIndex:indexPath.row/2]objectForKey:@"StageNum"]];
            [(UILabel *)[cell viewWithTag:102]setTextColor:[UIColor colorWithRed:0x55/255.0 green:0x11/255.0 blue:0xdd/255.0 alpha:1]];
            [(UILabel *)[cell viewWithTag:103]setText:[[postArray objectAtIndex:indexPath.row/2]objectForKey:@"PostDate"]];
            [(UILabel *)[cell viewWithTag:103]setTextColor:[UIColor colorWithRed:0x55/255.0 green:0x11/255.0 blue:0xdd/255.0 alpha:1]];
            
//            [(UIImageView *)[cell viewWithTag:104]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[@"http://bbs.9gal.com/" stringByAppendingString:[[postArray objectAtIndex:indexPath.row]objectForKey:@"UserImg"]]]]]];
            break;
        case 1:/*
            cell=[[[NSBundle mainBundle]loadNibNamed:@"postCell" owner:self options:nil]lastObject];
            [(UIWebView *)[cell viewWithTag:10]loadHTMLString:[[postArray objectAtIndex:indexPath.row/2]objectForKey:@"PostContent"] baseURL:[NSURL URLWithString:@"http://bbs.9gal.com/"]];*/
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [indexPaths addObject:indexPath];
//            cell.textLabel.text=@"PostContent";
            switch (loadCount) {
                case 0:
                    cell.textLabel.text=@"手姬正在很~努力地读取数据⋯⋯";
                    break;
                default:
                    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[HeightwebView.heights objectAtIndex:indexPath.row/2]intValue]+5)];
                    [cell addSubview:webview];
//                    NSLog([[postArray objectAtIndex:indexPath.row/2]objectForKey:@"PostContent"]);NSLog(@"qwertyui");
                    NSMutableString *postSizeCheckString=[[NSMutableString alloc]initWithString:[[postArray objectAtIndex:indexPath.row/2]objectForKey:@"PostContent"]];
                    while([postSizeCheckString rangeOfString:@"if(this.width>'700')this.width='700';"].location!=NSNotFound) {
                        [postSizeCheckString replaceCharactersInRange:[postSizeCheckString rangeOfString:@"if(this.width>'700')this.width='700';"] withString:@"if(this.width>'300')this.width='300';"];NSLog(@"awsedtfhyujk");
                    }//NSLog(postSizeCheckString);
                    cell.backgroundColor=[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:1 alpha:1];
//                    webview.backgroundColor=[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:1 alpha:1];
                    [webview loadHTMLString:[[@"<style type=\"text/css\">blockquote{border:1px solid #9999ff;padding:5px;margin:0;}</style><div style='background-color:#f7f7ff;color:#300060;'>" stringByAppendingString:postSizeCheckString]stringByAppendingString:@"</div>"] baseURL:[NSURL URLWithString:@"http://bbs.9gal.com"]];
                    webview.scrollView.scrollEnabled=NO;
                    break;
            }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
}

@end
