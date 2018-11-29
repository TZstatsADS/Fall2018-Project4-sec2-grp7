# Project: OCR (Optical Character Recognition) 

![image](figs/intro.png)

### [Full Project Description](doc/project4_desc.md)

Term: Fall 2018

+ Team # 7
+ Team members
	+ Jin, Min  mj2824@columbia.edu
	+ Mu, Jay  jm4610@columbia.edu
	+ Pei, Yukun  yp2446@columbia.edu
	+ Smith, Kayla kys2112@columbia.edu
	+ Zhang, Yixin  yz3223@columbia.edu

+ Project summary: In this project, we created an OCR post-processing procedure to enhance Tesseract OCR output. The detection method is positional binary n-gram and correction method is topic model. Error detection is performed by comparing all possible bigrams of all words in Tesseract with positional binary matrix constructed from Ground Truth. If any bigrams of a word do not appear in the corresponding positional binary matrix then the word is classified as error. The error correction algorithm consists of a topic model that provides information about word probabilities. We list all the candidates of an error word and calculate the probability of each candidate based on the topic model. The candidate with the highest probability will be chosen as the correct word.

+ [Presentation](https://github.com/TZstatsADS/Fall2018-Project4-sec2--sec2proj4_grp7/blob/master/output/PPT_proj4_group7%20%5BAutosaved%5D.pptx)

**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
