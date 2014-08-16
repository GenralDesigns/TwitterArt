//
//  ArtCreation.h
//  TwitterArt
//
//  Created by Milo Gosnell on 8/14/14.
//  Copyright (c) 2014 Milo Gosnell. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT int const NumberOfEquations;
FOUNDATION_EXPORT NSArray * const EquationNames;


@interface ArtEquations : NSObject

/*
 Add your equations here in the format of xyWithEntropy:column:row: where x = r,g,or b, and y = 1,2,3... etc, whatever equation it currently is. Entropy is the entropy or a random value assigned to the tweet in use. This can be used from your functions as e to add systemic randomness to your math. An example of this is by doing: e>100?sq(i):sq(j)
 
 So you have three equations total in the format of (for example):
 
 r1WithEntropy:column:row:
 g1WithEntropy:column:row:
 b1WithEntropy:column:row:
 
 r2WithEntropy:column:row:
 g2WithEntropy:column:row:
 g2WithEntropy:column:row:
 
 etc.
 Here is a template you can use. Just copy and paste:
 
-(unsigned char)<#rgb#><#number#>WithEntropy:(int)e column:(int)i row:(int)j;
 
 You also need to define how many equations there are so the generator knows what equations to use. Set this in the .mm implementation file.
 
*/

-(unsigned char)r1WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)g1WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)b1WithEntropy:(int)e column:(int)i row:(int)j;

-(unsigned char)r2WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)g2WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)b2WithEntropy:(int)e column:(int)i row:(int)j;

-(unsigned char)r3WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)g3WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)b3WithEntropy:(int)e column:(int)i row:(int)j;

-(unsigned char)r4WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)g4WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)b4WithEntropy:(int)e column:(int)i row:(int)j;

-(unsigned char)r5WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)g5WithEntropy:(int)e column:(int)i row:(int)j;
-(unsigned char)b5WithEntropy:(int)e column:(int)i row:(int)j;

@end
