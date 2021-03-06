//
//  LoginTableViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/26/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "LoginTableViewController.h"


@implementation LoginTableViewController

@synthesize messageTable;
@synthesize indexTable;

-(void)login
{
    [@"login.php" postWithStringContent:[NSString stringWithFormat:@"pwuser=%@&pwpwd=%@&step=2",usernameTextField.text,passwordTextField.text] returnResponse:nil error:nil];
    [indexTable viewDidLoad];
    [indexTable.tableView reloadData];
    [messageTable viewDidLoad];
    [messageTable.tableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==usernameTextField) 
        [passwordTextField becomeFirstResponder];
    if (textField==passwordTextField)
        [self login];
    return YES;
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

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.tableView.allowsSelection=NO;
    
    usernameTextField=[[UITextField alloc]initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width, 45)];
    usernameTextField.placeholder=@"username";
    [usernameTextField becomeFirstResponder];
    usernameTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    usernameTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    usernameTextField.enablesReturnKeyAutomatically=YES;
    usernameTextField.delegate=self;
    usernameTextField.returnKeyType=UIReturnKeyNext;
    
    
    passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width, 45)];
    passwordTextField.placeholder=@"password";
    passwordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    passwordTextField.secureTextEntry=YES;
    passwordTextField.delegate=self;
    passwordTextField.returnKeyType=UIReturnKeyGo;
    
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
                [cell addSubview:usernameTextField];
                break;
            case 1:
                [cell addSubview:passwordTextField];
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
