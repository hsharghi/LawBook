//
//  AboutPage.m
//  LawBook final
//
//  Created by saeid1 on 8/29/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "AboutPage.h"
#import "RegisterPage.h"

@interface AboutPage ()
@property NSInteger first;

@property NSString *str;
@property NSMutableAttributedString *attString;
@end

@implementation AboutPage
UIDeviceOrientation orientation_old;
UIDeviceOrientation orientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // gereftane matne darbareie ma va justify kardane an va set kardane font va size va faseleie beine khotot
    NSMutableAttributedString *attrString = _attString;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [attrString length])];
    _txt.attributedText = attrString;
    _txt.textAlignment = NSTextAlignmentJustified;
    _txt.font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];

    UITextPosition *beginning = _txt.beginningOfDocument;
    UITextPosition *start = [_txt positionFromPosition:beginning offset:0];
    UITextPosition *end = [_txt positionFromPosition:start offset:[_txt.text length]];
    UITextRange *textRange = [_txt textRangeFromPosition:start toPosition:end];
    [_txt setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:textRange];
    _txt.textAlignment = NSTextAlignmentJustified;
    [_txt setTextColor:[UIColor whiteColor]];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _str = [[[dict objectForKey:@"about"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"             " withString:@" "];
    _attString = [[NSMutableAttributedString alloc] initWithString:_str];
}

// avaz kardane view b landscape ya portrait
- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForNewOrientation:self.interfaceOrientation];
}

// update kardane view dar zamane charkhesh
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutForNewOrientation:toInterfaceOrientation];
}

// name xib landscape ya portrait o midahad
- (NSString *)nibNameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSString *postfix = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? @"Landscape" : @"Portrait";
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), postfix];
}


/* avaz kardane view be landscape ya portrait----tanzimati k bad az avaz kardane view baiad anjam  shavad ta vaziate
qablie narm afzar hefz shavad mesle raftane tableview b makani k qablan bode ya set kardane matne  haie  k
 b sorate dynamic va dar ejraie app baiad set shavad va ... */

- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation {
    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    NSMutableAttributedString *attrString = _attString;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [attrString length])];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _str = [dict objectForKey:@"about"];

    _txt.attributedText = attrString;
    _txt.textAlignment = NSTextAlignmentJustified;
    _txt.font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];

    UITextPosition *beginning = _txt.beginningOfDocument;
    UITextPosition *start = [_txt positionFromPosition:beginning offset:0];
    UITextPosition *end = [_txt positionFromPosition:start offset:[_txt.text length]];
    UITextRange *textRange = [_txt textRangeFromPosition:start toPosition:end];
    [_txt setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:textRange];
    _txt.textAlignment = NSTextAlignmentJustified;
    [_txt setTextColor:[UIColor whiteColor]];

    _txt.layer.cornerRadius = 4;
    _txt.clipsToBounds = YES;
    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;


}

























// navigation button function

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)home:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}





// baz shodane safeie help baraie iphone dar mode landscape



- (IBAction)help:(UIButton *)sender {


    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(_txt.frame.origin.x, _txt.frame.origin.y, _txt.frame.size.width, _txt.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [theWebView loadRequest:request];

    [self.view addSubview:theWebView];


}


// baz shodane safeie help baraie iphone dar mode landscape
- (IBAction)helplandscape:(UIButton *)sender {


    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(_txt.frame.origin.x, _txt.frame.origin.y, _txt.frame.size.width, _txt.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [theWebView loadRequest:request];

    [self.view addSubview:theWebView];


}


// baz shodane safeie help baraie ipad dar mode portrait
- (IBAction)help_ipad:(UIButton *)sender {


    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(_txt.frame.origin.x, _txt.frame.origin.y, _txt.frame.size.width, _txt.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [theWebView loadRequest:request];

    [self.view addSubview:theWebView];


}

// baz shodane safeie help baraie ipad dar mode landscape

- (IBAction)helplandscape_ipad:(UIButton *)sender {


    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(_txt.frame.origin.x, _txt.frame.origin.y, _txt.frame.size.width, _txt.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [theWebView loadRequest:request];

    [self.view addSubview:theWebView];


}


// navigation button function --- end



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
