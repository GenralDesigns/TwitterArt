//
//  TwitterTweets.m
//  TwitterArt
//
//  Created by Milo Gosnell on 8/13/14.
//  Copyright (c) 2014 Milo Gosnell. All rights reserved.
//

#import "TwitterTweets.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "NSString+Extensions.h"

@implementation TwitterTweets

NSString *nonce;
NSString *timestamp;

+(NSString *)getMostRecentTweet:(NSString *)screenName {
    NSMutableArray *parts = [self getTweetParts:screenName];
    NSString *tweet = [self parsedTweet:parts];
    
    return tweet;
}

+(NSString *)parsedTweet:(NSMutableArray *)parts {
    
    NSMutableString *str = [NSMutableString string];
    
    int idx = 0;
    
    for (int i = 0; i < parts.count; i++) {
        
        NSString *part = parts[i];
        part = [part stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        part = [part stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        part = [part stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        part = [part stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
        part = [part stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        part = [part stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        part = [part stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        part = [part stringByReplacingOccurrencesOfString:@"…" withString:@""];
        
        [str appendString:part];
        
        if (idx == 1) {
            [str appendString:@" "];
            idx = 0;
        }
        
        if ([part rangeOfString:@"@"].location != NSNotFound || [part rangeOfString:@"#"].location != NSNotFound) {
            idx = 1;
        }
    }
    
    return [str copy];
}

+(NSArray *)getURLPartsOfTweet:(NSString *)tweet {
    
    
    NSScanner *URLScanner = [[NSScanner alloc] initWithString:tweet];
    
    [URLScanner scanUpToString:@"http://" intoString:nil];
    
    if (!URLScanner.isAtEnd) {
        NSMutableArray *URLS = [@[] mutableCopy];
        while (!URLScanner.isAtEnd) {
            NSString *URL;
            [URLScanner scanUpToString:@" " intoString:&URL];
            [URLS addObject:URL];
            
            [URLScanner scanUpToString:@"http://" intoString:nil];
        }
        return [URLS copy];
    } else {
        return @[];
    }
}



+(NSMutableArray *)getTweetParts:(NSString *)screenName {
    screenName = [screenName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
    NSMutableURLRequest *authReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", screenName]]];
    [authReq setTimeoutInterval:15];
    NSData *d = [NSURLConnection sendSynchronousRequest:authReq returningResponse:nil error:nil];
    NSString *HTMLString = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    NSScanner *scanner = [NSScanner scannerWithString:HTMLString];
    
    [scanner scanUpToString:@"ProfileTweet-contents" intoString:nil];
    
    HTMLString = [HTMLString substringWithRange:NSMakeRange(scanner.scanLocation, HTMLString.length - scanner.scanLocation)];
    
    NSUInteger count = 0, length = [HTMLString length];
    NSRange range = NSMakeRange(0, length);
    NSRange firstRange;
    NSRange lastRange;
    while(range.location != NSNotFound)
    {
        range = [HTMLString rangeOfString:@"\n" options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
            if (count == 4) {
                firstRange = range;
            }
            if (count == 5) {
                lastRange = range;
                break;
            }
        }
    }
    
    if (firstRange.location < 10000000 && lastRange.location < 10000000) {
        
    
    NSString *finalString = [HTMLString substringWithRange:NSMakeRange(firstRange.location, lastRange.location - firstRange.location)];
    
    NSScanner *htmlScanner = [[NSScanner alloc] initWithString:finalString];
    
    [htmlScanner scanUpToString:@">" intoString:nil];
    htmlScanner.scanLocation += 1;
    
    NSMutableArray *parts = [@[] mutableCopy];
    
    while (!htmlScanner.isAtEnd) {
        
        NSString *part;
        [htmlScanner scanUpToString:@"<" intoString:&part];
        [htmlScanner scanUpToString:@">" intoString:nil];
        [htmlScanner scanUpToString:@">" intoString:nil];
        htmlScanner.scanLocation += 1;
        if (part) {
            [parts addObject:part];
        }
    }
        return parts;
    } else {
        return [@[] mutableCopy];
    }
}

@end
