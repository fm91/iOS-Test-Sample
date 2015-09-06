//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"

@interface AnimationSectionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation AnimationSectionViewController


int animationSpeed = 2; // initialization of the rotation speed
CABasicAnimation *fullSpinAnimation; //Core Animation object that we'll use later
NSNumber *currentAngle = 0; // a tracker of the rotation state of the imageview

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Buttons

- (IBAction)backAction:(id)sender
{
    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
    [self.navigationController pushViewController:mainMenuViewController animated:YES];
}

- (IBAction)spinButton:(id)sender {
    
    //first I'd like to save the current rotation angle of the imageview
    currentAngle = [self.logoImage.layer.presentationLayer valueForKeyPath:@"transform.rotation"];
    
    //just a display of that angle
    NSLog(@"%f", currentAngle.floatValue);
    
    
       if((currentAngle.floatValue) != 0.0f)
   {//if the imageview is rotating (forms an angle different than 360)
       
       animationSpeed++; //increase the rotation speed
       
   }else{
       //if the imageview is not rotating or it completed it's rotation
    
    animationSpeed = 2; //reset the rotation speed to the default one
      
   }
    
    [self initializeRotation: animationSpeed: currentAngle];  //initialize the method with the appropriate speed and angle

    //execute the animation
    [self.logoImage.layer addAnimation:fullSpinAnimation forKey:@"logoRotation"];
    
}

#pragma mark -
#pragma mark Initialize Animation

//this method sets up the animation with
-(void) initializeRotation: (double) speed :(NSNumber*) angle
{
    fullSpinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullSpinAnimation.fromValue = angle;
    fullSpinAnimation.toValue = [NSNumber numberWithFloat: (speed * M_PI)];
    fullSpinAnimation.duration = 8;
    fullSpinAnimation.repeatCount = 1;

}


#pragma mark -
#pragma mark Delegates Drag Logo

//Delegate handling when the UIImage is touched at first
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //create a touch sensor through which we can track what is touched
    UITouch *touch = [[event allTouches]anyObject];
    
    //if the UIImage is touched, move its center, simple idea, immediate results
    if([touch view] == self.logoImage)
    {
        //save the CGpoint coordinates of the touch pont. then move the center of the image to those coordinates
        CGPoint pt = [[touches anyObject] locationInView:self.view];
        self.logoImage.center = pt;
    }
    
}



//Delegate handling when the UIImage is touched and moving
- (void) touchesMoved:(NSSet *)touches withEvent: (UIEvent *)event
{
    //create a touch sensor through which we can track what is touched
    UITouch *touch = [[event allTouches]anyObject];
    
   //if the UIImage is touched, move its center, as the pointer keeps moving the image will follow
    if([touch view] == self.logoImage)
    {
         //save the CGpoint coordinates of the touch pont. then move the center of the image to those coordinates
        CGPoint pt = [[touches anyObject] locationInView:self.view];
        self.logoImage.center = pt;
        
    }
    
}


@end
