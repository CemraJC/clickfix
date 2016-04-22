# To Contribute

As with any open source project, you can go ahead and make your changes however you like (under the tersm of the license). However, if you want your changes to be merged in, please make sure they follow these guidelines:

* **No external dependencies** (except AutoHotKey). Sorry - it's too hard for me to keep track of licensing, versions, compatibility - etc.
* **Stick to the language.** Contributions to the software itself should be written in AHK script, C or C++. Anything besides these languages won't be accepted - it makes the codebase messy.
* **No excessive commenting.** If your code isn't written clearly enough that people understand what it does, rename some things and do some refactoring. Comments to denote sections of code are fine though.
* **Follow the style.** See below for the mandatory styleguide.

If you want to be super helpful, do something that's on the todo list below.

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
* Buy a proper domain-name for the website
* Get us a mention in a notable place where potential users frequent - maximise the benfit to others
    + *Non-exhausitve list of notable places*
    + YouTube video of a significant repairs/tech channel (>8,000 subs / > 15,000 views)
    + Any popular (>2,000 readers) publication (news, blog, journal - etc.)
    + LifeHacker (article)
    * How To Geek (article)
    + Tom's Hardware (main threads)

#### Minor
> You get internet cred and your name in the commit logs for doing these

* Update the icon to be cooler
* Fix the lag issue (under "Caveats" in README.md)
* Support for more buttons (only if the problem exists)