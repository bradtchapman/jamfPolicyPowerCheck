# jamfPolicyPowerCheck
Check the current battery level and AC power state, and ask a user to plug in the Mac prior to continuing a policy.

Load this script into your JSS, set the priority to "Before."
Then add it to any policy where you need a battery warning.

The script contains an icon file encoded in base64 which is written to /tmp/battery-low-plugin.png
at run time.  You can remove and replace this if you want, using base64 -i something.png -o somethingbase64.txt
and copying the base64 text into the script within the quotes.  The final character is the equals sign (=).

The power threshold and AC power state are configurable.  Take a look at the if [[ logic ]] blocks
in the checkCharge function, and read the notes to decide if you want to hold execution until 
the battery reaches a certain minimum level--even if AC power is plugged in.

