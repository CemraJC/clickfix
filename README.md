# ClickFix
###Tame your mouse
> Windows Only - *Should work on any version*


### Get started

To get going with ClickFix, simply download the [latest executable](https://github.com/cemrajc/clickfix/releases/latest), **put it in its own folder** and run it. Because ClickFix is completely portable, it runs without installation - you could even run it off a thumb-drive.

When started for the first time, the "About" window pops up. Right click on the tray icon and under 'Options' click the name of the button on your mouse that's giving you grief. You can choose to start ClickFix with Windows in this menu as well (for convenience). ClickFix will run in the background, keeping a leash on your mouse.

Copyright 2016 Jason Cemra - released under the [GPLv3](http://www.gnu.org/licenses/)

Very special thanks to the [AutoHotKey crew](https://autohotkey.com/), for making this script easy.


# All about it
There exists a serious issue in modern society - wild mice.

A "wild mouse" clicks multiple times when only instructed to click once. You may have experience with this particular glitch, which can occur on any of the mouse's buttons.

I personally believed that this could not be fixed in software, because it's a problem with the mouse itself. I also believed that this problem pretty much happens to every mouse at some point - and the only practical solution is to get a new one. Well, I say **no more**!

What started with an idea became ClickFix. With this very simple software, we hope to successfully apply basic debouncing logic to tame your wild mouse and make it usable again - at least until you can get a more reliable replacement.

### Caveats

**ClickFix doesn't claim that it can tame *all* wild mice.**

One noticeable drawback of ClickFix, is that users which rely on extremely low latency input (gamers, editors, 3D modelers, digital artists) **will notice a slight lag** from when they physically release the button, to when it is 'released' in the software.

Sometimes, the mouse buttons extra click happens *just* too late for the fix to work - so it will send an extra click. This is a very rare occurrence, but I have observed it myself.

Other than those minor issues, **the benefits of ClickFix are undeniably worth the draw backs.** Mainly, because ClickFix takes an unusable mouse and makes it bearable.

Unfortunately, this software is limited by the test cases we have access to. Since I only have access to one faulty mouse, it's entirely possible that this solution only works for me. **If you're willing to leave feedback, send me a message telling me if it did or did not work.**

### How it works

ClickFix is very simple. Most of the script's length is actually the interface logic. As mentioned in the about section, all it does is debounce the mouse clicks. Every time you click a button that is targeted for fixing, ClickFix will hold it down *in software* for a short amount of time until you release it. Normally, the multiple clicks a wild mouse performs happen *very* fast, so the delay that ClickFix imposes is long enough to cancel the extra clicks - but short enough to mostly not be noticed.