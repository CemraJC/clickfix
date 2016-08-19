# ClickFix
###Tame your mouse - stop annoying repeat clicks
> ***Windows Only*** - *Should work on any version - tested on Windows 7*

> If this fixes your mouse (or doesn't) [let me know about it!](mailto:cemrajc+clickfix@gmail.com) :smile:


### [Getting started](https://github.com/cemrajc/clickfix/releases/latest) <span style="font-size:60%">*&larr; TL;DR, click here.*</span>

**1: Download**<br>
To get going, simply download the [latest executable](https://github.com/cemrajc/clickfix/releases/latest), **put it in its own folder** and run it. Because ClickFix is completely portable, it runs without installation - you could even run it off a thumb-drive. Keep in mind that it will create a settings file in the folder you put it in.

**2: First Run**<br>
When started for the first time, the "About" window pops up. Behind this window is the settings panel (this can be accessed later from the tray menu). To get ClickFix up and running, select the mouse button that needs fixing. I reccommend using the 'click tester' on the [homepage](https://clickfix.cf) to fine-tune the pressure setting. Normally the default `pressure` setting works well, but if the fix only works sometimes or *doesn't work at all*, try increasing the `pressure` slider.

I reccommend you also enable `Start on Windows Startup` (for convenience).<br>
When you're satisfied that everything works as it should, hit Ok and ClickFix will never bother you again.

**3: Forever After That**<br>
ClickFix will run in the background, keeping a leash on your mouse.
If you ever want to quickly change some settings, right click on the tray icon and under 'Quick Options' you have access to some of the standard settings.<br>
If you have a **feature request** or you **come across any bugs**, please start an [issue tracker](https://github.com/cemrajc/clickfix/issues) and I'll try to accommodate you as soon as possible.

**Tip:** You can double click the tray icon to access the full settings window.

> Very special thanks to the [AutoHotKey crew](https://autohotkey.com/) - their scripting language made this super easy.

**Update**<br>

1. Download the [latest ClickFix](https://github.com/cemrajc/clickfix/releases/latest)
1. Locate the ClickFix.exe file on your file system
1. Make sure ClickFix *isn't* running
1. Delete the old one
1. Put the latest in


**Uninstall**<br>
To remove all traces of ClickFix from your system, simply click "Reset" in the tray menu or the settings window and delete the folder you put it in.

**Obligatory garbage**<br>
Copyright &copy; 2016 Jason Cemra - released under the [GPLv3](http://www.gnu.org/licenses/)


# Learn more here:
**The Problem**<br>
There exists a serious issue in modern society - wild mice. A "wild mouse" clicks multiple times when only instructed to click once. You may have experience with this particular glitch, which can occur on any of the mouse's primary buttons - even the middle click.

It was believed by many (including myself) this problem could not be fixed with software, because it's a problem with the mouse itself. I also believed that this pretty much happens to every mouse at some point - and the only practical solution is to constantly get a new one. Well, I say *no more*!

**The Solution**<br>
What started with an idea became ClickFix. With this very simple software, we hope to successfully apply basic debouncing logic to tame your wild mouse and make it usable again - at least until you can get a more reliable replacement.


### Caveats

**ClickFix doesn't claim to tame *all* wild mice.**

One noticeable drawback of ClickFix, is that users which rely on extremely low latency input (gamers, editors, 3D modelers, digital artists) will notice a *slight* lag between clicks. Depending on the pressure slider, repeat clicks will be blocked. This may have a problematic effect on double clicking if the pressure is too high. As mentioned before, I reccommend using the 'click tester' on the [homepage](https://clickfix.cf) to fine-tune the pressure. **The general rule is this:**

<blockquote style="color: #111; font-size:110%;">  More pressure &rarr; better fix :smile: &rarr; more lag :confused: </blockquote>

Mouse-type input devices that may not be broken (such as a pen tablet) will also be affected; although if you have a pen tablet, you can probably *afford* a replacement mouse :smile:

Sometimes, the mouse buttons extra click happens *just* too late for the fix to work - so it will send an extra click. This is a very rare occurrence, but I have observed it myself.

**The Company Motto**<br>
Other than those minor issues, **the benefits of ClickFix are undeniably worth the draw backs.**
<blockquote style="color: #111; font-size:110%;">ClickFix takes an unusable mouse and makes it bearable.</blockquote>

Unfortunately, this software is limited by the test cases we have access to. Since I only have access to one faulty mouse, it's entirely possible that this solution only works for me and the few others I have heard from. **If you're willing to leave feedback, send me a message telling me if it did or did not work.**

### How it works

ClickFix is very simple. Most of the script's length is actually the interface logic. As mentioned in the about section, all it does is debounce the mouse clicks. Every time you click a button that is targeted for fixing, ClickFix will hold it down *in software* for a short amount of time until you release it. Normally, the multiple clicks a wild mouse performs happen *very* fast, so the delay that ClickFix imposes is long enough to cancel the extra clicks - but short enough to mostly not be noticed.
