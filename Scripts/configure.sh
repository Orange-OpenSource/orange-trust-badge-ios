#!/bin/sh -x

echo "Configuring compilation"
echo $PWD
#echo $GCC_PREPROCESSOR_DEFINITIONS | grep COCOAPODS
#if [ $? == 0 ]
#then
#    echo "Cocoapods integration"
#    echo "The compilation is already configured by your Podfile"
#    exit 0
#fi

# Testing Carthage
if [ -d ../Carthage/Checkout ]
then
    APP_ROOT_PATH="../Carthage/Checkout"
fi

# Looking for InfoPlist.String
INFOPLIST_STRING=`find $PWD/$APP_ROOT_PATH -name InfoPlist.strings`
if [ $? != 0 ]
then
    echo "Your app doesn't contains any InfoPlist.strings file. You must provide one to integrate OrangeTrustBadge. See https://github.com/Orange-OpenSource/orange-trust-badge-ios/blob/master/README.md"
    exit 1
fi

# Configure conditional compilation
grep NSSpeechRecognitionUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="-DSPEECH"
fi

grep NSAppleMusicUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DMEDIAPLYER"
fi

grep NSBluetoothPeripheralUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DBLUETOOTH"
fi

grep NSCalendarsUsageDescription $INFOPLIST_STRING
calendars=$?
grep NSRemindersUsageDescription $INFOPLIST_STRING
reminders=$?
if [ $calendars == 0 -o $reminders == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DEVENTKIT"
fi

grep NSCameraUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DCAMERA"
fi

grep NSContactsUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DCONTACTS"
fi

grep NSHealthShareUsageDescription $INFOPLIST_STRING
healthShare=$?
grep NSHealthUpdateUsageDescription $INFOPLIST_STRING
healthUpdate=$?
if [ $healthShare == 0 -o $healthUpdate == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DHEALTHKIT"
fi

grep NSHomeKitUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DHOMEKIT"
fi

grep NSLocationAlwaysAndWhenInUseUsageDescription $INFOPLIST_STRING
location=$?
grep NSLocationAlwaysUsageDescription $INFOPLIST_STRING
location1=$?
grep NSLocationWhenInUseUsageDescription $INFOPLIST_STRING
location2=$?
if [ $location == 0 -o $location1 == 0 -o $location2 == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DCORELOCATION"
fi

grep NSMicrophoneUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DMICROPHONE"
fi

grep NSMotionUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DMOTION"
fi

grep NSPhotoLibraryUsageDescription $INFOPLIST_STRING
if [ $? == 0 ]
then
    TRUSTBADGE_FLAGS="$TRUSTBADGE_FLAGS -DPHOTOS"
fi




sed -i -e "s/.*OTHER_SWIFT_FLAGS.*/OTHER_SWIFT_FLAGS = \"$TRUSTBADGE_FLAGS\";/" OrangeTrustBadge.xcodeproj/project.pbxproj
