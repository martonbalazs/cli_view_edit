#!/bin/bash
# Usage: v [any number of strings]
# opens all files (of types below) that have any of the strings in their names
# Needs xclip and then copies full filename into xclipboard too.
# notice: mybr is a script in your path for launching your favourite browser. Could as well replace by e.g. "firefox" or "chromium-browser".

command -v xclip > /dev/null 2>&1
if [ "$?" -ne "0" ]; then
 echo "I need xclip but I can't find it."
 exit
fi

for j in "$@"
do
 for i in *$j*
 do
 
 # veg=`echo "$i"|awk -F\. '{ printf($NF) }'`
 # elej=`echo "$i"|awk -F\. '{ for (i=1; i<NF; i+=1) printf($i"."); printf("") }'`
 
 # Bash parameter expansion
 veg=${i##*.}
 elej=${i%.*}

 filen=`basename "$i"`
 echo "Copied to clipboard: `pwd`/$filen"
 echo -n "`pwd`/$filen"|xclip

 echo "[Enter] to copy filename only to clipboard"
 read -n1 -s
  
 echo "Copied to clipboard: $filen"
 echo -n "$filen"|xclip
 
  if [[ "$veg" == "doc" ]] || [[ "$veg" == "docx" ]] || [[ "$veg" == "rtf" ]] || [[ "$veg" == "ods" ]] || [[ "$veg" == "odt" ]] || [[ "$veg" == "xls" ]] || [[ "$veg" == "xlsx" ]] || [[ "$veg" == "xlsm" ]] || [[ "$veg" == "ppt" ]] || [[ "$veg" == "pptx" ]] || [[ "$veg" == "pps" ]] || [[ "$veg" == "csv" ]]
  then
   libreoffice -view "$i"
  fi
 
  if [[ "$veg" == "ps" ]] || [[ "$veg" == "eps" ]]
  then
   gv "$i"
  fi

# Evince cannot open a file twice, that's why: 
  if [[ "$veg" == "pdf" ]] || [[ "$veg" == "PDF" ]] || [[ "$veg" == "fdf" ]] || [[ "$veg" == "djvu" ]] || [[ "$veg" == "tif" ]] || [[ "$veg" == "TIF" ]]
  then
   #k=v3$elej`date +%N`
   k=v3$elej`date +%y%m%d_%H%M%S`_`strings /dev/urandom | tr -dc a-z-0-9 | tr -d - | head -c5`
   mkdir /tmp/$k
   chmod 700 /tmp/$k/
 
   cp "$i" /tmp/$k
   #catthatfile "/tmp/$k" "$i" &
   cd /tmp/$k
   zathura "$i"
   #evince "$i"
   #xpdf "$i"
   
   cd -
 
   l=1
   while [ -n "$l" ]; do
    sleep 1
    l=`lsof 2>/dev/null +d /tmp/$k`
   done
 
   #rm -f -R /tmp/$k
  fi
 
  if [[ "$veg" == "dvi" ]]
  then
   xdvi "$i"
  fi
 
  if [[ "$veg" == "htm" ]] || [[ "$veg" == "html" ]] || [[ "$veg" == "wml" ]]
  then
# notice: mybr is a script in your path for launching your favourite browser. Could as well replace by e.g. "firefox" or "chromium-browser".
   mybr "$i" &
  fi
 
  if [[ "$veg" == "jpg" ]] || [[ "$veg" == "JPG" ]] || [[ "$veg" == "jpeg" ]] || [[ "$veg" == "JPEG" ]] || [[ "$veg" == "gif" ]] || [[ "$veg" == "GIF" ]] || [[ "$veg" == "png" ]] || [[ "$veg" == "PNG" ]]
  then
   eog "$i"
  fi
 
  if [[ "$veg" == "MOV" ]] || [[ "$veg" == "mov" ]] || [[ "$veg" == "wmv" ]] || [[ "$veg" == "WMV" ]] || [[ "$veg" == "wma" ]] || [[ "$veg" == "WMA" ]] || [[ "$veg" == "avi" ]] || [[ "$veg" == "AVI" ]] || [[ "$veg" == "mpg" ]] || [[ "$veg" == "mpeg" ]] || [[ "$veg" == "MPG" ]] || [[ "$veg" == "MPEG" ]] || [[ "$veg" == "mp3" ]] || [[ "$veg" == "MP3" ]] || [[ "$veg" == "ram" ]] || [[ "$veg" == "RAM" ]] || [[ "$veg" == "rm" ]] || [[ "$veg" == "RM" ]] || [[ "$veg" == "ogg" ]] || [[ "$veg" == "OGG" ]] || [[ "$veg" == "mp4" ]] || [[ "$veg" == "MP4" ]]
  then
   #urxvt -e mplayer "$i"
   urxvt -e pausedmplayer "$i"
  fi
 
  if [[ "$veg" == "lev" ]] || [[ "$veg" == "txt" ]] || [[ "$veg" == "log" ]] || [[ "$veg" == "org" ]] || [[ "$i" != *.* ]]
  #if [[ "$veg" == "lev" ]] || [[ "$veg" == "txt" ]] || [[ "$veg" == "log" ]] || [[ "$i" != *.* ]]
  then
   vim "+noremap q :q<CR>" "+noremap <Space> <PageDown>" -p -M -R "$i"
  fi

#  if [[ "$veg" == "org" ]]
#  then
#   emacs "$i" --eval '(setq buffer-read-only t)'
#  fi
 
  if [[ "$veg" == "tex" ]] || [[ "$veg" == "ltx" ]]
  then
   #k=v3$elej`date +%N`
   k=v3$elej`date +%y%m%d_%H%M%S`_`strings /dev/urandom | tr -dc a-z-0-9 | tr -d - | head -c5`
   mkdir /tmp/$k
   chmod 700 /tmp/$k/
 
   cp "$i" /tmp/$k
   cp *.bib /tmp/$k
   cp *.pdf /tmp/$k
   cp *.png /tmp/$k
   cp *.eps /tmp/$k
   cp *.epsi /tmp/$k
   cp *.ps /tmp/$k
   cp *.clo /tmp/$k
   cp *.cls /tmp/$k
   cp *.bst /tmp/$k
   cp *.sty /tmp/$k
   #catthatfile "/tmp/$k" "$i" &
   cd /tmp/$k

# Do we have solutions?
   solutions=0
   if grep -q "setbool{solu}{true}" "$i"
   then
    solutions=1
   fi

   if grep -q "setbool{solu}{false}" "$i"
   then
    solutions=1
   fi

   if grep -q "setbool{fullsolu}{true}" "$i"
   then
    solutions=2
   fi

   if grep -q "setbool{fullsolu}{false}" "$i"
   then
    solutions=2
   fi

   if [ "$solutions" -eq "1" ]
   then
    cat $i |
    awk ' BEGIN{ 
     soldone=0
    }
    {
     if ($0=="\%\\setbool{solu}{true}" || $0=="\\setbool{solu}{true}" || $0=="\%\\setbool{solu}{false}" || $0=="\\setbool{solu}{false}") {
      if (soldone==0) {
       print("\\setbool{solu}{true}");
       soldone=1
      };
     }
     else {
      print($0)
     };
    }' > sol_"$i"

    cat $i |
    awk ' BEGIN{ 
     soldone=0
    }
    {
     if ($0=="\%\\setbool{solu}{true}" || $0=="\\setbool{solu}{true}" || $0=="\%\\setbool{solu}{false}" || $0=="\\setbool{solu}{false}") {
      if (soldone==0) {
       print("\\setbool{solu}{false}");
       soldone=1
      };
     }
     else {
      print($0)
     };
    }' > nosol_"$i"
   fi

   if [ "$solutions" -eq "2" ]
   then
    cat $i |
    awk ' BEGIN{ 
     soldone=0
     fullsoldone=0
    }
    {
     if ($0=="\%\\setbool{solu}{true}" || $0=="\\setbool{solu}{true}" || $0=="\%\\setbool{solu}{false}" || $0=="\\setbool{solu}{false}") {
      if (soldone==0) {
       print("\\setbool{solu}{true}");
       soldone=1
      };
     }
     else if ($0=="\%\\setbool{fullsolu}{true}" || $0=="\\setbool{fullsolu}{true}" || $0=="\%\\setbool{fullsolu}{false}" || $0=="\\setbool{fullsolu}{false}") {
      if (fullsoldone==0) {
       print("\\setbool{fullsolu}{false}");
       fullsoldone=1
      };
     }
     else {
      print($0)
     };
    }' > sol_"$i"

    cat $i |
    awk ' BEGIN{ 
     soldone=0
     fullsoldone=0
    }
    {
     if ($0=="\%\\setbool{solu}{true}" || $0=="\\setbool{solu}{true}" || $0=="\%\\setbool{solu}{false}" || $0=="\\setbool{solu}{false}") {
      if (soldone==0) {
       print("\\setbool{solu}{false}");
       soldone=1
      };
     }
     else if ($0=="\%\\setbool{fullsolu}{true}" || $0=="\\setbool{fullsolu}{true}" || $0=="\%\\setbool{fullsolu}{false}" || $0=="\\setbool{fullsolu}{false}") {
      if (fullsoldone==0) {
       print("\\setbool{fullsolu}{false}");
       fullsoldone=1
      };
     }
     else {
      print($0)
     };
    }' > nosol_"$i"

    cat $i |
    awk ' BEGIN{ 
     soldone=0
     fullsoldone=0
    }
    {
     if ($0=="\%\\setbool{solu}{true}" || $0=="\\setbool{solu}{true}" || $0=="\%\\setbool{solu}{false}" || $0=="\\setbool{solu}{false}") {
      if (soldone==0) {
       print("\\setbool{solu}{true}");
       soldone=1
      };
     }
     else if ($0=="\%\\setbool{fullsolu}{true}" || $0=="\\setbool{fullsolu}{true}" || $0=="\%\\setbool{fullsolu}{false}" || $0=="\\setbool{fullsolu}{false}") {
      if (fullsoldone==0) {
       print("\\setbool{fullsolu}{true}");
       fullsoldone=1
      };
     }
     else {
      print($0)
     };
    }' > fullsol_"$i"
   fi


   if [ "$solutions" -ge "1" ]
   then
    mv nosol_"$i" "$i"
   fi

   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -ge "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi
   if [ "$solutions" == "2" ]
   then
    latex -interaction=nonstopmode "fullsol_$i"
   fi
   
   cd -
   if [[ -f "$elej".bbl ]]
   then
    cp "$elej".bbl /tmp/$k
    cd /tmp/$k
    if [ "$solutions" -ge "1" ]
    then
     cp "$elej".bbl sol_"$elej".bbl
    fi
    if [ "$solutions" == "2" ]
    then
     cp "$elej".bbl fullsol_"$elej".bbl
    fi
   else
    cd /tmp/$k
    if grep -q "bibliography{" "$elej".tex; then
     bibtex "$elej".aux
     if [ "$solutions" -ge "1" ]
     then
      bibtex sol_"$elej".aux
     fi
     if [ "$solutions" == "2" ]
     then
      bibtex fullsol_"$elej".aux
     fi
    fi
    if grep -q "addbibresource{" "$elej".tex; then
     biber "$elej"
     if [ "$wehavetest" -eq "1" ]
     then
      biber 2del_"$elej"
     fi
    fi
   fi
 
   makeindex "$elej"
   if [ "$solutions" -ge "1" ]
   then
    makeindex sol_"$elej"
   fi
   if [ "$solutions" == "2" ]
   then
    makeindex fullsol_"$elej"
   fi

   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -ge "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi
   if [ "$solutions" == "2" ]
   then
    latex -interaction=nonstopmode "fullsol_$i"
   fi

   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -ge "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi
   if [ "$solutions" == "2" ]
   then
    latex -interaction=nonstopmode "fullsol_$i"
   fi
 
   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -ge "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi
   if [ "$solutions" -eq "2" ]
   then
    latex -interaction=nonstopmode "fullsol_$i"
   fi
   
   #dvipdf "$elej".dvi
   #dvipdfm "$elej".dvi
   dvips "$elej".dvi
   ps2pdf -dALLOWPSTRANSPARENCY "$elej".ps
   if [ "$solutions" -ge "1" ]
   then
    #dvipdf sol_"$elej".dvi
    #dvipdfm sol_"$elej".dvi
    dvips sol_"$elej".dvi
    ps2pdf -dALLOWPSTRANSPARENCY sol_"$elej".ps
   fi
   if [ "$solutions" == "2" ]
   then
    dvips fullsol_"$elej".dvi
    ps2pdf -dALLOWPSTRANSPARENCY fullsol_"$elej".ps
   fi
 
   if [ "$solutions" -ge "1" ]
   then
    if [ "$solutions" == "1" ]
    then
     read -p "Change xclip to [n] no solution, [s] to solution, or keep source?
     " wxcl
    fi
    if [ "$solutions" == "2" ]
    then
     read -p "Change xclip to [n] no solution, [s] to solution, [f] full solution, or keep source?
     " wxcl
    fi
    if [ "$wxcl" == "n" ]
    then
     filen=`basename "$elej".pdf`
     echo "Copied to clipboard: `pwd`/$filen"
     echo -n "`pwd`/$filen"|xclip

     echo "[Enter] to copy filename only to clipboard"
     read -n1 -s
      
     echo "Copied to clipboard: $filen"
     echo -n "$filen"|xclip
    elif [ "$wxcl" == "s" ]
    then
     filen=`basename sol_"$elej".pdf`
     echo "Copied to clipboard: `pwd`/$filen"
     echo -n "`pwd`/$filen"|xclip

     echo "[Enter] to copy filename only to clipboard"
     read -n1 -s
      
     echo "Copied to clipboard: $filen"
     echo -n "$filen"|xclip
    elif [ "$wxcl" == "f" ]
    then
     filen=`basename fullsol_"$elej".pdf`
     echo "Copied to clipboard: `pwd`/$filen"
     echo -n "`pwd`/$filen"|xclip

     echo "[Enter] to copy filename only to clipboard"
     read -n1 -s
      
     echo "Copied to clipboard: $filen"
     echo -n "$filen"|xclip
    fi
    if [[ "$solutions" == "2" ]]
    then
     zathura "$elej".pdf sol_"$elej".pdf fullsol_"$elej".pdf
    else
     zathura "$elej".pdf sol_"$elej".pdf
     #evince "$elej".pdf sol_"$elej".pdf
     #xpdf "$elej".pdf sol_"$elej".pdf
    fi
   else
    read -p "Change xclip to pdf? y
    " wxcl
    if [ "$wxcl" == "y" ]
    then
     filen=`basename "$elej".pdf`
     echo "Copied to clipboard: `pwd`/$filen"
     echo -n "`pwd`/$filen"|xclip

     echo "[Enter] to copy filename only to clipboard"
     read -n1 -s
      
     echo "Copied to clipboard: $filen"
     echo -n "$filen"|xclip
    fi
    zathura "$elej".pdf
    #evince "$elej".pdf
    #xpdf "$elej".pdf
   fi

   cd -
 
   l=1
   while [ -n "$l" ]; do
    sleep 1
    l=`lsof 2>/dev/null +d /tmp/$k`
   done
 
   #rm -f -R /tmp/$k
  fi
 
 
  if [[ "$veg" == "zhk" ]]
  then
   #k=v3$elej`date +%N`
   k=v3$elej`date +%y%m%d_%H%M%S`_`strings /dev/urandom | tr -dc a-z-0-9 | tr -d - | head -c5`
   mkdir /tmp/$k
   chmod 700 /tmp/$k/
 
   cp "$i" /tmp/$k
   cp "$elej.kov" /tmp/$k
   cp "$elej.knv" /tmp/$k
   #catthatfile "/tmp/$k" "$i" &
   cd /tmp/$k
 
   zh "$elej"
   
# notice: mybr is a script in your path for launching your favourite browser.
   mybr "$elej".html &
   
   #gnome-terminal --working-directory=/tmp/$k/
   urxvt -cd /tmp/$k/
 
   cd -
 
   l=1
   while [ -n "$l" ]; do
    sleep 1
    l=`lsof 2>/dev/null +d /tmp/$k`
   done
 
   #rm -f -R /tmp/$k
  fi

  if [[ "$veg" == "MP4" ]]
  then
   parole "$i"
   ls -All -h "$i"
   read -n1 -s
  fi
 
 done
done
