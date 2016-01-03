//
//  ShopPage1.m
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//
#import "AppDelegate.h"
#import "LibraryPage1.h"
#import "FavPage.h"
#import "LibraryPage2.h"
#import "UIImageView+WebCache.h"
#import "CollectionCell.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "AFHTTPSessionManager.h"

#import "UpdatePage1.h"
#import <sqlite3.h>

#import "DataClass.h"

@interface LibraryPage1 ()
{
    
}

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) DBManager *dbManager2;
@property (nonatomic, strong) DBManager *dbManager3;



@property NSURLSessionDownloadTask *downloadTask;
@property Boolean is_cancell;
@property Boolean show_btn;
@property int temp_index;
@property (assign, nonatomic) BOOL longPressActive;
@property int delete_index;
@property NSInteger row_num;
@property DataClass *obj;

@end

@implementation LibraryPage1


CollectionCell *dl_cell;// celli k dar hale download mibashad
NSUserDefaults *setting;
NSString *imei;
NSString *username;


int idx1l=1 ;
int has_data1l=1;
int dl_index=-1;
CGFloat prog=0;
NSTimer *timer;
Boolean error_enable=true;
Boolean dl_running=false;
Boolean dl_error=false;
NSMutableArray *show1l;
NSMutableArray *show1l2;
NSMutableString *temp_path;

NSMutableDictionary *_frames1;


NSMutableArray *name1l;
NSMutableArray *searchname1l;
NSMutableArray *ids1l;
NSMutableArray *versions;

NSMutableArray *pics1l;
MBProgressHUD *hud ;
NSString *loading_str;
NSString *error_str;


NSMutableArray *dbpics1l;
NSMutableArray *dbid1l;
NSMutableArray *dbname1l;

sqlite3 *database;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Initialize the progress view
    // tanzimate avalie
    
    NSLog(@"LibraryPage1");
    
//    if (!_frames1)
        _frames1 = [NSMutableDictionary new];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCellLibrary" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellLibrary"];
    [collectionView setBackgroundView:nil];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    
    _show_btn=false ;
    _image_btn.hidden=YES;
    _temp_index=-1;
    
    username=[setting stringForKey:@"username"];
    imei=[setting stringForKey:@"imei"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];
    
    temp_path=[[NSMutableString alloc]init ];
    
    if(dl_index ==-1)
    {
        ids1l = [[NSMutableArray alloc] init];
        pics1l = [[NSMutableArray alloc] init];
        name1l = [[NSMutableArray alloc] init];
        show1l = [[NSMutableArray alloc] init];
        show1l2 = [[NSMutableArray alloc] init];
        versions = [[NSMutableArray alloc] init];
        [self GetFromDatabase:nil];
    }
    else
    {
        
    }
    
    
    [self show_update_num];
    
    
    self.searchField.delegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)show_loading
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = loading_str;
}

#pragma mark - SearchDisplayController & SearchBar Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
    [self setSearchFieldCancelTextTo:@"لغو"];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
    searchBar.text = @"";
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        [self searchTapped:searchBar];
    
    [ids1l removeAllObjects];
    [name1l removeAllObjects];
    [pics1l removeAllObjects];
    [show1l removeAllObjects];
    [show1l2 removeAllObjects];
    
    [self GetFromDatabase:nil];
    [collectionView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (searchText.length >= 0) {
        [searchBar setShowsCancelButton:YES];
        [self setSearchFieldCancelTextTo:@"لغو"];
        [ids1l removeAllObjects];
        [name1l removeAllObjects];
        [pics1l removeAllObjects];
        [show1l removeAllObjects];
        [show1l2 removeAllObjects];
//    }
    [self GetFromDatabase:searchText];
    [collectionView reloadData];
}


-(void)searchTapped:(id)sender
{
    if (self.searchField.alpha == 1.0) //check if seachBar is hidden
        [self animateSearchBar:NO]; // show searchBar
    else
        [self animateSearchBar:YES]; // hide searchBar
}

- (IBAction)reframe:(id)sender {
    if (_frames1.count) {
        for (NSNumber *key in _frames1)
        {
            CGRect frame = [[_frames1 objectForKey:key] CGRectValue];
            NSInteger tag = [key integerValue];
            UIView *view = [self.view viewWithTag:tag];
            view.frame = frame;
        }
    }
    
}



//--------------------------------------- Collection View Functions ---------------------------


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [ids1l count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellLibrary" forIndexPath:indexPath];
    cell.container.layer.cornerRadius = 5;
    cell.container.clipsToBounds = YES;
    cell.name.text = [name1l objectAtIndex:indexPath.row];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[pics1l objectAtIndex:indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"black_bg.png"]];
    
    // set kardane progress bar agar download nashode bashad ya dar hale download bashad
    if([[show1l objectAtIndex:indexPath.row] intValue]==0)
    {
        cell.labeledProgressView.hidden=YES;
        
        cell.dl.image = [UIImage imageNamed:@"download.png"];
    }
    else
    {
        cell.labeledProgressView.hidden=NO;
        cell.dl.image = [UIImage imageNamed:@"pause.png"];
        dl_cell=cell;
    }
    
    //--------------------------
    if([[show1l2 objectAtIndex:indexPath.row] intValue]==0)
    {
        cell.tempProgressView.hidden=YES;
        cell.dl.hidden=YES;
    }
    else
    {
        cell.tempProgressView.hidden=NO;
        cell.dl.hidden=NO;
        
    }
    
    
    
    // set kardane gesture baraie long click
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5; //seconds
    [cell addGestureRecognizer:lpgr];
    
    
    
    return cell;
    
    
}





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.longPressActive) { //Perform action desired when cell is long pressed
        
        
        
        
        
        
        
        
        
        
    }else { //Perform action desired when cell is selected normally
        
        
        
        
        NSString *query = [NSString stringWithFormat:@"select * from books where id='%@' ",[ids1l objectAtIndex:indexPath.row]];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
        int dl=[[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"download"]] intValue ];
        int copy=[[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"copy"]] intValue ];
        
        
        
        // agar download nashode bashad download mikonad
        if(dl==0)
        {
            if(!dl_running)
            {
                if(_obj.Request2==nil)
                {
                    dl_running=true;
                    dl_index=indexPath.row ;
                    dl_cell=[collectionView cellForItemAtIndexPath:indexPath];
                    //[self download_img:[ids1l objectAtIndex:indexPath.row] ];
                    [self download_book:[ids1l objectAtIndex:indexPath.row] ];
                    [collectionView reloadData];
                }
                
            }
            else
            {
                //_is_cancell=true;
                if(dl_index==indexPath.row)
                {
                    [_obj.Request1 cancel];
                    [_obj.Request1 clearDelegatesAndCancel];
                    [show1l replaceObjectAtIndex:dl_index withObject:@"0"];
                    dl_index=-1;
                    prog=0;
                    dl_running=false ;
                    
                    [_obj.Request1 cancel];
                    [_obj.Request1 clearDelegatesAndCancel];
                    _obj.Request1=nil;
                    [collectionView reloadData];
                }
                
                
            }
        }
        else if(copy==0)
        {
            if(!dl_running)
            {
                [self copy_book:indexPath.row];
            }
            
        }
        else
        {
            //agar download shode bashad tasvire ketab ra neshan midahad
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(read_book:)];
            singleTap.numberOfTapsRequired = 1;
            [_image_btn setUserInteractionEnabled:YES];
            [_image_btn addGestureRecognizer:singleTap];
            
            [_image_btn sd_setImageWithURL:[NSURL URLWithString:[pics1l objectAtIndex:indexPath.row]]
                          placeholderImage:[UIImage imageNamed:@"black_bg.png"]];
            _image_btn.hidden=NO;
            _temp_index=indexPath.row;
            _image_btn.contentMode = UIViewContentModeScaleAspectFit;
            _image_btn.backgroundColor=[UIColor blackColor];
            
            
        }
    }
    
    
    
    
    
    
}



//--------------------------------------------------------------------------
// set kardane progress bar
- (void)progressChange
{
    
    [dl_cell.labeledProgressView setProgress:prog animated:YES];
    int i=dl_cell.labeledProgressView.progress*100;
    dl_cell.labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d %%",i];
    
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



// type ketab download shode ra barmigardanad
-(int)GetType:(NSArray *)col
{
    int type=0;
    for(int i=0;i<[col count];i++)
    {
        if([[NSString stringWithFormat:@"%@", [col objectAtIndex:i]] isEqualToString:@"ray"])
            return 2;
        if([[NSString stringWithFormat:@"%@", [col objectAtIndex:i]] isEqualToString:@"madeh"])
            return 3;
        if([[NSString stringWithFormat:@"%@", [col objectAtIndex:i]] isEqualToString:@"mean"])
            return 5;
        if([[NSString stringWithFormat:@"%@", [col objectAtIndex:i]] isEqualToString:@"marja"])
            type=1;
    }
    
    for(int i=0;i<[col count];i++)
    {
        if([[NSString stringWithFormat:@"%@", [col objectAtIndex:i]] isEqualToString:@"onvan"])
            type=4;
    }
    return type ;
}




//===============================================================================



//etelaate kolie keteb mesle jadvale tbl_f_book_law ra dar dakhele database books mirizad
-(void)copy_book:(int )index
{
    
    NSString *name2=[NSString stringWithFormat:@"%@",[ids1l objectAtIndex:index]];
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:name2];
    NSArray *columns=[self.dbManager2 getColumn:[@"select * from tbl_f_book_law " UTF8String]];
    Boolean srt=false ;
    if([columns count]==5)
        srt=true ;
    
    NSString *query=@"select * from tbl_f_book_law";
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager2 loadDataFromDB:query]];
    
    //NSString *table=[[results objectAtIndex:0] objectAtIndex:[self.dbManager2.arrColumnNames indexOfObject:@"download"]  ];
    // NSString *table_link=[[[results objectAtIndex:0] objectAtIndex:[self.dbManager2.arrColumnNames indexOfObject:@"download"]] intValue ];
    if([results count]>0)
    {
        
        
        NSString *sort=@"";
        NSString *table=[[results objectAtIndex:0] objectAtIndex:2];
        NSString *link=[[results objectAtIndex:0] objectAtIndex:3];
        NSString *id_book=[[results objectAtIndex:0] objectAtIndex:0];
        NSString *name=[[results objectAtIndex:0] objectAtIndex:1];
        
        query=[NSString stringWithFormat:@"select * from %@ LIMIT 1",table];
        NSArray *col=[self.dbManager2 getColumn:[query UTF8String]];
        
        if([col count]==0)
            return ;
        int type=[self GetType:col];
        
        
        if(srt)
            sort=[[results objectAtIndex:0] objectAtIndex:4];
        query=[NSString stringWithFormat:@"insert into tbl_f_book_law values ( '%@' , '%@' , '%@' ,'%@' ,'%d' )",id_book,name,table,link,type];
        if(srt)
            query=[NSString stringWithFormat:@"insert into tbl_f_book_law values ( '%@' , '%@' , '%@' ,'%@' , '%@' ,'%d' )",id_book,name,table,link,sort,type];
        [self.dbManager executeQuery:query];
        
        
        
        
        query=[NSString stringWithFormat:@"update books set copy=1 , upgrade=0 where id='%@' ",[ids1l objectAtIndex:index ] ];
        [self.dbManager executeQuery:query];
        
        
        
        
        
    }
    
    
    
    
    
}














//--------------------------------------------------------------------------









-(void)PostRequest {
    
    
    NSString* idxx = [@(idx1l) stringValue];
    NSString *temp=@"http://intelligent-book.ir/home/MobBoughtList?";
    NSString *temp2=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=",username, @"&pageidx=", idxx];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:temp3];
    
    
    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 10.0];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"content-type"];
    
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   
                                   NSLog(@"errrrrooooooor",error);
                                   [self  Error:@""];
                               } else {
                                   NSMutableDictionary  *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:NULL];
                                   
                                   
                                   
                                   
                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0  error:&error];
                                   NSString *msg1=[object objectForKey:@"Error"];
                                   NSString *msg=[NSString stringWithFormat:@"%@",msg1];
                                   if([msg isEqualToString:@"0"])
                                   {
                                       
                                       has_data1l=0;
                                       int i=0 ;
                                       NSArray *DataArray = ParsedData[@"Books"];
                                       for ( NSDictionary *temp in DataArray )
                                       {
                                           //if(i==10)
                                           
                                           if(false)
                                           {
                                               has_data1l=1;
                                           }
                                           else {
                                               NSString *tid=temp[@"Id"];
                                               NSString *tname=temp[@"Name"];
                                               NSString *ver=temp[@"NewVersion"];
                                               
                                               NSString *tmp= temp[@"UrlImage"];
                                               NSRange range = NSMakeRange(5,tmp.length - 5 );
                                               NSString *link = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir", [tmp substringWithRange:range]];
                                               
                                               //-------------------------------------------
                                               int tmp3=[tid intValue];
                                               Boolean exist=false;
                                               for(int j=0 ; j<[ids1l count];j++ )
                                               {
                                                   NSString *tmp1 = [NSString stringWithFormat:@"%@",[ids1l objectAtIndex:j ]];
                                                   //NSInteger tt=[ids1l objectAtIndex:j ];
                                                   int tmp2=[tmp1 intValue];
                                                   if(tmp2==tmp3)
                                                   {
                                                       exist=true;
                                                       break ;
                                                   }
                                                   
                                               }
                                               if(!exist)
                                               {
                                                   NSString *query = [NSString stringWithFormat:@"insert into books values( '%@' , '%@', '%@', '%@' , '%@', '%@', 0 , '%@', 0)",tid,tname,@"",link,@"0",@"0",ver];
                                                   [self.dbManager executeQuery:query];
                                                   if (self.dbManager.affectedRows != 0) {
                                                       NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                                                   }
                                                   [ids1l addObject:tid];
                                                   [show1l addObject:@"0"];
                                                   [show1l2 addObject:@"1"];
                                                   [name1l addObject:tname];
                                                   [pics1l addObject:link];
                                                   [versions addObject:temp[@"NewVersion"]];
                                                   
                                               }
                                               
                                               
                                               
                                           }
                                           
                                           
                                           
                                           
                                           
                                           i++ ;
                                           
                                       }
                                       
                                   }
                                   else
                                       [self Error:msg];
                                   
                                   [self PostRequest2];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [collectionView reloadData];
                                       collectionView.hidden=NO ;
                                       [hud hide:YES];
                                       [hud removeFromSuperview];
                                       hud=nil;
                                       [activityIndicator stopAnimating];
                                   });
                                   
                               }
                           }
     ];
}





// in tabe dar background run mishavad va baraie check kardane in ask k aya update jadidi vojod darad ya na agar vojod dasht flag upgrade dar database ra 1 mikonad
-(void)PostRequest2 {
    
    
    NSString* idxx = [@(idx1l) stringValue];
    NSString *temp=@"http://intelligent-book.ir/home/MobBoughtList?";
    NSString *temp2=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=",username, @"&pageidx=", idxx];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:temp3];
    
    
    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 10.0];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"content-type"];
    
    //// DEBUG FOR UPDATE BOOK
/*    NSString *debugMsg1 = [NSString stringWithFormat:@"Debug Message - 1\nSource: LibraryPage1.m\nMethod: PostRequest2\nURL = %@", temp2];
    NSString *utfString = [NSString
                           stringWithCString:[debugMsg1 cStringUsingEncoding:NSUTF8StringEncoding]
                           encoding:NSNonLossyASCIIStringEncoding];
    NSString *erl = [NSString stringWithFormat:@"http://192.95.10.103/bot/debug.php"];
    NSString *postString = [NSString stringWithFormat:@"msg=%@&user=%@&imei=%@&datetime=%@", utfString, imei, username, [NSDate date]] ;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:erl]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [req setValue: @"text/html; charset=utf-8" forHTTPHeaderField: @"content-type"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSLog(@"DebugMsg1 is sent!");
                           }];
*/
 //// DEBUG FOR UPDATE BOOK

    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   
                                   NSLog(@"errrrrooooooor: %@",error);
                                   
                               } else {
                                   NSMutableDictionary  *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:NULL];
                                   
                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0  error:&error];
                                   NSString *msg1=[object objectForKey:@"Error"];
                                   NSString *msg=[NSString stringWithFormat:@"%@",msg1];
                                   if([msg isEqualToString:@"0"])
                                   {
                                       
                                       has_data1l=0;
                                       int i=0 ;
                                       NSArray *DataArray = ParsedData[@"Books"];
                                       //// DEBUG FOR UPDATE BOOK
                                       /*NSString *debugMsg1 = [NSString stringWithFormat:@"Debug Message - 2\nSource: LibraryPage1.m\nMethod: PostRequest2\nDataArray = %@", DataArray.description];
                                       NSString *utfString = [NSString
                                                          stringWithCString:[debugMsg1 cStringUsingEncoding:NSUTF8StringEncoding]
                                                          encoding:NSNonLossyASCIIStringEncoding];
                                       NSString *erl = [NSString stringWithFormat:@"http://192.95.10.103/bot/debug.php"];
                                       NSString *postString = [NSString stringWithFormat:@"msg=%@&user=%@&imei=%@&datetime=%@", utfString, imei, username, [NSDate date]] ;
                                       NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:erl]];
                                       [req setHTTPMethod:@"POST"];
                                       [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
                                       [req setValue: @"text/html; charset=utf-8" forHTTPHeaderField: @"content-type"];
                                       [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new]
                                                              completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                                                  NSLog(@"DebugMsg1 is sent!");
                                       }];
                                       *///// DEBUG FOR UPDATE BOOK
                                       for ( NSDictionary *temp in DataArray )
                                       {
                                           //if(i==10)
                                           
                                           if(false)
                                           {
                                               has_data1l=1;
                                           } else {
                                               NSString *tid=temp[@"Id"];
                                               //-------------------------------------------
                                               int tmp3=[tid intValue];
                                               Boolean exist=false;
                                               for(int j=0 ; j<[ids1l count];j++ )
                                               {
                                                   NSString *tmp1 = [NSString stringWithFormat:@"%@",[ids1l objectAtIndex:j ]];
                                                   //NSInteger tt=[ids1l objectAtIndex:j ];
                                                   int tmp2=[tmp1 intValue];
                                                   if(tmp2==tmp3)
                                                   {
                                                       int newver=[temp[@"NewVersion"] intValue];
                                                       int oldver=[[versions objectAtIndex:j]intValue];
                                                       if([temp[@"NewVersion"]intValue]!=[[versions objectAtIndex:j]intValue])
                                                       {
                                                           //// DEBUG FOR UPDATE BOOK
                                                           /*NSString *debugMsg2 = [NSString stringWithFormat:@"Debug Message - 3\nSource: LibraryPage1.m\nMethod: PostRequest2\nNew Updated Book Found: %d\n,temp = %@",tmp2, data.description];
                                                           NSString *utfString = [NSString
                                                                                  stringWithCString:[debugMsg2 cStringUsingEncoding:NSUTF8StringEncoding]
                                                                                  encoding:NSNonLossyASCIIStringEncoding];
                                                           NSString *erl = [[NSString stringWithFormat:@"http://192.95.10.103/bot/debug.php?msg=%@&user=%@&imei=%@&datetime=%@", utfString, imei, username, [NSDate date]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                           NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:erl]];
                                                           [req setHTTPMethod:@"POST"];
                                                           [req setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"content-type"];
                                                           [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue new]
                                                                                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                                                                      NSLog(@"DebugMsg2 is sent!");
                                                                                  }];
                                                           *///// DEBUG FOR UPDATE BOOK
                                                           [versions replaceObjectAtIndex:j withObject:temp[@"NewVersion"]];
                                                           NSString *s=[NSString stringWithFormat: @"update books set upgrade=1 ver=%@ where id= %d ",temp[@"NewVersion"] ,tmp2];
                                                           [self.dbManager executeQuery:[NSString stringWithFormat: @"update books set upgrade=1 ,ver=%@ where id=%d ",temp[@"NewVersion"],tmp2 ]];
                                                       }
                                                       break ;
                                                   }
                                                   
                                               }
                                               
                                               
                                           }
                                           
                                           
                                           i++ ;
                                           
                                       }
                                       
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [collectionView reloadData];
                                           collectionView.hidden=NO ;
                                           [hud hide:YES];
                                           [hud removeFromSuperview];
                                           [activityIndicator stopAnimating];
                                       });
                                       
                                       
                                   }
                                   else
                                   {
                                   }
                                   //[self Error:msg];
                                   
                                   [self show_update_num];
                               }
                           }
     ];
}



// namaiesh tedad update haie mojod
-(void)show_update_num
{
    NSArray *num=[self.dbManager loadDataFromDB:@"select id from books where upgrade = 1 and copy =1  "];
    if([num count]==0)
    {
        self.red.hidden=YES;
        
    }
    else
    {
        self.red.hidden=NO;
        [self.red setTitle: [NSString stringWithFormat:@"%d",[num count]] forState: UIControlStateNormal];
    }
}



-(void)Error:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *message = error_str;
        
        
        if ([msg isEqualToString:@"103"]){
            message = @"نام کاربری نا معتبر میباشد";
        }
        else if ([msg isEqualToString:@"102"]){
            message = @"کاربری با این مشخصه وجود دارد اما ثبت نام نکرده";
        }
        else if ([msg isEqualToString:@"101"]){
            message = @"کاربر مسدود میباشد";
        }
        else if ([msg isEqualToString:@"100"]){
            message = @"کاربری با این کد مشخصه وجود ندارد . ابتدا کد مشخصه دریافت نمایید";
        }
        else if ([msg isEqualToString:@"105"]){
            
            message = @"نام کاربری تکراری میباشد";
        }
        else if ([msg isEqualToString:@"800"]){
            
            message = @"شما مجاز به دریافت این فایل نیستید";
        }
        
        
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
        [activityIndicator stopAnimating];
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        int duration = 2; // duration in seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
    
    
    
}




//-------------------------------------------- DataBase Function ------------------------------


// agar internet vasl nabashad list ketab ha ra az database mikhanad

-(void)GetFromDatabase:(NSString *)searchString
{
    NSString *query = [NSString stringWithFormat:@"select * from books "];
    if (searchString)
    {
        query = [query stringByAppendingFormat:@"where name like '%%%@%%'",searchString];
    }
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    for(int i=0;i<[results count] ; i++)
    {
        [ids1l addObject:[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"id"]]];
        [name1l addObject:[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]]];
        [pics1l addObject:[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"image_path"]]];
        [versions addObject:[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"ver"]]];
        
        int t=[[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"copy"]] intValue];
        if(t==1)
            [show1l2 addObject:@"0"];
        else
            [show1l2 addObject:@"1"];
        [show1l addObject:@"0"];
    }
    if (searchString)
        return;
    
    if([ids1l count]==0 && _from_shop!=2)
    {
        [self show_loading];
        [self PostRequest];
    }
    else
    {
        [self PostRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionView reloadData];
            collectionView.hidden=NO ;
            [hud hide:YES];
            [hud removeFromSuperview];
            hud=nil;
            [activityIndicator stopAnimating];
            error_enable=false ;
        });
    }
    
    
}



//----------------------------------------------------------
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint p = [gestureRecognizer locationInView:collectionView];
    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    }
    else
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            NSLog(@"long press on table view at row %ld", (long)indexPath.row);
            self.longPressActive = YES;
            
            [collectionView selectItemAtIndexPath:indexPath
                                         animated:NO
                                   scrollPosition:UICollectionViewScrollPositionNone];
            
            //-----------------------
            NSString *str1=@"ایا مایل به حذف کتاب ";
            NSString *str2=[NSString stringWithFormat:@"%@",[name1l objectAtIndex:indexPath.row ]];
            NSString *str3=@" هستید ؟";
            NSString *str=[NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
            _delete_index=indexPath.row;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"بله" otherButtonTitles:@"خیر", nil];
            [alert show];
            
            
            
            
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
                  gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
            self.longPressActive = NO;
        }
        
    }
    
}



// namaiesh hoshdare moqe hazf ketab
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    int delete_id=[[ids1l objectAtIndex:_delete_index ] intValue];
    if (buttonIndex == 0){
        
        if(_delete_index==dl_index && dl_running==true)
        {
            [_downloadTask cancel];
            dl_running=false;
            dl_index=-1;
        }
        
        [ids1l removeObjectAtIndex:_delete_index];
        [pics1l removeObjectAtIndex:_delete_index];
        [name1l removeObjectAtIndex:_delete_index];
        [show1l removeObjectAtIndex:_delete_index];
        [show1l2 removeObjectAtIndex:_delete_index];
        
        [versions removeObjectAtIndex:_delete_index];
        NSString *query=[NSString stringWithFormat:@"delete from books  where id='%d' ",delete_id ];
        [self.dbManager executeQuery:query];
        
        query=[NSString stringWithFormat:@"delete from tbl_f_book_law  where _id='%d' ",delete_id ];
        [self.dbManager executeQuery:query];
        
        [collectionView reloadData];
        
    }
    _delete_index=-1;
}




- (IBAction)refresh:(UIButton *)sender
{
    
    [self show_loading];
    [self PostRequest];
}


// raftan b qesmate alaqe mandi ha
- (IBAction)fav:(UIButton *)sender
{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    FavPage *page ;
    if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait )
    {
        page = [[FavPage alloc] initWithNibName:@"FavPage_Portrait" bundle:nil];
    }
    else
    {
        page = [[FavPage alloc] initWithNibName:@"FavPage_Landscape" bundle:nil];
    }
    
    
    
    
    
    [self.navigationController pushViewController:page animated:YES];
}




// raftan b qesmate update kotob
- (IBAction)update:(UIButton *)sender
{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UpdatePage1 *page ;
    if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait )
    {
        page = [[UpdatePage1 alloc] initWithNibName:@"UpdatePage1_Portrait" bundle:nil];
    }
    else
    {
        page = [[UpdatePage1 alloc] initWithNibName:@"UpdatePage1_Landscape" bundle:nil];
    }

    [self.navigationController pushViewController:page animated:YES];
}

- (void)configureView {
    
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&  [[UIApplication sharedApplication] statusBarOrientation] != UIDeviceOrientationPortrait)
    //    {
    //        for (UIButton *button in navButtons)
    //        {
    //            CGRect frame = button.frame;
    //            frame.size.width = 35;
    //            frame.size.height = 35;
    //            button.frame = frame;
    //        }
    //    }
    
}

- (IBAction)hidePane:(id)sender {
    if (self.hidden) // unhide the pane
    {
        CGFloat delay = 0;
        CGFloat x;
        
        [UIView animateWithDuration:0.7 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // resize title imageView
            UIView *view = [self.view viewWithTag:201];
            CGRect frame = view.frame;
            frame.size.width = self.view.bounds.size.width- (isiPad ? 387 : 197) - 21;
            view.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // resize tableView
            view = [self.view viewWithTag:202];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width - (isiPad ? 387 : 197) - 21;
            view.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            
            // move کتابخانه label back to place
            view = [self.view viewWithTag:203];
            frame = view.frame;
            frame.size.width = (isiPad ? 118 : 54);
            view.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // move pane to the right most point of self.view
            view = [self.view viewWithTag:204];
            frame = view.frame;
            frame.origin.x = self.view.bounds.size.width - (isiPad ? 387 : 197);
            view.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
        } completion:^(BOOL finished) {
        }];
        
        
        for (int i=101;i<=107;i++)
        {
            switch (i) {
                case 101:
                case 106:
                    x = self.view.bounds.size.width - (isiPad ? 300 : 157) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                case 102:
                case 104:
                    x = self.view.bounds.size.width - (isiPad ? 294 : 150) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                case 103:
                    x = self.view.bounds.size.width - (isiPad ? 292 : 148) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                case 105:
                    x = self.view.bounds.size.width - (isiPad ? 320 : 162) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                case 107:
                    x = self.view.bounds.size.width - (isiPad ? 320 : 166) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                default:
                    break;
            }
            
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            CGPoint center = button.center;
            center.x = x;
            [UIView animateWithDuration:0.7 delay:delay usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.center = center;
                [_frames1 setObject:[NSValue valueWithCGRect:button.frame] forKey:[NSNumber numberWithInteger:button.tag]];
                
            } completion:^(BOOL finished) {
                if (button.tag == 107) {
                    [button setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
                }
            }];
            delay += 0.05;
        }
        
    } else {        // hide the pange
        CGFloat delay = 0;
        
        for (int i=101;i<=107;i++)
        {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            CGPoint center = button.center;
            center.x = self.view.bounds.size.width - (isiPad ? 40 : 20);
            [UIView animateWithDuration:0.7 delay:delay usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.center = center;
                [_frames1 setObject:[NSValue valueWithCGRect:button.frame] forKey:[NSNumber numberWithInteger:button.tag]];
            } completion:^(BOOL finished) {
                
            }];
            delay += 0.05;
        }
        
        CGRect frame = _paneImageView.frame;
        frame.origin.x = self.view.bounds.size.width - (isiPad ? 30 : 15);
        [UIView animateWithDuration:0.7 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // move pane to the right most point of self.view
            _paneImageView.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:_paneImageView.tag]];
            
            // resize title imageView
            UIView *view = [self.view viewWithTag:201];
            CGRect frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 80 : 40);
            view.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // resize tableView
            view = [self.view viewWithTag:202];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 80 : 40);
            view.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // move کتابخانه label to right
            view = [self.view viewWithTag:203];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - 50; //40
            view.frame = frame;
            [_frames1 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
        } completion:^(BOOL finished) {
            [((UIButton *)[self.view viewWithTag:107]) setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        }];
    }
    self.hidden = !self.hidden;
}

- (void)animateSearchBar:(BOOL)hide {
    // change font size of searchbar
    /*
    CGRect frame = _searchField.frame;
    frame.size.height += 20;
    _searchField.frame = frame;
    NSArray *sub = [[_searchField subviews][0] subviews] ;
    NSLog(@"subs: %@", sub);
    UITextField *searchTextField = [sub objectAtIndex:1];
    frame = searchTextField.frame;
    frame.size.height += 20;
    searchTextField.frame = frame;
    [searchTextField setFont:[UIFont systemFontOfSize:24.0]];
     */
    if (hide) {
        [UIView animateWithDuration:0.2 animations:^{
            self.searchField.alpha = 1.0;
            CGRect frame = self.searchField.frame;
            frame.origin.y = [self.view viewWithTag:101].frame.origin.y+[self.view viewWithTag:101].frame.size.height;
            self.searchField.frame = frame;
            frame = collectionView.frame;
            frame.origin.y = self.searchField.frame.origin.y+self.searchField.frame.size.height;
            collectionView.frame = frame;
        } completion:nil];
    } else {    //show
        [UIView animateWithDuration:0.2 animations:^{
            self.searchField.alpha = 0.0;
            CGRect frame = self.searchField.frame;
            int pad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 20 : 0 );
            frame.origin.y = [self.view viewWithTag:101].frame.origin.y + pad;
            self.searchField.frame = frame;
            frame = collectionView.frame;
            frame.origin.y = self.searchField.frame.origin.y+self.searchField.frame.size.height;
            collectionView.frame = frame;
        } completion:^(BOOL finished){
            
        }];
    }
}



//------------------------------------------------------------




// motaleeie ketab

- (IBAction)read_book:(UIButton *)sender
{
    
    NSString *query = [NSString stringWithFormat:@"select type , name from tbl_f_book_law where _id='%@' ",[ids1l objectAtIndex:_temp_index]];
    NSArray *r=[self.dbManager loadDataFromDB:query];
    int type=[[[r objectAtIndex:0] objectAtIndex:0] intValue ];
    NSString *name=[[r objectAtIndex:0] objectAtIndex:1] ;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    LibraryPage2 *page ;
    
    
    if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait )
    {
        page = [[LibraryPage2 alloc] initWithNibName:@"LibraryPage2_Portrait" bundle:nil];
    }
    else
    {
        page = [[LibraryPage2 alloc] initWithNibName:@"LibraryPage2_Landscape" bundle:nil];
    }
    
    
    
    page.book_id=[[ids1l objectAtIndex:_temp_index] intValue];
    page.parent=(-1) ;
    page.type= type;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:name];
    page.hdr=attString;
    page.hidden = self.hidden;
    
    
    _temp_index=-1;
    _image_btn.hidden=YES;
    
    [self.navigationController pushViewController:page animated:YES];
    
}


//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************


- (IBAction)back:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES ];
}
- (IBAction)home:(UIButton *)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}







- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self show_update_num ];
    [self updateLayoutForNewOrientation: self.interfaceOrientation];
    
}

// view ra hengame charkhesh update mikonad
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateLayoutForNewOrientation: toInterfaceOrientation];
}


- (NSString*) nibNameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSString *postfix = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? @"Landscape" : @"Portrait";
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), postfix];
}

/* avaz kardane view be landscape ya portrait----tanzimati k bad az avaz kardane view baiad anjam  shavad ta vaziate
 qablie narm afzar hefz shavad mesle raftane tableview b makani k qablan bode ya set kardane matne  haie  k
 b sorate dynamic va dar ejraie app baiad set shavad va ... */

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation {
    
    
    NSArray *visible = [collectionView indexPathsForVisibleItems];
    
    NSIndexPath *indexpath;
    if([visible count]!=0)
        indexpath = (NSIndexPath*)[visible objectAtIndex:0];
    _row_num =indexpath.row ;
    
    
    
    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCellLibrary" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellLibrary"];
    
    
    
    if (orientation == UIInterfaceOrientationPortrait)
    {
        self.searchField.alpha = 0.0;
        self.searchField.barTintColor = [UIColor brownColor];
        self.searchField.maskView.backgroundColor = [UIColor brownColor];
        
    } else {
        [self.searchField setShowsCancelButton:NO];
    }

    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [collectionView setBackgroundView:nil];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [collectionView reloadData];
        collectionView.hidden=NO ;
        [hud hide:YES];
        [hud removeFromSuperview];
        hud=nil;
        [activityIndicator stopAnimating];
    });
    
    
    [self show_update_num];
    if([visible count]!=0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionTop
                                       animated:YES];
    }
    _obj=[DataClass getInstance];
    [_obj.Request1 setDownloadProgressDelegate:self];
    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"]intValue];
    _actionbar.clipsToBounds = YES;
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_row_num!=0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_row_num inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionTop
                                       animated:NO];
    }
    
    
    // change the title of the Cancel button in searchBar to 'لغو'
    [self setSearchFieldCancelTextTo:@"لغو"];
    
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        self.searchField.showsCancelButton = NO;
    }
    
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (_frames1.count) {
                for (NSNumber *key in _frames1)
                {
                    CGRect frame = [[_frames1 objectForKey:key] CGRectValue];
                    NSInteger tag = [key integerValue];
                    UIView *view = [self.view viewWithTag:tag];
                    view.frame = frame;
                }
            } else {
                if (self.hidden) {
                    self.hidden = !self.hidden;
                    [self hidePane:self];
                }
            }
        });
    }
}


-(void)setSearchFieldCancelTextTo:(NSString *)cancelText
{
    UIButton *cancelButton;
    UIView *topView = self.searchField.subviews[0];
    for (UIView *view in topView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton *)view;
        }
    }
    if (cancelButton) {
        [cancelButton setTitle:cancelText forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor = [UIColor whiteColor];
    }
}

//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************





- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)dealloc
{
    [_obj.Request1 setDownloadProgressDelegate:nil];
}


// set kardane progressbar
- (void)setProgress:(float)progress
{
    NSLog(@"Progress… %f",progress);
    [dl_cell.labeledProgressView setProgress:progress animated:YES];
    int i=dl_cell.labeledProgressView.progress*100;
    dl_cell.labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d %%",i];
}


// tabe download ketab dar background
-(void)download_book:(NSString *) book_id
{
    _obj.Request1=nil;
    prog=0;
    dl_cell.labeledProgressView.hidden=NO;
    [show1l replaceObjectAtIndex:dl_index withObject:@"1"];
    NSString *temp=@"http://intelligent-book.ir/home/MobDownload?";
    NSString *temp2=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=",username, @"&Id=", book_id];
    
    
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:temp3];
    _obj.Request1 = [ASIHTTPRequest requestWithURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *downloadPath = [NSString stringWithFormat:@"/%@",book_id];;
    downloadPath=[NSString stringWithFormat:@"%@%@",documentsDirectory,downloadPath];
    NSString *tempPath = [NSString stringWithFormat:@"/%@%@",book_id,@".download"];
    tempPath=[NSString stringWithFormat:@"%@%@",documentsDirectory,tempPath];
    [_obj.Request1 setDownloadDestinationPath:downloadPath];
    [_obj.Request1 setTemporaryFileDownloadPath:tempPath];
    [_obj.Request1 setAllowResumeForFileDownloads:YES];
    //[self.Request setDelegate:self];
    [_obj.Request1 setDownloadProgressDelegate:self];
    [_obj.Request1 setShouldContinueWhenAppEntersBackground:YES];
    [_obj.Request1 setTimeOutSeconds:4.0];
    [_obj.Request1 setCompletionBlock:^{
        
        [dl_cell.labeledProgressView setProgress:prog animated:YES];
        prog=0;
        dl_running=false ;
        [show1l replaceObjectAtIndex:dl_index withObject:@"0"];
        dl_cell.labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d %%", 100];
        
        
        
        NSString *dbname=[NSString stringWithFormat:@"%@",[ids1l objectAtIndex:dl_index ]];
        self.dbManager3 = [[DBManager alloc] initWithDatabaseFilename:dbname];
        NSArray *columns=[self.dbManager3 getColumn:[@"select * from tbl_f_book_law " UTF8String]];
        
        if([columns count]!=0)
        {
            NSString *query = [NSString stringWithFormat:@"update books set path='%@', download='%@' where id=%@ ",@"?",@"1",[ids1l objectAtIndex:dl_index ]];
            [self.dbManager executeQuery:query];
            [self copy_book:dl_index];
            [show1l2 replaceObjectAtIndex:dl_index withObject:@"0"];
            
        }
        else
        {
            [self Error:@"800"];
        }
     
        
        
        dl_index=-1;
        [_obj.Request1 cancel];
        [_obj.Request1 clearDelegatesAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionView reloadData];
        });
        
        _obj.Request1=nil;
        
    }];
    
    
    
    
    [_obj.Request1 setFailedBlock:^{
        
        NSError *error = [_obj.Request1 error];
        if(error)
        {
            
            if(_is_cancell!=true)
                [self Error:@""];
            _is_cancell!=false;
            
        }
        
        [show1l replaceObjectAtIndex:dl_index withObject:@"0"];
        dl_index=-1;
        prog=0;
        dl_running=false ;
        [collectionView reloadData];
        [_obj.Request1 cancel];
        [_obj.Request1 clearDelegatesAndCancel];
        _obj.Request1=nil;
        NSLog(@"%@",error);
        
    }];
    
    
    [_obj.Request1 startAsynchronous];
    NSString *theContent = [NSString stringWithContentsOfFile:downloadPath];
}
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************




@end
