#!/bin/bash

   secure="s"
 servhost="pomfe.co"
uploadurl="https://pomfe.co/upload.php"
returnurl="https://a.pomfe.co/"
 
while getopts fsu: option; do
    case $option in
        f)ful=1 opt=1;;
        s)sel=1 opt=1;;
        u)upl=1 opt=1;;
        *)exit
    esac
done
 
file_name_format="Screen Shot %Y-%m-%d at %H.%M.%S.png"
file_dir="$HOME/Pictures/Screenshots"
img_filename="$(date +"$file_name_format")"
img_file="$(date +"$file_dir/$file_name_format")"
icon="$HOME/Applications/pomf/icon.png"
 

if [[ -z $opt ]]; then
    sel=1
fi

if [[ ! -z $ful ]]; then
    screencapture "$img_file"
fi

if [[ ! -z $sel ]]; then
    screencapture -i -o "$img_file"
fi

if [[ ! -z $upl ]]; then
    img_file=$2
fi

clear
echo "Uploading..."

output=$(curl -s -f -F files[]="@$img_file" "$uploadurl")
n=0
 
while [[ $n -le 3 ]]; do

   
    if [[ "${output}" =~ \"success\":true, ]]; then
        pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.*",' | sed 's/"url":"//;s/",//')

        break
    else

        ((n = n +1))
    fi
done
 
 
if [[ ! $pomffile ]]; then
 
    growlnotify --image "$icon" --title "Failed!" --message "Upload cancelled." -w
    echo "oh no :("
    rm "$img_file"
    afplay "/System/Library/Sounds/Basso.aiff"
   
else

    pomffile=$( echo "$pomffile" | grep -Eo "\w+\.png$" )  
    url="$returnurl$pomffile"
 

    echo -n "$url" | pbcopy
 

    echo "${url}" >> ~/ruri.txt
 

    growlnotify --image "$icon" --title "Uploaded!" --message "$url" --url "$url" -w
    clear

 

    afplay "/System/Library/Sounds/Tink.aiff"
 
fi
