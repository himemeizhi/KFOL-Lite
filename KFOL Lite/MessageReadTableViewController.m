//
//  MessageReadTableViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/2/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "MessageReadTableViewController.h"


@implementation MessageReadTableViewController

-(id)initWithMessageDictionary:(NSDictionary *)MessageDetail
{
    self=[self init];
    theMessage=MessageDetail;
    self.navigationItem.title=[theMessage objectForKey:@"MessageTitle"];
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

-(void)replayMessage:(id)sender
{
    ReplyViewController *reply=[[ReplyViewController alloc]init];
    reply.replyDictionary=messageDictionary;
    UINavigationController *subNav=[[UINavigationController alloc]initWithRootViewController:reply];
    [self.navigationController presentModalViewController:subNav animated:YES];
}



#pragma mark - View lifecycle
-(void)loadView
{
    [super loadView];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(replayMessage:)];
    self.tableView.allowsSelection=NO;
    
    NSMutableString *processingNSString=[[NSMutableString alloc]initWithData:[[@"message.php?action=read&mid=" stringByAppendingString:[theMessage objectForKey:@"MessageID"]]getWithStringContent:nil returnResponse:nil error:nil] encoding:0x80000632];
    messageDictionary=[[NSMutableDictionary alloc]initWithDictionary:theMessage];
    processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@"<td style=\""].location];
    processingNSString=[processingNSString substringFromIndex:[processingNSString rangeOfString:@">"].location+1];
    [messageDictionary setObject:[processingNSString substringWithRange:NSMakeRange(0, [processingNSString rangeOfString:@"</td>"].location)] forKey:@"MessageContent"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.scrollEnabled=NO;
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
    if (indexPath.row==3) {
        if (readWebView.webHeight==0) {
            return [UIScreen mainScreen].bounds.size.width;
        }else
        return readWebView.webHeight+10;//self.tableView.contentSize.height;
    }
    else
        return self.tableView.rowHeight;
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        UIWebView *webview;
//        ReadView *webvieww;
    // Configure the cell...
    switch (indexPath.row) {
        case 3:/*
//            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            cell.textLabel.textColor=[UIColor colorWithRed:0x30/255.0 green:0 blue:0x60/255.0 alpha:1];
            
//            [(UIWebView *)[cell viewWithTag:10]loadHTMLString:[messageDictionary objectForKey:@"MessageContent"] baseURL:[NSURL URLWithString:@"http://bbs.9gal.com/"]];
            
            if ([webview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").offsetHeight;"]==nil) {
                NSLog(@"nil_zero");
            }
            NSLog([[webview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").offsetHeight;"] description]);
//            NSLog(.description);
            NSLog(@"done");
//            NSLog(@"%d",n);*/
            
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"postCell" owner:self options:nil]lastObject];
//            webview=[cell viewWithTag:10];
//            [webview loadHTMLString:[messageDictionary objectForKey:@"MessageContent"] baseURL:[NSURL URLWithString:@"http://bbs.9gal.com"]];
            readWebView=[[ReadView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
            [cell addSubview:readWebView];
            readWebView.delegate=readWebView;
            readWebView.tableViewToReload=self.tableView;
            [readWebView loadHTMLString:[[@"<style type=\"text/css\">blockquote{border:1px solid #9999ff;padding:5px;margin:0;}</style><div id='xxx' style='background-color:#f7f7ff;color:#300060;'>" stringByAppendingString:[messageDictionary objectForKey:@"MessageContent"]]stringByAppendingString:@"</div>"]baseURL:[NSURL URLWithString:@"http://bbs.9gal.com"]];
            
            
            
            /*
            readWebView=[[ReadView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
            readWebView.delegate=readWebView;
            [cell addSubview:readWebView];
            [readWebView loadHTMLString:[[@"<div id='xxx' style='background-color:#f7f7ff;color:#300060;'>" stringByAppendingString:[messageDictionary objectForKey:@"MessageContent"]]stringByAppendingString:@"</div>"] baseURL:[NSURL URLWithString:@"http://bbs.9gal.com/"]];
            messageHeight=readWebView.webHeight;
            NSLog(@"messageHeight:%d",messageHeight);*/
            break;
            
        default:
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            cell.textLabel.textColor=[UIColor redColor];
            cell.detailTextLabel.textColor=[UIColor colorWithRed:0x30/255.0 green:0 blue:0x60/255.0 alpha:1];
            break;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"Author";
            cell.detailTextLabel.text=[messageDictionary objectForKey:@"SenderUserName"];
            break;
        case 1:
            cell.textLabel.text=@"Title";
            cell.detailTextLabel.text=[messageDictionary objectForKey:@"MessageTitle"];
            break;
        case 2:
            cell.textLabel.text=@"Date";
            cell.detailTextLabel.text=[messageDictionary objectForKey:@"MessageDate"];
            break;
        default:
//            cell.textLabel.text=[messageDictionary objectForKey:@"MessageContent"];
//            cell.textLabel.numberOfLines=[[messageDictionary objectForKey:@"MessageContent"] length] /[@"[v0.352更新公告]板块调整+成" length]+1;
//            [cell addSubview:[[UIWebView alloc]initWithFrame:<#(CGRect)#>
//            [(UIWebView *)[cell viewWithTag:10]setFrame:<#(CGRect)#>
//            [(UIWebView *)[cell viewWithTag:10] scrollView].scrollEnabled=NO;
            break;
    }}
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;}
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
//    [self performSelector:@selector(deselect)withObject:nil afterDelay:0];
}

@end
