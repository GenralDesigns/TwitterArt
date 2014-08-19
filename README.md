TweetArt - A Mac App
=
<sup>Sorry for the unoriginal, boring name</sup>

This project is a submission/add-on to the contest happening at [Code Golf SE right now (Tweetable Mathematical Art)][11]

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


For those interested in how this works, it actually isn't the simplest process in the world. For some reason I could not get the Twitter API to work (OAuth is hard ^^). Even without OAuth, the API key only documentation is seriously awful. So how else can I do it? HTML scraping. No I didn't [parse HTML with regex][12] (although NSScanner maybe uses regex under the hood so who knows), I used `NSScanner`. I scanned for the first `ProfileTweet-contents` which contains the tweet contents, skipped a few new-lines and finally looped over until I got every non-tag contained string, and put it together separated by spaces. The hastag and @user and links took a little work to put together nicely so it doesn't perfectly match the tweet but 99% of the time it should.

The next step was generating an entropy which is unique and random, but reproducible for the same tweet. For this I chose hashing as the base for the generation. Hashes work by inputting a string and outputting a unique hashed, cryto string which will be reproducible given the same string. Then I use the sum of the string characters and the hash length, (the hash by the way is an MD5 hash) to seed some `rand()`s and eventually got a large number which I then mod by 1024 to get a number people can work with. Here's the full function:

    int numOfChars = (int)tweet.length;
    int sumOfChars = 0;
    
    for (int i = 0; i < numOfChars; i++) sumOfChars += (char)[tweet characterAtIndex:i];
    
    NSString *hashStr = [tweet hashedString];
    int numOfHashChars = (int)hashStr.length;
    int sumOfHashChars = 0;
    
    for (int i = 0; i < numOfHashChars; i++) sumOfHashChars += (char)[hashStr characterAtIndex:i];
    
    srand(sumOfHashChars);
    int randFromHash = rand() % numOfHashChars;
 
    srand(randFromHash);
    int randFromRand = rand() % numOfChars;
    
    srand(randFromRand + sumOfHashChars + sumOfChars);
    int totalRand = rand() % 1024;
    
    return totalRand;

`hashedString` converts the hashes binary output into a readable hexadecimal string. As you can see its pretty weird. Then from that, I supply *your*  functions with an entropy value `e` from 0-1023 which you can use as I have described above.

Here's a few pictures I saved, which you can see at the end of this document, feel free to add more. I don't actually have the tweets, but if you add more, please add the tweets and functions so we can generate them ourselves :)

![mandel][4]
![random][5]
![seirpenski][6]
![buddha][7]

Also I'd like to give credit to [faubiguy][8] because I used his art in the icon:
![icon][9]

[TweetArt Download Link][10]
=

<sub>Please note I just copied and pasted this from SE so it may seem like its more of a forum post format, because it is.</sub>

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
  [12]: http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454#1732454
