//
//  AppDelegate.m
//  TwitterArt
//
//  Created by Milo Gosnell on 8/10/14.
//  Copyright (c) 2014 Milo Gosnell. All rights reserved.
//

#import "AppDelegate.h"

#define nbits(b, p, n) ((b) >> (p)) & ((1UL << (n)) - 1)

@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end

@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    
    [attrString endEditing];
    
    return attrString;
}
@end

@implementation AppDelegate {
    NSFont *textFieldFont;
    CGImageRef generatedImage;
}

@synthesize imageView, customTweetField, screenNameField, screenTweet, segment, progressView, timeLabel, artTypeButton, artUsedText, entropyText, fileTypeView, fileTypeButton;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    customTweetField.delegate = self;
    customTweetField.tag = 1001;
    screenNameField.delegate = self;
    screenNameField.tag = 1000;
    [screenNameField becomeFirstResponder];
    
    textFieldFont = screenTweet.font;
    
    [artTypeButton removeAllItems];
    [artTypeButton addItemsWithTitles:EquationNames];
    [artTypeButton addItemWithTitle:@"Random"];
    [artTypeButton selectItemAtIndex:1];
    
    segment.segmentStyle = NSSegmentStyleTexturedRounded;
    
    
}

- (IBAction)generateArt:(id)sender {
    
    switch (segment.selectedSegment) {
        case 0: {
            dispatch_async(dispatch_queue_create("s", 0), ^{
                [progressView setIndeterminate:YES];
                [progressView startAnimation:progressView];
                
                NSString *tweet = [TwitterTweets getMostRecentTweet:[screenNameField stringValue]];
                
                [progressView stopAnimation:progressView];
                [progressView setIndeterminate:NO];
                
                if ([tweet isEqualToString:@""]) {
                    NSAlert *a = [NSAlert alertWithMessageText:@"I couldn't find a tweet!" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"This is probably because the user doesn't exist, they're tweets are hidden, or they don't have any tweets at all. Make sure you've typed a screen name and please try again or use a custom tweet."];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [a runModal];
                    });
                } else {
                    NSArray *URLS = [TwitterTweets getURLPartsOfTweet:tweet];
                    
                    screenTweet.font = textFieldFont;
                    
                    if (URLS.count != 0) {
                        screenTweet.allowsEditingTextAttributes = YES;
                        [screenTweet setSelectable:YES];
                    } else {
                        screenTweet.allowsEditingTextAttributes = NO;
                        [screenTweet setSelectable:NO];
                    }
                    
                    NSMutableAttributedString *finalTweet = [[NSMutableAttributedString alloc] initWithString:tweet];
                    
                    for (NSString *URL in URLS) {
                        NSRange URLRange = [tweet rangeOfString:URL];
                        NSAttributedString *URLAttrStr = [NSAttributedString hyperlinkFromString:URL withURL:[NSURL URLWithString:URL]];
                        
                        [finalTweet beginEditing];
                        [finalTweet replaceCharactersInRange:URLRange withAttributedString:URLAttrStr];
                        [finalTweet endEditing];
                    }
                    [screenTweet setAttributedStringValue:finalTweet];
                    [self drawArt:finalTweet.string];
                }
            });
            break;
        }
        case 1: {
            
            NSString *tweet = customTweetField.stringValue;
            
            if ([tweet isEqualToString:@""]) {
                NSAlert *a = [NSAlert alertWithMessageText:@"No tweet entered!" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please enter a tweet in the box or use a screen name."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [a runModal];
                });
            } else {
                [self drawArt:tweet];
            }
            
            break;
        }
        default:
            break;
    }
    
}

-(void)drawArt:(NSString *)tweet {
    
    int entropy = [self entropyForTweet:tweet];
    
    int selected = (int)[artTypeButton indexOfSelectedItem];
    int eqtn;

    if (selected == EquationNames.count) eqtn = arc4random_uniform(NumberOfEquations) + 1;
    else eqtn = selected + 1;
    
    NSString *artStr = [artTypeButton itemTitleAtIndex:eqtn-1];
    
    dispatch_async(dispatch_queue_create("d", 0), ^{
        NSDate *d = [NSDate date];
        dispatch_async(dispatch_get_main_queue(), ^{
           timeLabel.stringValue = @"Generating...";
        });
        [self createImage:entropy equation:eqtn];
        dispatch_async(dispatch_get_main_queue(), ^{
            timeLabel.stringValue = [NSString stringWithFormat:@"Generation took %.2g seconds", -[d timeIntervalSinceNow]];
            artUsedText.stringValue = artStr;
            entropyText.stringValue = [NSString stringWithFormat:@"%d", entropy];
        });
    });
}

-(IBAction)switchType:(id)sender {
    
    NSSegmentedControl *control = (NSSegmentedControl *)sender;
    
    if (control.selectedSegment == 0) {
        [screenNameField becomeFirstResponder];
    } else {
        [customTweetField becomeFirstResponder];
    }
}

-(void)controlTextDidChange:(NSNotification *)obj {
    NSTextView *textField = obj.userInfo[@"NSFieldEditor"];
    int y = (int)[textField frame].size.height;
    
    if (y == 19) {
        segment.selectedSegment = 0;
    } else {
        segment.selectedSegment = 1;
        
        if ([textField string].length > 140) {
            [textField setString:[[textField string] substringWithRange:NSMakeRange(0, 140)]];
        }
    }
}

- (IBAction)backClicked:(id)sender {
    [self.window makeFirstResponder:nil];
}


-(void)createImage:(int)entropy equation:(int)eqtn {
    
    ArtEquations *eq = [[ArtEquations alloc] init];
    
    SEL redSel, greenSel, blueSel;
    
    redSel   = NSSelectorFromString([NSString stringWithFormat:@"r%dWithEntropy:column:row:", eqtn]);
    greenSel = NSSelectorFromString([NSString stringWithFormat:@"g%dWithEntropy:column:row:", eqtn]);
    blueSel  = NSSelectorFromString([NSString stringWithFormat:@"b%dWithEntropy:column:row:", eqtn]);
    
    NSInvocation      *rinv, *ginv, *binv;
    NSMethodSignature *rMethSig, *gMethSig, *bMethSig;
    
    rMethSig = [eq methodSignatureForSelector:redSel];
    gMethSig = [eq methodSignatureForSelector:greenSel];
    bMethSig = [eq methodSignatureForSelector:blueSel];
    
    rinv = [NSInvocation invocationWithMethodSignature:rMethSig];
    ginv = [NSInvocation invocationWithMethodSignature:gMethSig];
    binv = [NSInvocation invocationWithMethodSignature:bMethSig];
    
    [rinv setTarget:eq];
    [ginv setTarget:eq];
    [binv setTarget:eq];
    
    [rinv setSelector:redSel];
    [ginv setSelector:greenSel];
    [binv setSelector:blueSel];
    
    int width = 1024;
    int height = 1024;
    
    int incr = (width * height) / 100;
    
    unsigned char *rgba = (unsigned char *)malloc(width * height * 4);
    int offset = 0;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            
            unsigned char r, g, b;
            [rinv setArgument:&entropy atIndex:2];
            [rinv setArgument:&i atIndex:4];
            [rinv setArgument:&j atIndex:3];
            
            [ginv setArgument:&entropy atIndex:2];
            [ginv setArgument:&i atIndex:4];
            [ginv setArgument:&j atIndex:3];
            
            [binv setArgument:&entropy atIndex:2];
            [binv setArgument:&i atIndex:4];
            [binv setArgument:&j atIndex:3];
            
            [rinv invoke];
            [rinv getReturnValue:&r];
            
            [ginv invoke];
            [ginv getReturnValue:&g];
            
            [binv invoke];
            [binv getReturnValue:&b];
            
            rgba[4 * offset]     = r&255;
            rgba[4 * offset + 1] = g&255;
            rgba[4 * offset + 2] = b&255;
            rgba[4 * offset + 3] = 255;
            offset++;
            
            if (offset % incr == 0) {
                progressView.doubleValue = (float)offset/(width * height) * 100;
            }
        }
    }
    
    [progressView setDoubleValue:100.0];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(rgba, width, height, 8, 4 * width, colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CFRelease(colorSpace);
    generatedImage = CGBitmapContextCreateImage(bitmapContext);
    NSImage *image = [[NSImage alloc] initWithCGImage:generatedImage size:NSSizeFromCGSize(CGSizeMake(width, height))];
    
    imageView.image = image;
}

-(int)entropyForTweet:(NSString *)tweet {
    
    int numOfChars = (int)tweet.length;
    
    int sumOfChars = 0;
    
    for (int i = 0; i < numOfChars; i++) sumOfChars += (char)[tweet characterAtIndex:i];
    
    NSString *hashStr = [tweet hashedString];
    
    int numOfHashChars = (int)hashStr.length;
    
    int sumOfHashChars = 0;
    
    for (int i = 0; i < numOfHashChars; i++) {
        sumOfHashChars += (char)[hashStr characterAtIndex:i];
    }
    
    srand(sumOfHashChars);
    
    int randFromHash = rand() % numOfHashChars;
    
    srand(randFromHash);
    
    int randFromRand = rand() % numOfChars;
    
    srand(randFromRand + sumOfHashChars + sumOfChars);
    
    int totalRand = rand() % 1024;
    
    return totalRand;
}


- (IBAction)saveArt:(id)sender {
    
    if (!generatedImage) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"No Image" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"You have to generate an image first by clicking \"Generate\"."];
        [alert runModal];
        return;
    }
    
    [fileTypeButton removeAllItems];
    [fileTypeButton addItemsWithTitles:@[@"PNG", @"BMP"]];
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    [savePanel setMessage:@"Do not add a file extension. It will be automatically added for you."];
    
    [savePanel setAllowsOtherFileTypes:NO];
    [savePanel setAccessoryView:fileTypeView];
    [savePanel setDirectoryURL:[NSURL URLWithString:NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0]]];
    
    [savePanel setNameFieldLabel:@"Name:"];
    [savePanel setNameFieldStringValue:@"Image"];
    
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSURL *url = savePanel.URL;
            NSString *filePath = url.path;
            
            filePath = [filePath stringByReplacingOccurrencesOfString:@".png" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, filePath.length)];
            filePath = [filePath stringByReplacingOccurrencesOfString:@".bmp" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, filePath.length)];
            
            filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@".%@", [fileTypeButton.titleOfSelectedItem lowercaseString]]];
            CFURLRef pathURL = (__bridge CFURLRef)[NSURL fileURLWithPath:filePath];
            CGImageDestinationRef imgDest = CGImageDestinationCreateWithURL(pathURL, fileTypeButton.indexOfSelectedItem == 0 ? kUTTypePNG : kUTTypeBMP, 1, NULL);
            CGImageDestinationAddImage(imgDest, generatedImage, nil);
            
            if (!CGImageDestinationFinalize(imgDest)) {
                NSLog(@"Failed to write to path %@", filePath);
            }
            CFRelease(imgDest);
        }
    }];
    
     
}

@end



