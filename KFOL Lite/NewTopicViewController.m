//
//  NewTopicViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/22/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "NewTopicViewController.h"


@implementation NewTopicViewController

@synthesize threadDictionary;

-(void)send:(id)sender
{
    NSString *spaceCheckString;
    NSRange spaceCheckRange=NSMakeRange(0, 0);
    BOOL spaceAll=NO;
    
    if ([tileTextField.text lengthOfBytesUsingEncoding:0x80000632]>100) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"标题超过最大长度 100 个字节" delegate:nil cancelButtonTitle:@"返回重新操作" otherButtonTitles:nil]show];
        return;
    }
    if ([tileTextField.text lengthOfBytesUsingEncoding:0x80000632]>50000) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"文章内容大于 50000 个字节" delegate:nil cancelButtonTitle:@"返回重新操作" otherButtonTitles:nil]show];
        return;
    }
    
    
    for (int n=0; n!=2; ++n) {
        switch (n) {
            case 0:
                spaceCheckString=tileTextField.text;
                break;
                
            case 1:
                spaceCheckString=contentTextView.text;
                break;
        }
    
    while (1){
        spaceCheckRange=[spaceCheckString rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (spaceCheckRange.location==NSNotFound && spaceCheckString.length==0) {
            spaceAll=YES;
            break;
        }
        if (spaceCheckRange.location!=0) {
            break;
        }
        spaceCheckString=[spaceCheckString substringFromIndex:spaceCheckRange.location+1];
    }
        
        
        switch (n) {
            case 0:
                if(spaceAll==YES ||tileTextField.text.length==0){
                    [[[UIAlertView alloc]initWithTitle:nil message:@"标题不能为空" delegate:nil cancelButtonTitle:@"返回重新操作" otherButtonTitles:nil]show];
                    return;
                }
            case 1:
                if (spaceAll==YES || contentTextView.text.length<12) {
                    
                    [[[UIAlertView alloc]initWithTitle:nil message:@"文章内容少于 12 个字符" delegate:nil cancelButtonTitle:@"返回重新操作" otherButtonTitles:nil]show];
                    return;
                }
        }
     }
    
    
     [@"post.php" postWithStringContent:[NSString stringWithFormat:@"atc_title=%@&atc_content=%@&step=2&action=new&fid=%@&verify=%@",tileTextField.text,contentTextView.text,[threadDictionary objectForKey:@"ThreadFID"],[threadDictionary objectForKey:@"verify"]] returnResponse:nil error:nil];
     return;
     
    
    NSLog(@"send Bug");
}

-(void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
    self.title=@"New Topic";

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.tableView.allowsSelection=NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    tileTextField=[[UITextField alloc]initWithFrame:CGRectMake(3, 10, [UIScreen mainScreen].bounds.size.width, 45)];
    tileTextField.placeholder=@"Tile";
    
    contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 1600)];
    
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
    switch (indexPath.row) {
        case 0:
            return 45;
            break;
            
        default:
            return 1580;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        switch (indexPath.row) {
            case 0:
                [cell addSubview:tileTextField];
                [tileTextField becomeFirstResponder];
                break;
                
            default:
                [cell addSubview:contentTextView];
                break;
        }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
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
}

@end
