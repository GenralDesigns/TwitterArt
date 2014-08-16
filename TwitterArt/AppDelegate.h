//
//  AppDelegate.h
//  TwitterArt
//
//  Created by Milo Gosnell on 8/10/14.
//  Copyright (c) 2014 Milo Gosnell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TwitterTweets.h"
#import "ArtEquations.h"
#import "NSString+Extensions.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate>
@property (strong) IBOutlet NSProgressIndicator *progressView;
@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSImageView *imageView;
@property (strong) IBOutlet NSTextField *screenNameField;
@property (strong) IBOutlet NSTextField *customTweetField;
- (IBAction)generateArt:(id)sender;
@property (strong) IBOutlet NSTextField *screenTweet;
- (IBAction)switchType:(id)sender;
@property (strong) IBOutlet NSSegmentedControl *segment;
- (IBAction)backClicked:(id)sender;
@property (strong) IBOutlet NSTextField *timeLabel;
@property (strong) IBOutlet NSPopUpButton *artTypeButton;
@property (strong) IBOutlet NSTextField *entropyText;
@property (strong) IBOutlet NSTextField *artUsedText;
- (IBAction)saveArt:(id)sender;
@property (strong) IBOutlet NSView *fileTypeView;
@property (strong) IBOutlet NSPopUpButton *fileTypeButton;



@end
