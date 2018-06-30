//
//  TrailerViewController.m
//  Flixster
//
//  Created by Keylonnie Miller on 6/29/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"


@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *trailerView;
@property (nonatomic, strong) NSArray *movieResults;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchTrailerURL];
}

- (void)fetchTrailerURL {
    
    NSString *startingURL = @"https://api.themoviedb.org/3/movie/";
    NSNumber *movieNumID = self.movie[@"id"];
    NSString *movieID = [NSString stringWithFormat:@"%@", movieNumID];
    NSString *endingURL = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    
    NSString *partTrailerURL = [startingURL stringByAppendingString:movieID];
    NSString *fullTrailerURL = [partTrailerURL stringByAppendingString:endingURL];
    
    NSURL *trailerURL = [NSURL URLWithString:fullTrailerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            //NSLog(@"%@", [error localizedDescription]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Trailer"
                                                                           message:@"The Internet connection appears to be offline."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movieResults = dataDictionary[@"results"];

            NSDictionary *movieTrailer = self.movieResults[0];
            //self.movieResults = self.movieResults;
            //NSLog(@"%@", movieTrailer);
            
            NSString *baseURL = @"https://www.youtube.com/watch?v=";
            NSString *trailerID = movieTrailer[@"key"];
            //NSString *trailerID = @"vn9mMeWcgoM";
            
            NSString *TrailerURL = [baseURL stringByAppendingString:trailerID];
            // As a property or local variable
            NSString *urlString = TrailerURL;
            // Convert the url String to a NSURL object.
            NSURL *url = [NSURL URLWithString:urlString];
            
            // Place the URL in a URL Request.
            NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10.0];
            // Load Request into WebView.
            [self.trailerView loadRequest:request];

        }
    }];
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIImageView *tappedImage = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = movie;
}
*/

@end
