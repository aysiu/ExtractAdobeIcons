#!/bin/bash

# Extracts .png icons from installed Adobe Creative Cloud .app bundles

# Make a folder on the desktop to hold the extracted icons
/bin/mkdir -p ~/Desktop/AdobeIcons/

# Find the Adobe .app bundles
# Exclude the general Adobe directory as well as the one in Utilities
/usr/bin/find /Applications -name "Adobe *.app" -maxdepth 2 -not -path "/Applications/Adobe/*" -not -path "/Applications/Utilities*" | while read line; do
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
   # Get the version number to avoid any potential duplicates overwriting each other. In all likelihood, the admin running this script will have to rename these icons anyway, and this will allow the script to be run with multiple versions of Adobe CC installed
   versionNumber=$(/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" "$line"/Contents/Info.plist)
   if [ ! -z "$versionNumber" ]; then
      appName+='.'
   fi
   # Create a 350x350 .png of the .icns on the desktop
   /usr/bin/sips -z 350 350 -s format png "$line"/Contents/Resources/"$icnsName" --out ~/Desktop/AdobeIcons/"$appName""$versionNumber".png
done
