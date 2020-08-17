### Riddler Classic - 08/14/2020

>From Angela Zhou comes one riddle to rule them all:
>The Riddler Manufacturing Company makes all sorts of mathematical tools: compasses, protractors, slide rules — you name it!
>Recently, there was an issue with the production of foot-long rulers. It seems that each ruler was accidentally sliced at three random points along the ruler, resulting in four pieces. Looking on the bright side, that means there are now four times as many rulers — they just happen to have different lengths.
>On average, how long are the pieces that contain the 6-inch mark?

My approach was to simulate the cuts, by generating three random numbers between 0 and 12. Then, I figured the two cuts surrounding the 6-in mark and the length of the segment. I repeated this procedure a million times (through a Python script) and calculated the average length. I ran the program three times, always resulting in 5.62 inches:
Run | result 
--- | ---
1|5.624404001221182
2|5.6222948756449265
3|5.624409094322186

To make the result more visually appealing, I created the following animation. It is interesting to see how, as the number of produced rulers increases, the average length gets closer to 5.6 inches!

![](cuts_animation.gif)
