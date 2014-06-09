//
//  YMAppDelegate.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMAppDelegate.h"

#import "MYMasterViewController.h"
#import "YMImporter.h"
#import "YMPersistence.h"
#import "YMiTunesWebservice.h"
#import "YMSongListViewController.h"
#import "Reachability.h"

@interface YMAppDelegate ()

@property (nonatomic, strong) YMImporter *importer;
@property (nonatomic, strong) YMSongListViewController *listViewController;

@end


@implementation YMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No internet connection", nil)
                                                         message:NSLocalizedString(@"Internet connection not available.", nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }
    
    // Set up the Persistence stack as a singleton
    YMPersistence *stack = [[YMPersistence sharedInstance] initWithStoreURL:self.storeURL
                                                                   modelURL:self.modelURL];
    // Create iTunes Web service
    self.webservice = [[YMiTunesWebservice alloc] init];
   
    // Create itunes songs importer
    self.importer = [[YMImporter alloc] initWithParentContext:stack.managedObjectContext
                                             webservice:self.webservice];
    // Start import from iTunes
    [self.importer import];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // View controller to display the songs list
    self.listViewController  = [[YMSongListViewController alloc] initWithFrame:self.window.bounds
                                                                     andContext:stack.backgroundManagedObjectContext];
    // Pass the main context for UI
    self.listViewController.managedObjectContext = stack.managedObjectContext;
    
    // set the songs list view controller to be the root view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.listViewController];
    self.window.rootViewController = navigationController;
    
    
   [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [[YMPersistence sharedInstance] saveContexts];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[YMPersistence sharedInstance] saveContexts];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[YMPersistence sharedInstance] saveContexts];
}

- (NSURL*)storeURL {
    NSURL *documentsDirectory = [self applicationDocumentsDirectory];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL*)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"MYWebservice" withExtension:@"momd"];
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
