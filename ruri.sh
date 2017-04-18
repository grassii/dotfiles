#!/bin/bash

#AUDIO/VIDEO
video=0
audio=2

#FILE HOST
host="pomfe.co"
up_url="https://pomfe.co/upload.php"
down_url="https://a.pomfe.co"



#STANDARD VARS
CAPTURE="$video"
FPS="30"
RES="1920x1080"
#RES2="in 1080p"
#FPS2=" at 30fps"
#SOUND=""


if [[ $# -eq 0 ]] ; then
  echo "Error: add -h for help"
  exit 1
fi

if [[ "$1" == "-h" ]] ; then


  printf "  \033[1;31mUSAGE     ruri [filename] [-args]\033[0m
  --------------------------------
  -s        sound enabled
  -60       60fps (no sound)
  -720p     720p (default: 1080p)
  -c        convert + [filename]\n"
  exit 1
fi

if [ "$1" == "-av" ]; then
  ffmpeg -f avfoundation -list_devices true -i ""


  exit 1
fi


if [ "$2" == "-s" ]; then
  CAPTURE="$video:$audio"
  #details
  #SOUND=" (with sound)"
fi


if [ "$2" == "-60" ]; then
  CAPTURE="0"
  FPS="60"
  #details
  #FPS2=" at 60fps"
fi

if [ "$2" == "-720p" ]; then
  RES="1280x720"
  #details
  #RES2="in 720p"
fi




if [ "$1" == "-c" ]; then

  if [[ $2 -eq 0 ]] ; then
    echo "You need to provide a file first, -h for help"
    exit 1

  fi

  clear

  x="$2"
  y=${x%.mov}

  printf "Converting \033[1;31m$2\033[0m to \033[1;31m$y.webm\033[0m\n"
  printf "Press \033[1;31mQ\033[0m to cancel.\n"
  ffmpeg -loglevel quiet -y -i $2 -vcodec libvpx -b:v 4M -cpu-used -5 -deadline realtime -codec:a vorbis -strict -2 $y.webm

  clear

  printf "Finished converting \033[1;31m$y.webm\033[0m\n"


  printf "Upload to $host?  \033[1;31my/n\033[0m  "
  read -r response
  case "$response" in
    [yY][eE][sS]|[yY])
      clear


      if [[ -n "${2}" ]]; then
        file="$2.webm"
        if [ -f "${file}" ]; then
          printf "Uploading \033[1;31m$1.webm\033[0m to $host\n"
          my_output=$(curl --silent -sf -F files[]="@${file}" "${up_url}")
          n=0  # Multipe tries
          while [[ $n -le 3 ]]; do
            printf "try #${n}..."
            if [[ "${my_output}" =~ '"success":true,' ]]; then
              return_file=$(echo "$my_output" | grep -Eo '"url":"[A-Za-z0-9]+.(png|jpg|bmp|webm)",' | sed 's/"url":"//;s/",//')
              clear
              break
            else
              printf 'failed.\n'
              ((n = n +1))
            fi
          done
          if [[ -n ${return_file} ]]; then

            growlnotify --title "Uploaded!" --message "${down_url}/${return_file}" --url "${down_url}/${return_file}"

            # Write the url to log file
            echo "${down_url}/${return_file}" >> ~/ruri.txt

            echo -n "${down_url}/${return_file}" | pbcopy
            clear


            # Play sound
            afplay "/System/Library/Sounds/Tink.aiff"

          else
            printf 'Error! File not uploaded.\n'
          fi
        else
          printf 'Error! File does not exist!\n'
          exit 1
        fi
      else
        printf 'Error! You must supply a filename to upload!\n'
        exit 1
      fi



      ;;
    *)
      clear
      exit 0
      ;;
  esac

  clear
  exit 1

fi


growlnotify --title "Started Desktop Recording" --message "Press Q to stop"

clear

printf "Recording \033[1;31m$1.mov\033[0m $RES2$FPS2$SOUND\n"
printf "Press \033[1;31mQ\033[0m to stop recording.\n"

ffmpeg -loglevel quiet -video_size $RES -y -r $FPS -f avfoundation -capture_cursor 1 -i "$CAPTURE" Desktop/capture/$1.mov

clear

echo Done recording!
sleep 1

clear

printf "Converting to \033[1;31m$1.webm\033[0m\n"
printf "Press \033[1;31mQ\033[0m to cancel.\n"

ffmpeg -loglevel quiet -y -i Desktop/capture/$1.mov -vcodec libvpx -b:v 4M -cpu-used -5 -deadline realtime -codec:a vorbis -strict -2 Desktop/capture/$1.webm

clear

printf "Finished converting \033[0m\033[1;31m$1.webm\033[0m\n"

rm ~/Desktop/capture/$1.mov

printf "Upload to $host?  \033[1;31my/n\033[0m  "
read -r response
case "$response" in
  [yY][eE][sS]|[yY])
    clear

    if [[ -n "${1}" ]]; then
      file="Desktop/capture/$1.webm"
      if [ -f "${file}" ]; then
        printf "Uploading \033[1;31m$1.webm\033[0m to $host\n"
        my_output=$(curl --silent -sf -F files[]="@${file}" "${up_url}")
        n=0
        while [[ $n -le 3 ]]; do
          printf "try #${n}..."
          if [[ "${my_output}" =~ '"success":true,' ]]; then
            return_file=$(echo "$my_output" | grep -Eo '"url":"[A-Za-z0-9]+.(png|jpg|bmp|webm)",' | sed 's/"url":"//;s/",//')
            clear
            break
          else
            printf 'failed.\n'
            ((n = n +1))
          fi
        done
        if [[ -n ${return_file} ]]; then

          growlnotify --title "Uploaded!" --message "${down_url}/${return_file}" --url "${down_url}/${return_file}"


          echo "${down_url}/${return_file}" >> ~/ruri.txt

          echo -n "${down_url}/${return_file}" | pbcopy

          rm ~/Desktop/capture/$1.webm
          clear





          afplay "/System/Library/Sounds/Tink.aiff"

        else
          printf 'Error! File not uploaded.\n'
        fi
      else
        printf 'Error! File does not exist!\n'
        exit 1
      fi
    else
      printf 'Error! You must supply a filename to upload!\n'
      exit 1
    fi

    ;;
  *)
    clear
    exit 0
    ;;
esac

clear