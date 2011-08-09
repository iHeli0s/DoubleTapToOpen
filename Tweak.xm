#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
BOOL jitter = NO;
BOOL allowLaunch;

@interface SBIcon : UIView {
}
-(void)launch;
@end
static SBIcon *lastTapIcon;
static NSTimeInterval lastTapTime;
%hook SBIcon
-(void)touchesBegan:(id)touches withEvent:(id)event {
if(!jitter) {
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

%orig;


}
else {


%orig;
}


}
-(void)setIsJittering:(BOOL)jittering {

if(jittering)
jitter = YES;
else 
jitter = NO;
%orig;

}

%end
%hook SBApplicationIcon
-(void)launch {

if(allowLaunch)
%orig;

}


%end
