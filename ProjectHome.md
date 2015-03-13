# Flex Slim #
Flexslim is a component which works with Fitnesse to form an acceptance testing tool.
The tool provides an approach to define Usecases / Scenario's of your Flash AIR
(Actionscript 3.0) application and gives a means to validate the Flash components
been developed for particular specification or a requirement.

# Source Code organised #

|  \--> Fitnesse ----> fitnesse.jar  (java -jar fitnesse.jar -p 80) |
|:------------------------------------------------------------------|
|  |    |                                                           |
|  |    \-----> fb4-eclipse-plugin                                  |
|  |            |                                                   |
|  |            \ ----->  com.bandxi.fitnesse.example\_1.0.2.jar (fb 4/4.5 or eclipse plugin)  |
|  |            \ ----->  com.bandxi.fitnesse.feature\_1.0.2.jar  |
|  |            \ ----->  com.bandxi.fitnesse.launcher\_1.0.2.jar |
|  \--> flexlim-test (Project to be opened in fb 4 or 4.5 to test flexslim) |
|  |    |
|  \--> trunk  (Project of the Flexslim library to be opened in fb 4 or 4.5) |
|  |    |
|  \--> wiki   |


# Flex Slim Blog #
> The Flex Slim setup is been well described in a blog in the following URL:-

| http://flexslim.blogspot.com/2011/10/flex-slim-fitnssese-tool-for.html   |(Part-1)|
|:-------------------------------------------------------------------------|:-------|
| http://flexslim.blogspot.com/2011/10/flex-slim-fitnssese-tool-for_10.html|(Part-2)|
| http://flexslim.blogspot.com/2011/10/flex-slim-fitnssese-tool-for_11.html|(Part-3)|

  * Pre-requiste (a list of software to be installed and environment setup
  * Configuration (a list of steps for tool setup.)
  * Defining Testcases for the sample
  * Running Testcases
  * Enabling Remote debugging and debugging.
  * Preface (team which developed and utilisation)

# Feedback #
> | Asher Sterkin | asher.sterkin@gmail.com |
|:--------------|:------------------------|
> | Raghavendra R | robinr.rao@gmail.com    |

# Preface #
Flex Slim is a tool  developed to provide a platform to enable development of
Functional Testing / Acceptance Testing  suite for applications developed using
Adobe Actionscript 3.0 source. In order to keep things simple the application that
is been developed is assumed to be an AIR 2.0 compiled code. The Flex Slim provides
tool is the central component which allows to do development of other elements of functional testing.

  * Testcase / Scenario / Usecases definition on a web page can be reused for multiple applications.
  * Fixture Actionscript 3.0 classes which provides data elements, event handlers etc to test component under test.


Flexslim as a tool development wouldn't have been successful without mentioning few
of my collegues who constantly encouraged me and challenged to make it even better.
I would like to thank them for their continued support and encouragement.

a) Asher Sterkin   (Co-Author of Flexslim)
> He is the guru and provides us the guiding light to all the projects, without his help and persuasion the tool development of FlexSlim wouldn't have happened. I have always discussed most of my unknowns with him quite often, and has always show the right kind of info and knowledge on the subject.

b) Suresh Gopathy
> He has been in the fore front in taking extra effort in understanding the Fitnesse tool, and with whom I have been working for quite number of years now and always providing strategy in the development of tool.

c) Sushma Rai
> She always had patient to listen and inquisitive in adding additional effort to understand the benefits of the tool and giving sufficient time to make the tool happen. I have been working on and off for few years now.

d) Sreedhar Shenoy,

> Sreedhar showed a lot of patience and quickly allowed me experiment in evolving the tool and convert it into a practical solution for it evolve.

e) Suresh Lakkala
> Suresh for quickly understanding and acknowledging the benefits of Flexslim.

f) Prashanth Nanjundappa

Prashanth who has constantly challenged me on the tool to make it fully integrated into IDE and  enable the feature of debugging to the developers to use.

h) Lakshmi Kantha

As a fresh bee... from study school... gave fresh thought to make the tool more effective.
Thanks for your support and help.

