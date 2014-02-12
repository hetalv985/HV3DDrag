//
//  HVViewController.m
//  HV3DDrag
//
//  Created by Vora, Hetal on 2/6/14.
//  Copyright (c) 2014 Vora, Hetal. All rights reserved.
//

#import "HVViewController.h"

@interface HVViewController ()
//this will be our view to be dragged
@property (weak, nonatomic) IBOutlet UIView *dragView;
//height of the dragview to be used in the calculations
@property (nonatomic) CGFloat dragViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblArrow;

@end

@implementation HVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //position the dragview inclined at 90° along the X axis
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0/500;
    t = CATransform3DRotate(t, M_PI/2, 1.0, 0.0, 0.0);
    self.dragView.layer.transform = t;
    
    //add a pan gesture recognizer to the main view
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self.view addGestureRecognizer:recognizer];
    
    //get the value of the dragview height
    self.dragViewHeight = self.dragView.bounds.size.height;
    
    //add some shadow to the label displaying the arrow
    self.lblArrow.layer.shadowOpacity = 0.8;
    self.lblArrow.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.lblArrow.layer.masksToBounds = NO;;
    
}

-(void)panned:(UIPanGestureRecognizer*)recognizer{
    if(recognizer.state == UIGestureRecognizerStateChanged){
        //as the gesture recognizaer state changes, get the value of the total translation. we will only be using the y translation value.
        CGPoint currTranslation = [recognizer translationInView:self.view];
        int translationY = currTranslation.y;
        
        //animate the views based on the translation
        [self animateViewsForTranslation:translationY];
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        //when the gesture ends, adjust the views if they are not fully dragged down or not completely at the inital state
        if(self.view.frame.origin.y <= self.dragViewHeight/2){
            [self animateViewsForTranslation:-self.dragViewHeight];
        }
        else{
            [self animateViewsForTranslation:self.dragViewHeight];
        }
    }
}

-(void)animateViewsForTranslation:(int)translationY{
    CATransform3D t = CATransform3DIdentity;
    if(self.view.frame.origin.y<self.dragViewHeight && translationY>0.0){
        //panning downwards and the dragview hasn't been exposed completely yet, continue to translate down, but not beyond the point where the dragview is completely visible
        t = CATransform3DTranslate(t, 0.0, (translationY>self.dragViewHeight)?self.dragViewHeight:translationY, 0.0);
    }
    else{
        if(translationY < 0.0){
            //if we are panning upwards, translate upwards from the current position by translationY
            t = CATransform3DTranslate(t, 0.0, self.dragViewHeight+translationY, 0.0);
        }else{
            //we are continuing to pan downwards and the dragview is moved down beyond its height, reposition the view
            t = CATransform3DTranslate(t, 0.0, self.dragViewHeight, 0.0);
            return;
        }
    }
    //add the transform to our main view layer
    [self.view.layer setTransform:t];
    
    
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = -1.0/500;
    //set the anchorpoint as the bottom left corner
    self.dragView.layer.anchorPoint = CGPointMake(0.0, 1.0);
    CGFloat angle = 0.0;
    CGFloat adjustmentFactorForPanUp = self.dragViewHeight-180;
    
    if(translationY>=0.0){
        //if we are panning downwards, move the dragview from 90° to 0°, hence calculate the angle in radians by subtracting the translation in radians from pi/2
        angle =(M_PI_2-translationY*M_PI/180);
    }
    else if(translationY<=-90.0-adjustmentFactorForPanUp){
        //if we are panning downwards, we want the dragview to be back to 90° when the main view reaches back to y=0 i.e. when the translationY will be -(dragviewheight), we want the angle to equal 90°. Hence added the below calculation to calculate the appropriate angle to move.
        angle= (-translationY-90-adjustmentFactorForPanUp)*M_PI/180;
    }
    if((angle >= 0.0 && angle < M_PI/2)){
        t1 = CATransform3DRotate(t1, angle, 1.0, 0.0, 0.0);
        self.dragView.layer.position = CGPointMake(0.0, 0.0);
    }
    [self.dragView.layer setTransform:t1];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
