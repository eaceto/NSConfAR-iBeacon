//
//  EALoginTableViewController.m
//  NSConfARG
//
//  Created by Kimi on 27/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import "EALoginTableViewController.h"
#import "EATwitterAccountTableViewCell.h"

@interface EALoginTableViewController ()
{
    ACAccountStore* accountStore;
    NSArray* accounts;
    BOOL didFinishedLoading;
    
    NSMutableDictionary* imageDic;
    NSCache* _usernameCache;
    NSCache* _imageCache;
    
    IBOutlet UIActivityIndicatorView* loadingView;
}
@end

@implementation EALoginTableViewController
@synthesize accountsTableView;
@dynamic delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    didFinishedLoading = NO;
    imageDic = [[NSMutableDictionary alloc] init];
    
    _usernameCache = [[NSCache alloc] init];
    _imageCache = [[NSCache alloc] init];
    
    [loadingView startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    accountStore = [[ACAccountStore alloc] init];    
    [self requestTwitterAccounts];
}

- (void)setDelegate:(id<EALoginProtocol>)aDelegate
{
    delegate = aDelegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Social
- (void)requestTwitterAccounts
{
    
    ACAccountType* accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError* error){
        if (granted == NO) {
            [self showPermissionDenied];
        }
        else if (error != nil) {
            [self showError:error];
        }
        else {
            accounts = [accountStore accountsWithAccountType:accountType];
            didFinishedLoading = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [accountsTableView reloadData];            
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [loadingView stopAnimating];
        });
    }];
}

- (void)showPermissionDenied
{
    [[[UIAlertView alloc]initWithTitle:@"NSConfARG" message:@"Por favor, habilite los permisos necesarios para que esta app pueda acceder a sus cuentas de Twitter." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)showError:(NSError*)error
{
    NSString* msg = [NSString stringWithFormat:@"Ups... ha ocurrido un error: %@",error == nil ?@"Error desconocido":[error localizedDescription]];
    
    [[[UIAlertView alloc]initWithTitle:@"NSConfARG" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark Table View Delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EATwitterAccountTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EATwitterAccountTableViewCell"];
    if (cell == nil) {
        cell = [(EATwitterAccountTableViewCell*)[EATwitterAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EATwitterAccountTableViewCell"];
    }
    
    ACAccount* account = [accounts objectAtIndex:indexPath.row];
    
    
    NSString* username = [account username];
    if ([username rangeOfString:@"@"].location == NSNotFound) username = [NSString stringWithFormat:@"@%@",[account username]];
    
    [[cell userNameLabel] setText:username];


    NSString* display_name = [_usernameCache objectForKey:username];
    
    if (display_name == nil) {
        SLRequest *fetchAdvancedUserProperties  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                     requestMethod:SLRequestMethodGET
                                                                               URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"]
                                                                        parameters:[NSDictionary dictionaryWithObjectsAndKeys:username, @"screen_name", nil]];
        
        [fetchAdvancedUserProperties setAccount:account];
        
        [fetchAdvancedUserProperties performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            if ([urlResponse statusCode] == 200) {
                NSError *error;
                id userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                if (userInfo != nil) {
                    [_usernameCache setObject:[userInfo valueForKey:@"name"] forKey:username];
                    
                    @try {
                        NSString* _profileImageURL = [userInfo valueForKey:@"profile_image_url_https"];
                        if (_profileImageURL) {
                            _profileImageURL = [_profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
                            
                            [imageDic setObject:_profileImageURL forKey:username];
                        }
                    }
                    @catch (NSException *exception) {
                        
                    }
                    @finally {
                        
                    }
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
                    dispatch_async(queue, ^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [accountsTableView reloadData];
                        });
                    });
                }
            }
        }];
    }
    
    NSString* _profileImageURL = [imageDic objectForKey:username];
    UIImage* _profileImage = [_imageCache objectForKey:username];
    
    if (_profileImage == nil && _profileImageURL != nil) {
        
        dispatch_queue_t imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        dispatch_async(imageQueue, ^{
            
            @try {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_profileImageURL]];
                UIImage* image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_imageCache setObject:image forKey:username];
                        [accountsTableView reloadData];
                    });
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        });
    }
    
    if (display_name == nil) {
        display_name = @"loading...";
    }
    [[cell displayNameLabel] setText:display_name];
    
    [cell setProfileImage:_profileImage];

    
    return cell;
}

#pragma mark Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (accounts == nil)  return 0;
    return [accounts count];
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (didFinishedLoading && (accounts == nil || [accounts count] == 0)) {
        return @"No hay cuentas de Twitter configuradas.";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACAccount* account = [accounts objectAtIndex:indexPath.row];
    
    NSString* username = [account username];
    if ([username rangeOfString:@"@"].location == NSNotFound) username = [NSString stringWithFormat:@"@%@",[account username]];
    
    NSString* display_name = [_usernameCache objectForKey:username];
    if (display_name == nil) display_name = username;
    
    [delegate didLoginWithUsername:username name:display_name account:account];

    [self dismissViewControllerAnimated:YES completion:^(){}];
}

@end
