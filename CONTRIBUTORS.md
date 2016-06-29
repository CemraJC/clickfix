# To Contribute

If you want to be super helpful, do something that's on the todo list below :)

As with any open source project, you can go ahead and make your changes and integrations however fits under the terms of the license (see LICENSE.txt). However, if you want your changes to be merged in, please make sure that you are aware of the Contributor License Agreement and that contributions follow these guidelines:

* **No licensed external dependencies** (except AutoHotKey). Sorry - it's too hard for me to keep track of licensing, versions, compatibility - etc. Free(dom) software is allowed though.
* **Stick to the language.** Contributions to the software itself should be written in AHK script, C or C++. Anything besides these languages won't be accepted - it makes the codebase messy.
* **No excessive commenting.** If your code isn't written clearly enough that people understand what it does, rename some things and do some refactoring. Comments to denote sections of code are fine though.
* **Follow the style.** See below for the mandatory styleguide.


### Contributor License Agreement

>TL;DR The contributor signs over the rights of any contributions (code, graphics - any resource) to be solely owned by the project

By contributing to this project, it is assumed that the contributor is familiar with the following terms.
Any contribution of resources (code, graphics, etc.) to this project are free from the author's copyright and the rights of any other party involved with the resource. The rights to the resource are explicitly signed over to the project as its own entity. The project is not responsible for resolving potential misdemeanors from license terms as performed by the contributor - the project considers any contribution as solely its own resource, for the purposes of licensing simplicity.

If you contribute positively to this project, you are required to accept that you are a slightly more awesome person than you were before :P

### Styleguide

I have a few rules - not many, but they are important:

* Be consistent. If in doubt, have a look at the previously written code.
* Small functions. Try to keep them below 6 lines. 15 lines is the absolute maximum (a single brace doesn't count as a line)
* Spaces to pad operators: `1 + 1 = 2` and `variable := "String"`
* Repetition is allowed in AHK script. No excuses in C/C++ though
* Variable and function names are all lower case, words seperated by underscores.
* One true brace style:
```c
if (x > y) { // <--- One true brace
    // Code
}
```
* Always have padding around brackets, except between function names and parameter lists:
```c
void sum(int a, int b) //...
if (expression) //...
while (condition) //...
```

Thanks for taking the time to read this - it really helps.

## Todo List

#### Major
> You get a spot in the hall of fame

* Port the software to OSX
* Port the software to Unix-like systems
* Sponsor a proper domain-name for the website (TLD must be one of `.com`, `.io` or `.org`)
* Get us a mention in a notable place where potential users frequent - maximise the benfit to others
    + *Non-exhausitve list of notable places:*
    + YouTube video of a significant repairs/tech channel (>8,000 subs / > 15,000 views)
    + Any popular (>2,000 readers) publication (news, blog, journal - etc.)
    + LifeHacker (article)
    * How To Geek (article)
    + Tom's Hardware (main threads)

#### Minor
> You get internet cred and your username in the commit logs for doing these

* Make the icon look even cooler
* Fix the lag issue (under "Caveats" in README.md)
* Support for more buttons (only if the problem exists)
* Fix up the gh-pages branch history (looks bad)
* Optimize the gh-pages site images and responsiveness (scaling issues)
* Make a test ground for new mice / issues (web interface - capture clicks, flag misclicks)
