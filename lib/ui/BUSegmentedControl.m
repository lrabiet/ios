//
//  CustomSegmentedControl.m
//
//
//  Created by Neil Edwards on 27/11/2009.
//  Copyright 2009 Buffer. All rights reserved.
//	custom segmented control to support image swapping for more flexible selected styles

#import "BUSegmentedControl.h"
#import "StyleManager.h"
#import "LayoutBox.h"
#import "GlobalUtilities.h"

@implementation BUSegmentedControl
@synthesize dataProvider;
@synthesize items;
@synthesize container;
@synthesize width;
@synthesize height;
@synthesize invertHighlightTextcolor;
@synthesize invertNormalTextcolor;
@synthesize selectedIndex;
@synthesize itemWidth;
@synthesize delegate;



- (id)init {
	
	if (self = [super init]) {
		
		//BetterLog(@"Setting init for segmented Control");
		
		self.backgroundColor=[UIColor clearColor];
		itemWidth=0;
        LayoutBox *lb=[[LayoutBox alloc]init];
		self.container=lb;
		container.itemPadding=0;
		selectedIndex=-1;
		width=0;
		invertHighlightTextcolor=NO;
		invertNormalTextcolor=NO;
		height=0;
		[self addSubview:container];    
	
	}
    return self;
}






-(void)buildInterface{
	
	UIButton *button=nil;
	
    NSMutableArray *arr=[[NSMutableArray alloc]init];
	self.items=arr;
	
	for (int i=0; i<[dataProvider count]; i++) {
		
		button=[UIButton buttonWithType:UIButtonTypeCustom];
		
		if(i==0){
			
			
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_left_lo"] stretchableImageWithLeftCapWidth:9 topCapHeight:0 ] forState:UIControlStateNormal];
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_left_hi"] stretchableImageWithLeftCapWidth:9 topCapHeight:0 ] forState:UIControlStateHighlighted];
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_left_hi"] stretchableImageWithLeftCapWidth:9 topCapHeight:0 ] forState:UIControlStateSelected];
			
		}else if (i==[dataProvider count]-1) {
			
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_right_lo"] stretchableImageWithLeftCapWidth:9 topCapHeight:0 ] forState:UIControlStateNormal];
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_right_hi"] stretchableImageWithLeftCapWidth:9 topCapHeight:0 ] forState:UIControlStateHighlighted];
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_right_hi"] stretchableImageWithLeftCapWidth:9 topCapHeight:0 ] forState:UIControlStateSelected];
			
			
		}else {
			
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_center_lo"] stretchableImageWithLeftCapWidth:4 topCapHeight:0 ] forState:UIControlStateNormal];
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_center_hi"] stretchableImageWithLeftCapWidth:4 topCapHeight:0 ] forState:UIControlStateHighlighted];
			[button setBackgroundImage:[[[StyleManager sharedInstance] imageForType:@"BUSegmentedControl_center_hi"] stretchableImageWithLeftCapWidth:4 topCapHeight:0 ] forState:UIControlStateSelected];
			
		}
		
		[button setTitle:[dataProvider objectAtIndex:i] forState:UIControlStateNormal];
		button.titleLabel.font=[UIFont boldSystemFontOfSize:11];
		button.backgroundColor=[UIColor clearColor];
		
		if(invertHighlightTextcolor==YES){
			[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
			[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
			[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
			[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
			button.reversesTitleShadowWhenHighlighted=YES;
		}
		
		if(invertNormalTextcolor==YES){
			[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
			[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
			[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
			[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
			button.titleLabel.shadowOffset=CGSizeMake(0, 1);
			button.reversesTitleShadowWhenHighlighted=YES;
		}else{
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
			button.titleLabel.shadowOffset=CGSizeMake(0, -1);
		}
		
		
	
		
		
		CGRect bframe=button.frame;
		
		if(itemWidth==0){
			bframe.size.width=[GlobalUtilities calculateWidthOfText:[dataProvider objectAtIndex:i] :[UIFont boldSystemFontOfSize:11]]+15;
		}else {
			bframe.size.width=itemWidth;
		}

		bframe.size.height=29.0f;
		button.frame=bframe;
		[button addTarget:self action:@selector(itemWasSelected:) forControlEvents:UIControlEventTouchDown];
		[button addTarget:self action:@selector(itemWasReleased:) forControlEvents:UIControlEventTouchUpInside];
		
		//
		width+=bframe.size.width;
		height=MAX(height,bframe.size.height);
		//
		[container addSubview:button];
		
		[items addObject:button];

		
	}
	
	// update container frames
	CGRect finalFrame=self.frame;
	finalFrame.size.width=width;
	finalFrame.size.height=height;
	container.frame=finalFrame;
	self.frame=finalFrame;
	//
	
	[self selectItemAtIndex:0];
		
}


-(void)setSelectedSegmentIndex:(int)index{
	
	if(index<[dataProvider count]){
		
		[self selectItemAtIndex:index];
		
	}
	
}

// Note: there can be an issie where the down executes while the item is selected, this causes a highlight flash (mainly this only occurs in the sim)
-(void)selectItemAtIndex:(int)index{
	
	if(selectedIndex!=index){
		
				
		if(selectedIndex!=-1){
			UIButton *outgoingbutton=[items objectAtIndex:selectedIndex];
			outgoingbutton.highlighted=NO;
			outgoingbutton.selected=NO;
			outgoingbutton.userInteractionEnabled=YES;
		
		}
		
		selectedIndex=index;
		
		UIButton *incomingbutton=[items objectAtIndex:selectedIndex];
		incomingbutton.highlighted=YES;
		
	}
	
}

-(IBAction)itemWasReleased:(id)sender{
	
	int index=[items indexOfObject:sender];
	
	UIButton *sbutton=[items objectAtIndex:index];
	if(sbutton.selected==NO){
		sbutton.selected=YES;
	}
	sbutton.userInteractionEnabled=NO;
	selectedIndex=index;
	
}


-(IBAction)itemWasSelected:(id)sender{
	
	int index=[items indexOfObject:sender];
		
	[self selectItemAtIndex:index];
	
	if([delegate respondsToSelector:@selector(selectedIndexDidChange:)]){
		[delegate selectedIndexDidChange:selectedIndex];
	}
	
}



-(void)removeSegmentAt:(int)index{
	
	if(index<[items count]){
	
		[items removeObjectAtIndex:index];
		[container removeSubviewAtIndex:index];
	
	}
	
}


-(void)addSegmentAt:(int)index{
	
	
	
	
}





- (void)drawRect:(CGRect)rect {
    // Drawing code
}





@end
