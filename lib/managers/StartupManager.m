//
//  StartupManager.m
//
//
//  Created by neil on 08/12/2009.
//  Copyright 2009 Buffer. All rights reserved.
//

#import "StartupManager.h"
#import "ConnectionValidator.h"
#import "UserSettingsManager.h"
#import "DataSourceManager.h"
#import "GlobalUtilities.h"
#import "StyleManager.h"
#import "Model.h"
#import	"AppConstants.h"
#import "ImageCache.h"
#import "StringManager.h"
#import "AppConfigManager.h"

@interface StartupManager(Private)

-(void)loadServices;
- (NSString*) bundleServicePath;
-(void)startupComplete;
-(void)startupFailed;
@end


@implementation StartupManager
@synthesize userSettings;
@synthesize networkAvailable;
@synthesize userState;
@synthesize delegate;
@synthesize error;


/***********************************************************/
// dealloc
/***********************************************************/
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    delegate = nil;
	
}



-(id)init{
	
	if (self = [super init]){
		
	}
	return self;
	
	
}

-(void)doStartupSequence{
	
	// load default settings
	[UserSettingsManager sharedInstance];
    
    
	AppConfigManager *ac=[AppConfigManager sharedInstance];
    ac.delegate=self;
	[ac initialise];
	if(error!=nil){
		[self startupFailed];
		return;
	}
	
	// load style manager
	StyleManager *sm=[StyleManager sharedInstance];
	sm.delegate=self;
	[sm initialise];
	if(error!=nil){
		[self startupFailed];
		return;
	}
	
	
	StringManager *stm=[StringManager sharedInstance];
	stm.delegate=self;
	[stm initialise];
	if(error!=nil){
		[self startupFailed];
		return;
	}
	
	// remove stale cached images
	ImageCache *imageCache=[ImageCache sharedInstance];
	[imageCache removeStaleFiles:TIME_WEEK];

	
	// load ds manager
	[DataSourceManager sharedInstance];
	
	if(error==nil)
        [self startupComplete];
	
}



//
/***********************************************
 * @description			Support for notification based callbacks from Startup items
 ***********************************************/
//
-(void)didReceiveNotification:(NSNotification*)notification{
	

	
}


//
/***********************************************
 * generic Startup delegate method, all startupable managers have this delegate method
 ***********************************************/
//
-(void)startupFailedWithError:(NSString*)errorString{
	error=errorString;
}


//
/***********************************************
 * @description			All start up items have completed, will call AppDelgate to continue startup
 ***********************************************/
//
-(void)startupComplete{
	
	if([delegate respondsToSelector:@selector(startupComplete)]){
		[delegate startupComplete];
	}
	
}

//
/***********************************************
 * @description			A startup up item failed, will call AppDelegate to alert
 ***********************************************/
//
-(void)startupFailed{
	
	if([delegate respondsToSelector:@selector(startupFailedWithError:)]){
		[delegate startupFailedWithError:error];
	}
	
}








@end
