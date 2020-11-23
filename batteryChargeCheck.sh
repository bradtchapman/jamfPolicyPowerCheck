#!/bin/sh
#
# batteryChargeCheck.sh
# Written by Brad Chapman
# 2018-03-29
# Determine if computer has enough power to run software updates
# And display a message with jamfHelper if it does not.
# 
# The battery icon below in base64 is optional, or can be replaced with something else.
# To create your own base64 string, run "base64 -i /path/to/file.png -o /path/to/base64.txt"
# Copy and insert the text into your script.
#
# Update to check for Big Sur as Big Sur system_profiler reports battery charge as a % 
# and not as absolute charge value
# Updated by Rob Blount

# set -x

writeBatteryIcon()
{
batteryIcon="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"
echo $batteryIcon | base64 -D -o /tmp/battery-low-plugin.png
}

writeBatteryIcon
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jhTitle="ACME Information Technology Services"
jhHeading="Your Mac needs charging."
Description="Please connect your Mac to a power source to continue installing updates.

The battery is not sufficiently charged.  Running out of power during software updates poses a serious risk of data loss and system instability.

If you understand and accept this risk, you may close the window."

jhMessage=$( echo "$Description" )
batteryIconFile="/tmp/battery-low-plugin.png"
minChargeLevel="40"
batteryInfo="/tmp/spPowerDataInfo.txt"
powerOK="No"

runJamfHelper()
{
"$jamfHelper" -startlaunchd -windowType hud \
-icon "$batteryIconFile" -iconSize 240 -title "$jhTitle" \
-heading "$jhHeading" -description "$jhMessage" &
}

checkCharge()
{
/usr/sbin/system_profiler SPPowerDataType > $batteryInfo
acPowerConnected=$(cat $batteryInfo | grep "Connected" | head -1 | awk '{ print $2 }' )
chgFull=$(cat $batteryInfo | grep "mAh" | grep Capacity | awk '{ print $5 }')
chgPct=$()

if [[ $majorOSVers -eq 11 ]]; then
	hasBattery=$(cat $batteryInfo | grep "Device Name" > /dev/null && echo "Yes" )
	chgPct=$(cat $batteryInfo | grep "%" | awk -F": " '{print $2}')
else
	hasBattery=$(cat $batteryInfo | grep "Battery Installed" | awk '{ print $3 '} )
	chgRem=$(cat $batteryInfo | grep "mAh" | grep Remain | awk '{ print $4 }')
	chgPct=$(echo "( ( $chgRem / $chgFull ) * 100 )" | bc -l )

fi 

chgGood=$(echo "$chgPct > $minChargeLevel" | bc -l )
[[ -z $hasBattery ]] && powerOK="Yes"

#
# In this section, the script will release as soon as the AC adapter is plugged in,
# even if the value of $chgGood is 0 (calculated result is below $minChargeLevel).  
# Change that value to "No" if you wish to hold the script until battery
# reaches the desired minimum charge level.
# 

if [[ $hasBattery == "Yes" ]]; then
	[[ $chgGood == 1 ]] && powerOK="Yes"
	[[ $chgGood == 0 ]] && [[ $acPowerConnected == "Yes" ]] && powerOK="Yes"  ## SEE NOTE ABOVE
	[[ $chgGood == 0 ]] && [[ $acPowerConnected == "No" ]] && powerOK="No"
fi

sleep 2

# Debugging block; comment out as desired
echo "Computer battery: $hasBattery"
echo "AC Power is $acPowerConnected"
echo "Charge Remaining is: $chgRem mAh"
echo "Full Charge value is: $chgFull mAh"
echo "Charge Percentage is: $chgPct"
echo "Above Minimum Charge? $chgGood"
echo "Is power is sufficient to continue? $powerOK"
echo "------"
# Debugging block END

}

#
# Power and charge detection logic
#
majorOSVers=$( sw_vers -productVersion | awk -F"." '{print $1}' )
checkCharge
[[ $powerOK == "No" ]] && runJamfHelper

while [[ $powerOK != "Yes" ]]
do
	checkCharge;
done

/usr/bin/killall "jamfHelper"

exit 0

