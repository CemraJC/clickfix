# Warning About False Positives

> tldr; sometimes, crappy antivirus programs call ClickFix a virus. It isn't.

Because ClickFix needs to monitor clicks and decide which ones to allow through
to the underlying system, sometimes poorly made antivirus software will flag it
as malicious. This diagnosis is a **false positive.** As long as you downloaded
the ClickFix.exe program through a secure connection to the [main site][main] or
from the [Github releases page][releases] then its integrity is ensured.

The full source of ClickFix is uploaded to *this* Github repository. If you
would like to verify that the code behind the program is not dangerous, read
through [the main script][script] or compile it yourself with [AutoHotKey][ahk].

If you are having trouble with ClickFix being blocked by antivirus software, add
an exception for the ClickFix executable. If your software does not allow you to
add exceptions, please consider replacing it with a better antivirus program (I
personally recommend Avira or Avast - both have free versions).

[main]: https://clickfix.cf
[releases]: https://github.com/cemrajc/clickfix/releases/latest
[script]: https://github.com/cemrajc/clickfix/blob/master/ClickFix.ahk
[ahk]: http://ahkscript.org
