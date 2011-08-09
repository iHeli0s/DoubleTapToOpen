#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
BOOL jitter;
BOOL allowLaunch;
@class SBIconController;
@interface SBIcon : UIView {
}
+(id)sharedInstance;
-(void)launch;
@end
static SBIcon *lastTapIcon;
static NSTimeInterval lastTapTime;
%hook SBIcon
-(void)touchesBegan:(id)touches withEvent:(id)event {
%class SBIconController;
id controller = [$SBIconController sharedInstance];
jitter = [controller isEditing];
if(!jitter) 
{
UITouch *touch = [touches anyObject];
			NSTimeInterval currentTapTime = touch.timestamp;
			if ((currentTapTime - lastTapTime < 0.5) && (lastTapIcon == self)) {
			allowLaunch = YES;
			[self launch];
			
			
}
			allowLaunch = NO;
			[lastTapIcon autorelease];
			lastTapIcon = [self retain];
			lastTapTime = currentTapTime;
}
%orig;
			
}


%end
%hook SBApplicationIcon
-(void)launch {
if(allowLaunch)
%orig;

}


%end
