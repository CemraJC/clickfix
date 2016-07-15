# Having problems?

Sorry about that :(
It's an annoying fact of software development that small-time programs don't always work for everyone. I've compiled a list of common problems and some things you can try if you even have the problem.

## The fix doesn't work

* Try messing around with the slider - put it hard to the right and see if it works then.
* Make sure that ClickFix is actually running. You should see an icon in the tray area if it is.
* Can you successfully select a large block of text without it messing up?

## I can't double click!

You probably can, but the pressure slider is turned up so far that the click lag is very noticeable. If you go to mouse settings (search for it in the start menu) then you should be able to change your double click speed there. Turn it *up* so that you can slow down your clicks enough for the operating system to register them as separate.

Note that with the pressure slider **at the max**, the lag / delay should be about 250ms between when you release the mouse, and when ClickFix tells the computer that you have released it.

## The left mouse button is disabled

If this happens to you, the first step is re-enabling your left mouse button. Right click on the ClickFix icon <img src="icon/ClickFix-icon.jpg" style="width: 18px;" height="18" width="18"> in the tray area and try to use your keyboard arrow keys to highlight `Exit` and then press <kbd>Enter</kbd>.

* Try running ClickFix in compatibility mode for Windows 7. Right click on the program, go to `Properties` > `Compatibility`, check the `Run this program in compatibility mode for` box and select `Windows 7`.
* Try to right click. If it works, go down to the taskbar / tray area and right click on the ClickFix icon. Then, use your keyboard to hit `Restart`.
* Try left clicking on a program icon in your taskbar. If you can successfully left click, then [send me an email](#email)

<a id="email"></a>
# If all else fails

Then, firstly, thanks for sticking with me so far - sorry for the inconvenience :(

If you can't get anything to work then I would like to help with 'fixing ClickFix'. If you have the time, please send me an email with the following information enclosed:

* The type of mouse you're using (brand name is enough, e.g. "Logitech"). The type of mouse *shouldn't* matter, but I'd like to check just in case there's a common issue from multiple people.
* Your operating system name (Windows 7, Windows 8 - etc.)
* A snapshot of the programs that were running while ClickFix was causing an issue.
    - **Steps for getting a snapshot of running programs:**
    - Open ClickFix and confirm that the problem is still occurring
    - Close / disable ClickFix
    - Open the command prompt (search for cmd.exe)
    - Paste in the command `tasklist > C:\list_of_programs.txt`
        - Right click to paste
    - Press <kbd>Enter</kbd> to run the command
    - Go to your C drive and see if the list is there
        - If it isn't there, then made sure you ran the command properly and there's no errors. I
        - If there's still no list, then just skip this whole section - don't waste your time
    - If it all worked, close the command prompt and attach the list to the email you're about to send :P

<a href="mailto:cemrajc+clickfix@gmail.com" title="cemrajc+clickfix@gmail.com"><button>Send me an email! :smile:</button></a>

Note that it may take me up to a week to see your email - be patient, I will try to respond within two weeks.

#### Email Template
If you don't want to waste time putting together an email, then I've made a template for you. If something doesn't quite match or you have things to add / you have a problem that isn't listed, then you'll need to put that in yourself :/

**Some info I need:**<br>
Operating system name: <select name="os">
    <option selected>Windows 10</option>
    <option>Windows 8</option>
    <option>Windows 7</option>
</select><br>
Problem you're having:
<select name="issue">
    <option value="the left mouse button is disabled when I run ClickFix.">Left mouse disabled</option>
    <option value="I can't double click - even after trying everything on the troubleshooting list.">No double click</option>
    <option value="it doesn't matter what I do with the slider - my mouse still randomly clicks multiple times when I only press the mouse button once.">The fix doesn't work</option>
</select><br>
Brand / name of your mouse: <input type="text" name="mousebrand" value="Logitech MX Master"><br>

**Subject Line:** ClickFix doesn't work for me

**Body of email:** (copy and paste everything that follows)

Hello!

Unfortunately, ClickFix is a bit broken for me. Maybe you can help?

See, the problem is, <span class="fill_in" filler="issue">$ISSUE</span><br>
My operating system is <span class="fill_in" filler="os">$OPERATING_SYSTEM</span><br>

Just in case you needed to know, my mouse is a "<span class="fill_in" filler="mousebrand">$TYPE_OF_MOUSE</span>"

<script>
    document.addEventListener("DOMContentLoaded", function(){
        var elems = {
            os: document.querySelector("select[name=os]"),
            issue: document.querySelector("select[name=issue]"),
            brand: document.querySelector("input[name=mousebrand]")
        }

        for (var el in elems) {
            elems[el].addEventListener('change', updateTemplate);
        }

        updateTemplate();

        function updateTemplate(){
            var fill;
            for (var el in elems) {
                fill = document.querySelector("span.fill_in[filler=" + elems[el].name + "]");
                if (fill.innerHTML) {
                    fill.innerHTML = elems[el].value;
                }
            }
        }
    })
</script>

