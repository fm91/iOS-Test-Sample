//
//  AnimationSectionViewController.h
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationSectionViewController : UIViewController
-(void) initializeRotation: (double) speed :(NSNumber*) angle;
- (IBAction)spinButton:(id)sender;
- (IBAction)backAction:(id)sender;



@end
