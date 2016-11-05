#!/bin/bash
# 2016-03-05
# Usage: v [any number of strings]
# opens all files (of types below) that have any of the strings in their names
# Needs xclip and then copies full filename into xclipboard too.

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
   k=v3$elej`date +%N`
   mkdir /tmp/$k
   chmod 700 /tmp/$k/
 
   cp "$i" /tmp/$k
   catthatfile "/tmp/$k" "$i" &
   cd /tmp/$k
   evince "$i"
   
   cd -
 
   l=1
   while [ -n "$l" ]; do
    sleep 1
    l=`lsof +d /tmp/$k`
   done
 
   rm -f -R /tmp/$k
  fi
 
  if [[ "$veg" == "dvi" ]]
  then
   xdvi "$i"
  fi
 
  if [[ "$veg" == "htm" ]] || [[ "$veg" == "html" ]] || [[ "$veg" == "wml" ]]
  then
   firefox "$i" &
  fi
 
  if [[ "$veg" == "jpg" ]] || [[ "$veg" == "JPG" ]] || [[ "$veg" == "jpeg" ]] || [[ "$veg" == "JPEG" ]] || [[ "$veg" == "gif" ]] || [[ "$veg" == "GIF" ]] || [[ "$veg" == "png" ]] || [[ "$veg" == "PNG" ]]
  then
   eog "$i"
  fi
 
  if [[ "$veg" == "MOV" ]] || [[ "$veg" == "mov" ]] || [[ "$veg" == "wmv" ]] || [[ "$veg" == "WMV" ]] || [[ "$veg" == "wma" ]] || [[ "$veg" == "WMA" ]] || [[ "$veg" == "avi" ]] || [[ "$veg" == "AVI" ]] || [[ "$veg" == "mpg" ]] || [[ "$veg" == "mpeg" ]] || [[ "$veg" == "MPG" ]] || [[ "$veg" == "MPEG" ]] || [[ "$veg" == "mp3" ]] || [[ "$veg" == "MP3" ]] || [[ "$veg" == "ram" ]] || [[ "$veg" == "RAM" ]] || [[ "$veg" == "rm" ]] || [[ "$veg" == "RM" ]] || [[ "$veg" == "ogg" ]] || [[ "$veg" == "OGG" ]]
  then
   mplayer "$i"
  fi
 
  if [[ "$veg" == "lev" ]] || [[ "$veg" == "txt" ]] || [[ "$veg" == "org" ]] || [[ "$i" != *.* ]]
  then
   vim "+noremap q :q<CR>" "+noremap <Space> <PageDown>" -p -M -R "$i"
  fi
 
  if [[ "$veg" == "tex" ]] || [[ "$veg" == "ltx" ]]
  then
   k=v3$elej`date +%N`
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
   catthatfile "/tmp/$k" "$i" &
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

   if [ "$solutions" -eq "1" ]
   then
    mv nosol_"$i" "$i"
   fi

   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -eq "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi
   
   cd -
   if [[ -f "$elej".bbl ]]
   then
    cp "$elej".bbl /tmp/$k
    cd /tmp/$k
    if [ "$solutions" -eq "1" ]
    then
     cp "$elej".bbl sol_"$elej".bbl
    fi
   else
    cd /tmp/$k
    bibtex "$elej".aux
    if [ "$solutions" -eq "1" ]
    then
     bibtex sol_"$elej".aux
    fi
   fi
 
   makeindex "$elej"
   if [ "$solutions" -eq "1" ]
   then
    makeindex sol_"$elej"
   fi

   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -eq "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi

   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -eq "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi
 
   latex -interaction=nonstopmode "$i"
   if [ "$solutions" -eq "1" ]
   then
    latex -interaction=nonstopmode "sol_$i"
   fi
   
   dvipdf "$elej".dvi
   if [ "$solutions" -eq "1" ]
   then
    dvipdf sol_"$elej".dvi
   fi
 
   if [ "$solutions" -eq "1" ]
   then
    read -p "Change xclip to [n] no solution, [s] to solution, or keep source?
    " wxcl
    if [ "$wxcl" == "n" ]
    then
     filen=`basename "$elej".pdf`
     echo "Copied to clipboard: `pwd`/$filen"
     echo -n "`pwd`/$filen"|xclip
    elif [ "$wxcl" == "s" ]
    then
     filen=`basename sol_"$elej".pdf`
     echo "Copied to clipboard: `pwd`/$filen"
     echo -n "`pwd`/$filen"|xclip
    fi
    evince "$elej".pdf sol_"$elej".pdf
   else
    read -p "Change xclip to pdf? y
    " wxcl
    if [ "$wxcl" == "y" ]
    then
     filen=`basename "$elej".pdf`
     echo "Copied to clipboard: `pwd`/$filen"
     echo -n "`pwd`/$filen"|xclip
    fi
    evince "$elej".pdf
   fi

   cd -
 
   l=1
   while [ -n "$l" ]; do
    sleep 1
    l=`lsof +d /tmp/$k`
   done
 
   rm -f -R /tmp/$k
  fi
 
 
  if [[ "$veg" == "zhk" ]]
  then
   k=v3$elej`date +%N`
   mkdir /tmp/$k
   chmod 700 /tmp/$k/
 
   cp "$i" /tmp/$k
   cp "$elej.kov" /tmp/$k
   cp "$elej.knv" /tmp/$k
   catthatfile "/tmp/$k" "$i" &
   cd /tmp/$k
 
   zh "$elej"
   
   firefox "$elej".html &
   
   gnome-terminal --working-directory=/tmp/$k/
 
   cd -
 
   l=1
   while [ -n "$l" ]; do
    sleep 1
    l=`lsof +d /tmp/$k`
   done
 
   rm -f -R /tmp/$k
  fi

  if [[ "$veg" == "MP4" ]]
  then
   parole "$i"
   ls -All -h "$i"
   read -n1 -s
  fi
 
 done
done
