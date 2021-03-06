//
//  ViewController.m
//  Experimenter
//
//  Created by Phil Curry on 11/28/15.
//  Copyright © 2015 Otaku Studio. All rights reserved.
//

#import "ViewController.h"
#import "HangarViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView*   testView;
@property (nonatomic, weak) IBOutlet UIButton* testButton1;
@property (nonatomic, weak) IBOutlet UIButton* testButton2;
@property (nonatomic, weak) IBOutlet UIButton* testButton3;
@property (nonatomic, weak) IBOutlet UIButton* testButton4;
@property (nonatomic, weak) IBOutlet UIButton* testButton5;

@property (nonatomic, assign) BOOL  testViewIsOpen;
@property (nonatomic, assign) float screenWidth;
@property (nonatomic, assign) float screenHeight;

@property (nonatomic, strong) NSArray* tabs;
@property (nonatomic, strong) UIView * currentContent;

@end

@implementation ViewController

- (void)viewDidLoad
{
   [super viewDidLoad];

   [self addNewTabs];
   self.testViewIsOpen = NO;
   
   _screenWidth  = UIScreen.mainScreen.bounds.size.width;
   _screenHeight = UIScreen.mainScreen.bounds.size.height;
   
   self.tabs = @[_testButton1, _testButton2, _testButton3, _testButton4, _testButton5];
}

#define TAB_HEIGHT 35

- (void)handleNewTap:(UIGestureRecognizer*)sender
{
   UIButton* selectedTab = (UIButton*)sender.view;

   if (_testViewIsOpen) {
      [self closeView:selectedTab];
   }
   else {
      [self exposeView:selectedTab];
   }
   
   _testViewIsOpen = !_testViewIsOpen;
}

- (void)exposeView:(UIButton*)selectedTab
{
   CGRect showButtonFrame   = selectedTab.frame;
   showButtonFrame.origin.x = _screenWidth;

   CGRect newViewFrame      = _testView.frame;
   newViewFrame.size.width  = _screenWidth - (TAB_HEIGHT - 1);// off by 1 px because my drawing is off
   newViewFrame.size.height = _screenHeight;
   
   [self configureViewForTab:selectedTab];

   [UIView animateWithDuration:0.4
                         delay:0.0
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                       selectedTab.frame   = showButtonFrame;
                       self.testView.frame = newViewFrame;
                       
                       for (UIButton* b in _tabs) {
                          if (b != selectedTab) {
                             CGRect hideButtonFrame;
                             hideButtonFrame          = b.frame;
                             hideButtonFrame.origin.x = -TAB_HEIGHT;
                             
                             b.enabled = NO;
                             b.frame   = hideButtonFrame;
                          }
                       }
                       self.currentContent.alpha = 1.0;
                    }
                    completion:^(BOOL finished){
                    }];
}

- (void)closeView:(UIButton*)selectedTab
{
   CGRect newViewFrame      = _testView.frame;
   newViewFrame.size.width  = 0.0;

   CGRect showButtonFrame   = selectedTab.frame;
   showButtonFrame.origin.x = TAB_HEIGHT;
   
   for (UIButton* b in _tabs) {
      CGRect newButtonFrame   = b.frame;
      newButtonFrame.origin.x = TAB_HEIGHT;
      
      b.enabled = YES;
      
      [UIView animateWithDuration:0.4
                            delay:0.0
                          options:UIViewAnimationOptionCurveEaseInOut
                       animations:^(void) {
                          _testView.frame       = newViewFrame;
                          _currentContent.frame = newViewFrame;
                          selectedTab.frame     = showButtonFrame;

                          if (b != selectedTab) {
                             b.frame = newButtonFrame;
                          }
                          self.currentContent.alpha = 0.0;
                       }
                       completion:^(BOOL finished){
                          [self.currentContent removeFromSuperview];
                       }];
   }
}

- (void)addNewTabs
{
   NSArray* tabs = @[self.testButton1, self.testButton2, self.testButton3, self.testButton4, self.testButton5];
   
   for (UIButton* b in tabs) {
      b.transform = CGAffineTransformMakeRotation(M_PI_2);
      b.layer.anchorPoint = CGPointMake(0, 0);
   }
   
   UITapGestureRecognizer* tgr1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(handleNewTap:)];
   [self.testButton1 addGestureRecognizer:tgr1];
   [self.testButton1 setTitle:@"Tab 1" forState:UIControlStateNormal];
   
   UITapGestureRecognizer* tgr2 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(handleNewTap:)];
   [self.testButton2 addGestureRecognizer:tgr2];
   [self.testButton2 setTitle:@"Tab 2" forState:UIControlStateNormal];
   
   UITapGestureRecognizer* tgr3 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(handleNewTap:)];
   [self.testButton3 addGestureRecognizer:tgr3];
   [self.testButton3 setTitle:@"Tab 3" forState:UIControlStateNormal];
   
   UITapGestureRecognizer* tgr4 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(handleNewTap:)];
   [self.testButton4 addGestureRecognizer:tgr4];
   [self.testButton4 setTitle:@"Tab 4" forState:UIControlStateNormal];
   
   UITapGestureRecognizer* tgr5 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(handleNewTap:)];
   [self.testButton5 addGestureRecognizer:tgr5];
   [self.testButton5 setTitle  :@"Tab 5" forState:UIControlStateNormal];
}

- (void)configureViewForTab:(UIButton*)selectedTab
{
   [self configureViewColor:selectedTab];

   HangarViewController* ha = [[HangarViewController alloc] initWithNibName:@"HangarViewController"
                                                                     bundle:nil];
   self.currentContent       = ha.view;
   self.currentContent.alpha = 0.0;

   [self.testView addSubview:self.currentContent];
}

- (void)configureViewColor:(UIButton*)selectedTab
{
   if (selectedTab == _testButton1) {
      _testView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];
   }
   else if (selectedTab == _testButton2) {
      _testView.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];
   }
   else if (selectedTab == _testButton3) {
      _testView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0 alpha:1];
   }
   else if (selectedTab == _testButton4) {
      _testView.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:1];
   }
   else if (selectedTab == _testButton5) {
      _testView.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1];
   }
}

@end
