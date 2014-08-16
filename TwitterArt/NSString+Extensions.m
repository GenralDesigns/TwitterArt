//
//  NSString+Extensions.m
//  TwitterArt
//
//  Created by Milo Gosnell on 8/13/14.
//  Copyright (c) 2014 Milo Gosnell. All rights reserved.
//

#import "NSString+Extensions.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (Extensions)

- (NSString *) URLEncodedString_ch {
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(NSString *)hashedString {
    
    const char *str = [self UTF8String];

    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (int)[self length], result);
    
    NSMutableString *resStr = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) [resStr appendFormat:@"%02X", result[i]];
    
    return resStr;
}

@end
