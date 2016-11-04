#!/bin/bash

# Extracts .png icons from installed Adobe Creative Cloud .app bundles

# Find the Adobe .app bundles
# Exclude the general Adobe directory as well as the one in Utilities
find /Applications -name "Adobe *.app" -maxdepth 2 -not -path "/Applications/Adobe/*" -not -path "/Applications/Utilities*" | while read line; do
   # Get the icon name
   icnsName=$(/usr/libexec/PlistBuddy -c "print :CFBundleIconFile" "$line"/Contents/Info.plist)
   # Sometimes Adobe leaves the file extension off the icon name, so check the extension is there
   fileExtension="${icnsName##*.}"
   if [ "${icnsName##*.}" != "icns" ]; then
      # If it's not there, append the extension
      icnsName+='.icns'
   fi
   # Get the app name
   appName=$(/usr/libexec/PlistBuddy -c "print :CFBundleName" "$line"/Contents/Info.plist)
   # Check that the app name isn't empty. For some reason, sometimes Adobe doesn't include the CFBundleName key
   if [ -z "$appName" ]; then
      appName=$(/usr/bin/basename "$line" .app)
   fi
   # Create a .png of the .icns on the desktop
   sips -s format png "$line"/Contents/Resources/"$icnsName" --out ~/Desktop/"$appName".png
done
