//
//  TwitterTweets.h
//  TwitterArt
//
//  Created by Milo Gosnell on 8/13/14.
//  Copyright (c) 2014 Milo Gosnell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterTweets : NSObject

/**
* @discussion Gets the most recent tweet from the supplied user's timeline
* @param screenName The user of choice's screen name (e.g. @KimKardashian without the @@)
* @returns Returns the tweet in the form of an NSString
*/
+(NSString *)getMostRecentTweet:(NSString *)screenName;
+(NSArray *)getURLPartsOfTweet:(NSString *)tweet;
@end
