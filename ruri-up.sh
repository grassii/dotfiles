
host="pomfe.co"
up_url="https://pomfe.co/upload.php"
down_url="https://a.pomfe.co"



      if [[ -n "${1}" ]]; then
        file="$1"
        if [ -f "${file}" ]; then
          printf "Uploading \033[1;31m$1\033[0m to $host\n"
          my_output=$(curl --silent -sf -F files[]="@${file}" "${up_url}")
          n=0  
          while [[ $n -le 3 ]]; do
            printf "try #${n}..."
            if [[ "${my_output}" =~ '"success":true,' ]]; then
              return_file=$(echo "$my_output" | grep -Eo '"url":"[A-Za-z0-9]+.(mp3|wav|ogg|png|jpg|bmp|webm|gif|mov|mp4|txt|sh|md|zip|rar)",' | sed 's/"url":"//;s/",//')
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
        printf 'Usage: up [filename]\n'
        exit 1
      fi

