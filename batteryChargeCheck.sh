#!/bin/sh
#
# batteryChargeCheck.sh
# Written by Brad Chapman
# 2018-03-29
# Determine if computer has enough power to run software updates
# And display a message with jamfHelper if it does not.
#

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
hasBattery=$(cat $batteryInfo | grep "Battery Installed" | awk '{ print $3 '} )
acPowerConnected=$(cat $batteryInfo | grep "Connected" | head -1 | awk '{ print $2 }' )
chgRem=$(cat $batteryInfo | grep "mAh" | grep Remain | awk '{ print $4 }')
chgFull=$(cat $batteryInfo | grep "mAh" | grep Capacity | awk '{ print $5 }')
chgPct=$(echo "( ( $chgRem / $chgFull ) * 100 )" | bc -l )
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

checkCharge
[[ $powerOK == "No" ]] && runJamfHelper

while [[ $powerOK != "Yes" ]]
do
	checkCharge;
done

/usr/bin/killall "jamfHelper"

echo "<result>$powerOK</result>"
exit 0

