//
//  SSMasterViewController.m
//  SplitPeekViewController
//
//  Created by Stevenson on 1/31/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SplitViewController.h"
#import "BackViewController.h"
#import "FrontViewController.h"

#define Menu_Offset 40.f
#define MAX_OPEN_SPACE 256.f

@interface SplitViewController () <UIGestureRecognizerDelegate>

@end

@implementation SplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //setup navigation controller pointers
    [self setupSubNavControllers];
    
    //set the current relationship cover
    self.menuStateInView = MenuCompletelyHidden;
    
}

-(void) setupSubNavControllers {
    self.backViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"back"];
    [self.view addSubview:self.backViewController.view];
    [self addChildViewController:self.backViewController];
    [self.backViewController didMoveToParentViewController:self];
    
    self.frontViewController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"front"];
    [self.view addSubview:self.frontViewController.view];
    [self addChildViewController:self.frontViewController];
    [self.frontViewController didMoveToParentViewController:self];
    
    FrontViewController *frontVC = (FrontViewController*)[[self.frontViewController viewControllers] firstObject];
    BackViewController *backVC = (BackViewController*)[[self.backViewController viewControllers] firstObject];
    [backVC setFrontViewController:frontVC];
    
    self.frontViewController.navigationController.navigationBar.hidden = NO;
    
    [self addChildViewController:self.frontViewController];
    [self.frontViewController didMoveToParentViewController:self];
    
    [self.frontViewController.view.layer setShadowOpacity:0.8f];
    [self.frontViewController.view.layer setShadowOffset:CGSizeMake(-1,0)];
}

#pragma mark - top view controller motions from menu
-(void)showMenuFullScreen {
    CGRect newFrontFrame = self.frontViewController.view.frame;
    newFrontFrame.origin.x = CGRectGetWidth(self.frontViewController.view.frame);
    newFrontFrame.origin.y = 0.f;
    [UIView animateWithDuration:.4f animations:^{
        self.frontViewController.view.frame= newFrontFrame;
        self.backViewController.view.frame = [self getBackViewRectOpen];
    }];
    self.menuStateInView = MenuCompletelyOpened;
}

-(void)showMenuSplit {
    CGRect newFrontFrame = self.frontViewController.view.frame;
    CGFloat newXOrigin = CGRectGetWidth(self.frontViewController.view.frame)-(.2*CGRectGetWidth(self.frontViewController.view.frame));
    if (newXOrigin > MAX_OPEN_SPACE) {
        newXOrigin = MAX_OPEN_SPACE;
    }
    newFrontFrame.origin.x = newXOrigin;
    newFrontFrame.origin.y = 0.f;
    
    //replacing built-in UIView Animation
//    [UIView animateWithDuration:.4f animations:^{
//        self.frontViewController.view.frame= newFrontFrame;
//        self.backViewController.view.frame = [self getBackViewRectOpen];
//    }];
    
    CABasicAnimation *frontPosAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    
    CGPoint newPosition = self.frontViewController.view.layer.position;
    newPosition.x = newXOrigin+CGRectGetWidth(self.frontViewController.view.frame)/2;
    
    frontPosAnim.fromValue = [NSValue valueWithCGPoint:self.frontViewController.view.layer.position ];
    frontPosAnim.toValue = [NSValue valueWithCGPoint:newPosition];
    frontPosAnim.duration = .4f;
    frontPosAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *backPosAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    
    CGPoint newPositionBack = self.frontViewController.view.layer.position;
    newPosition.x = 0.f;
    
    backPosAnim.fromValue = [NSValue valueWithCGPoint:self.frontViewController.view.layer.position ];
    backPosAnim.toValue = [NSValue valueWithCGPoint:newPositionBack];
    backPosAnim.duration = .4f;
    backPosAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @0.75; // Your from value (not obvious from the question)
    scale.toValue = @1.0;
    scale.duration = 0.4;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.backViewController.view.layer addAnimation:scale forKey:@"move forward by scaling"];
    [self.frontViewController.view.layer addAnimation:frontPosAnim forKey:@"position"];
    [self.backViewController.view.layer addAnimation:backPosAnim forKey:@"position"];
    
    // Set end value (animation won't apply the value to the model)
    self.backViewController.view.transform = CGAffineTransformIdentity;
    self.frontViewController.view.frame= newFrontFrame;
    self.backViewController.view.frame = [self getBackViewRectOpen];
    self.menuStateInView = MenuOpened;
}

-(void)hideMenu {
    CGRect newFrontFrame = self.frontViewController.view.frame;
    newFrontFrame.origin.x = 0.f;
    newFrontFrame.origin.y = 0.f;
    [UIView animateWithDuration:.4f animations:^{
        self.frontViewController.view.frame= newFrontFrame;
        self.backViewController.view.frame = [self getBackViewRectOrigin];
    }];
    self.menuStateInView = MenuCompletelyHidden;
}


-(CGRect) getBackViewRectOrigin {
    CGRect backFrame = self.backViewController.view.frame;
    backFrame.origin.x = -Menu_Offset;
    return backFrame;
}

-(CGRect) getBackViewRectOpen {
    CGRect backFrame = self.backViewController.view.frame;
    backFrame.origin.x = 0.f;
    return backFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
