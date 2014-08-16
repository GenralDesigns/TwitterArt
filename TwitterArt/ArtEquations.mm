//
//  ArtCreation.m
//  TwitterArt
//
//  Created by Milo Gosnell on 8/14/14.
//  Copyright (c) 2014 Milo Gosnell. All rights reserved.
//

#include <iostream>
#include <cmath>
#include <complex>
#define DIM 1024
#define DM1 (DIM-1)
#define _sq(x) ((x)*(x))                           // square
#define _cb(x) abs((x)*(x)*(x))                    // absolute value of cube
#define _cr(x) (unsigned char)(pow((x),1.0/3.0))   // cube root

using namespace::std;

#import "ArtEquations.h"

/* 
 Set the number of RGB equations here (not the total number of equations, i.e. the max number of the y part of the method name
 Also add the name of the equation to the array defined below. The format is @"equationName", for each equation name. Follow the format as defined below.
 
 This file is entirely C++ compatible so feel free to use any C++ code you want in the functions. This language is technically Objective-C++ which links with ObjC so I can use the method definitions below. This allows to call the methods dynamically by string which allows for randomness and easier integration with this Cocoa app.
 
 NOTE! This uses the LLVM 5.1 compiler. C++ compiles with the option -std=c++11
 
*/

int const NumberOfEquations = 5;
NSArray * const EquationNames = @[@"Unicorns - Martin Büttner", @"Tablecloth - githubphagocyte", @"Triangle Squares - Jugale", @"Mandelbrot - Manuel Kasten", @"Spiral - xleviator"];


@implementation ArtEquations


-(unsigned char)r1WithEntropy:(int)e column:(int)i row:(int)j {
    return (char)(_sq(cos(atan2(j-512,i-512)/(5.0/e)))*255);
}

-(unsigned char)g1WithEntropy:(int)e column:(int)i row:(int)j {
    return (char)(_sq(cos(atan2(j-512,i-512)/2-2*acos(-(5.0/e))/3))*255);
}

-(unsigned char)b1WithEntropy:(int)e column:(int)i row:(int)j {
    return (char)(_sq(cos(atan2(j-512,i-512)/(5.0/e)+2*acos(-1)/3))*255);
}



-(unsigned char)r2WithEntropy:(int)e column:(int)i row:(int)j {
    float s=3./(j+250),y=(j+sin((i*i+_sq(j-700)*5)/100./DIM+(e*10/DIM))*15)*s;return (int((i+DIM)*s+y)%2+int((DIM*2-i)*s+y)%2)*127;
}

-(unsigned char)g2WithEntropy:(int)e column:(int)i row:(int)j {
    float s=3./(j+250);
    float y=(j+sin((i*i+_sq(j-700)*5)/100./DIM+(e*10/DIM))*15)*s;
    return (int(5*((i+DIM)*s+y))%2+int(5*((DIM*2-i)*s+y))%2)*127;
}

-(unsigned char)b2WithEntropy:(int)e column:(int)i row:(int)j {
    float s=3./(j+250);
    float y=(j+sin((i*i+_sq(j-700)*5)/100./DIM+(e*10/DIM))*15)*s;
    return (int(29*((i+DIM)*s+y))%2+int(29*((DIM*2-i)*s+y))%2)*127;
}



-(unsigned char)r3WithEntropy:(int)e column:(int)i row:(int)j {
    i*=e;j*=e;
    return j^j+i^i;
}

-(unsigned char)g3WithEntropy:(int)e column:(int)i row:(int)j {
    i*=e;j*=e;
    return (i-256)^2+(j-256)^2;
}

-(unsigned char)b3WithEntropy:(int)e column:(int)i row:(int)j {
    i*=e;j*=e;
    return i^i-j^j;
}


-(unsigned char)r4WithEntropy:(int)e column:(int)i row:(int)j {
    double a=0,b=0,c,d,n=0;
    while((c=a*a)+(d=b*b)<4&&n++<880)
    {b=2*a*b+j*8e-9-.645411;a=c-d+i*8e-9+1.0/e;}
    return 255*pow((n-80)/800,3.);
}

-(unsigned char)g4WithEntropy:(int)e column:(int)i row:(int)j {
    double a=0,b=0,c,d,n=0;
    while((c=a*a)+(d=b*b)<4&&n++<880)
    {b=2*a*b+j*8e-9-.645411;a=c-d+i*8e-9+1.0/e;}
    return 255*pow((n-80)/800,.7);
}

-(unsigned char)b4WithEntropy:(int)e column:(int)i row:(int)j {
    double a=0,b=0,c,d,n=0;
    while((c=a*a)+(d=b*b)<4&&n++<880)
    {b=2*a*b+j*8e-9-.645411;a=c-d+i*8e-9+1.0/e;}
    return 255*pow((n-80)/800,(e/DIM));
}


-(unsigned char)r5WithEntropy:(int)e column:(int)i row:(int)j {
    return DIM - [self b5WithEntropy:e column:2*i row:2*j];
}

-(unsigned char)g5WithEntropy:(int)e column:(int)i row:(int)j {
    return [self b5WithEntropy:e column:j row:j]+128;
}

-(unsigned char)b5WithEntropy:(int)e column:(int)i row:(int)j {
    i -= 512;
    j -= 512;
    double theta = atan2(j,i);
    double prc = theta / 3.14f / 2.0f;
    int dist = sqrt(i*i + j*j);
    int makeSpiral = prc * e;
    return dist + makeSpiral;
}

@end
