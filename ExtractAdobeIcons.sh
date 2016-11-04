#!/bin/bash

# Extracts .png icons from installed Adobe Creative Cloud .app bundles
# Has to be run on the Mac that actually has the relevant .app bundles already installed

# Find the Adobe .app bundles
# Exclude the general Adobe directory as well as the one in Utilities
find /Applications -name "Adobe *.app" -maxdepth 2 -not -path "/Applications/Adobe/*" -not -path "/Applications/Utilities*" | while read line; do
   # Get the icon name
   icnsName=$(/usr/libexec/PlistBuddy -c "print :CFBundleIconFile" "$line"/Contents/Info.plist)
   # Get the app name
   appName=$(/usr/libexec/PlistBuddy -c "print :CFBundleName" "$line"/Contents/Info.plist)
   # Create a .png of the .icns on the desktop
   sips -s format png "$line"/Contents/Resources/"$icnsName" --out ~/Desktop/"$appName".png
done
