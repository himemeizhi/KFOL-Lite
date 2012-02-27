//
//  ReplyViewController.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/10/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "ReplyViewController.h"

@implementation ReplyViewController

@synthesize replyDictionary;
@synthesize threadFID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

CGRect CGRectShrinkHeight(CGRect rect, CGFloat amount)
{
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - amount);
}

-(void)send:(id)sender
{
    
    NSString *spaceCheckString=textView.text;
    NSRange spaceCheckRange=NSMakeRange(0, 0);
    BOOL spaceAll=NO;
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
    if(spaceAll==YES || textView.text.length==0){
        [[[UIAlertView alloc]initWithTitle:@"您的操作因为以下原因无法继续:" message:@"用户名，标题或内容为空. " delegate:nil cancelButtonTitle:@"返回重新操作" otherButtonTitles:nil]show];
        return;
    }
    
    if ([replyDictionary objectForKey:@"MessageID"]!=nil) {
        [@"message.php" postWithStringContent:[NSString stringWithFormat:@"pwuser=%@&msg_title=%@&atc_content=%@&action=write&step=2",[replyDictionary objectForKey:@"SenderUserName"],[@"Re:" stringByAppendingString:[replyDictionary objectForKey:@"MessageTitle"]],textView.text] returnResponse:nil error:nil];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    if ([replyDictionary objectForKey:@"TopicID"]!=nil) {
        [@"post.php" postWithStringContent:[NSString stringWithFormat:@"atc_title=none&atc_content=%@&step=2&action=reply&fid=%@&tid=%@&verify=%@",textView.text,threadFID,[replyDictionary objectForKey:@"TopicID"],[replyDictionary objectForKey:@"verify"]] returnResponse:nil error:nil];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    NSLog(@"send Bug");
}

-(void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle


- (void) keyboardWillHide: (NSNotification *) notification
{
	// return to previous text view size
//	textView.frame = self.view.bounds;
}

- (void) adjustForKeyboard: (NSNotification *) notification
{
    
	// Retrieve the keyboard bounds via the notification userInfo dictionary
/*	CGRect kbounds;
	NSDictionary *userInfo = [notification userInfo];
	[(NSValue *)[userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&kbounds];
  */  
	// Shrink the textview frame -- comment this out to see the default behavior
/*    CGRect destRect = CGRectShrinkHeight(self.view.bounds, kbounds.size.height);
	textView.frame = destRect;*/
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 4, [UIScreen mainScreen].bounds.size.width, 416)];
//    textView.font=[UIFont fontWithName:@"Helvetica Neue" size:14.0f];
//	tv.font = [UIFont fontWithName:@"Georgia" size:(IS_IPAD) ? 24.0f : 14.0f];
	[self.view addSubview:textView];
    [textView becomeFirstResponder];
/*    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustForKeyboard:) name:UIKeyboardDidShowNotification object:nil];*/
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.title=@"Reply";
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
