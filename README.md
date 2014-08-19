TweetArt - A Mac App
=
<sup>Sorry for the unoriginal, boring name</sup>

This project is a submission/add-on to the contest happening at [Code Golf SE right now (Tweetable Mathematical Art][11]

I created this app because if this contest is all about tweets, why not use some *actual* tweets from *actual* users? Just enter a @username to pull the first tweet from that user. From this tweet, the tweet then goes through an entropy generator (I'm not sure if that's the correct usage of the word but in this context it just means its randomness), which outputs a random number between 0 and 1024. If you run the same tweet through, you'll get the same number. This then can be used as sort of seed for a math function/equation, or used directly as a value. 

For example: 
 
- As the seed for `srand();` or another PRNG.
- Used to generate coordinates and a zoom level for a fractal.
- As the hue for a color. e.g. `e % 255 = color`.

The possibilities are endless!

So what else can this app do?

 - Ability to add your own custom tweet
 - Save as both PNG and BMP. So no need for any other applications to view your art.
 - Fully C++ compatible wrapped in Objective C i.e. Objective C++.
 - Supports multiple equations.
 - Randomize equations to generate art truly random.
 - Easily add new equations with the help of Objective-C's *awesome* built-in reflection support.

Here's a screenshot:
![Image][2]

As you can see, Martin Buttner's art does not look exactly like his submission, but that's because I've modified it slightly to add the effects of entropy. I've included seven submissions from users whose submissions I particularly enjoyed. Not to discriminate of course but adopting an equation which I have absolutely no understanding of how it works, is time consuming so I stopped at seven. 

So how do I add an equation you might be wondering? Well there are just a few simple steps:

 1. In ArtEquations.h, copy and paste the three methods for each channel and change the number to the next number in the list. For example, adding one new art thing will add three new methods called:

         -(unsigned char)r8WithEntropy:(int)e column:(int)i row:(int)j;
         -(unsigned char)g8WithEntropy:(int)e column:(int)i row:(int)j;
         -(unsigned char)b8WithEntropy:(int)e column:(int)i row:(int)j;

If this syntax looks alien to you, it's pretty simple. `unsigned char` is the return type, and the words followed by colons make up the message name (in this example, the whole message name is `r8WithEntropy:column:row:`. The `(int)x` are the parameters associated with each message fragment. For each art thing you add, simply increment the number in the first message part by 1 r9, r10, r11, etc.

  2) In ArtEquations.mm (the file extension for ObjC++ implementation files), under number of equations, increment that number to how every many art things you have (how intutive!).

  3) In the EquationNames, add a name for your art using the syntax of `@"Name"`, and add it to the end before the bracket, and separate the names by commas.

  4) At the bottom of the file, paste in the three methods you added from step 1., and replace the semicolons with open and closed braces.

  5) Inside those braces, add your C++ code! Add all your C++ goodness right inside that Objective-C method. Cool right? If you need to call say r8 from g8, feel free to define a Macro for it with the syntax of: `#define RD(I,J) [self r8WithEntropy:e column:I row:J]`. And replace `RD` with whatever you need and `r8` with whatever channel you need.

  6) And that's it! That's all you need. run the application and your art thing should show up right in the picker. 

If you don't have Xcode, see [this][3] link for how to compile an Xcode project from the command line. 


Please fork this! Add your own art stuff with a new entropy parameter, and contribute to this post! Add in your methods and what tweet generated that cool art! The github project link is at the top of this post. Once you fork and add new stuff, just add a comment so I can merge the changes and update the download link for the built and runnable app.

Todo:

 - I can currently use only unsigned chars. If anyone wants to figure out how to use unsigned shorts, please fork and comment. I'll gladly merge.
 - Maybe pull code directly from this website??? :)
 - Add as many arts as I can!
 - Clear const values after generation. Currently, because this doesn't just exit after generation as in the other ones, consts aren't cleared. If anyone knows how to clear them, please tell me.

Here's a few pictures I saved, feel free to add more. I don't actually have the tweets, but if you add more, please add the tweets and functions so we can generate them ourselves :)

![mandel][4]
![random][5]
![seirpenski][6]
![buddha][7]

Also I'd like to give credit to [faubiguy][8] because I used his art in the icon:
![icon][9]

[TweetArt Download Link][10]
=


  [1]: https://github.com/GenralDesigns/TwitterArt
  [2]: http://i.stack.imgur.com/TCRbF.jpg
  [3]: https://developer.apple.com/library/ios/technotes/tn2339/_index.html
  [4]: http://i.stack.imgur.com/7xAqd.jpg
  [5]: http://i.stack.imgur.com/GZ7U3.png
  [6]: http://i.stack.imgur.com/B9BuT.png
  [7]: http://i.stack.imgur.com/2Kh7j.jpg
  [8]: http://codegolf.stackexchange.com/users/29990/faubiguy
  [9]: http://i.stack.imgur.com/p9VLs.png
  [10]: http://bit.ly/Xptj2l
  [11]: http://codegolf.stackexchange.com/questions/35569/tweetable-mathematical-art/36281#36281
