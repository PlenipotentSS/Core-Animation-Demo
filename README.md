Core Animation Demo
===================

Demo showcasing the a more in-depth look into animations using basic Core Animation. Here we change the animation of a SplitPeekViewController from a simple translation slide for the back menu to multiple animations on the same layer. This can only be done deeper in Core Animation. 

We changed the following code: 

```
    [UIView animateWithDuration:.4f animations:^{
        self.frontViewController.view.frame= newFrontFrame;
        self.backViewController.view.frame = [self getBackViewRectOpen];
    }];
```

to: 

```
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
```
    
Now you may be seeing a few changes, but the biggest one is that we are outlining exactly the animations to occur, adding them to the layer and then finally setting the new value. This in essence is done in blocks via ```animateWithDuration:animations:completion```, but this is one of they few ways to add multiple transforms or animations on a single layer without canceling one of the animations.