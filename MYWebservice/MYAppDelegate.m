//
//  MYAppDelegate.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYAppDelegate.h"

#import "MYMasterViewController.h"
#import "MYImporter.h"
#import "PersistentStack.h"
#import "iTunesWebservice.h"
#import "SongListViewController.h"

@interface MYAppDelegate ()

@property (nonatomic, strong) MYImporter *importer;
@property (nonatomic, strong) SongListViewController *listViewController;

@end


@implementation MYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.webservice = [[iTunesWebservice alloc] init];
    self.importer = [[MYImporter alloc] initWithParentContext:self.persistentStack.managedObjectContext
                                             webservice:self.webservice];
    
    [self.importer import];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.listViewController  = [[SongListViewController alloc] initWithFrame:self.window.bounds
                                                                     andContext:self.persistentStack.backgroundManagedObjectContext];
    self.listViewController.managedObjectContext = self.persistentStack.managedObjectContext;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.listViewController];
    self.window.rootViewController = navigationController;
    
   [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext {
    [self.persistentStack saveContexts];
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
