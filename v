#!/bin/bash
# 2015.04.25
# Usage: v [any number of strings]
# opens all files (of types below) that have any of the strings in their names

for j in "$@"
do
 for i in *$j*
 do
 
 # veg=`echo "$i"|awk -F\. '{ printf($NF) }'`
 # elej=`echo "$i"|awk -F\. '{ for (i=1; i<NF; i+=1) printf($i"."); printf("") }'`
 
 # Bash parameter expansion
 veg=${i##*.}
 elej=${i%.*}
 
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
   cp *.eps /tmp/$k
   cp *.clo /tmp/$k
   cp *.cls /tmp/$k
   cp *.bst /tmp/$k
   cp *.sty /tmp/$k
   catthatfile "/tmp/$k" "$i" &
   cd /tmp/$k
   latex -interaction=nonstopmode "$i"
   
   cd -
   if [[ -f "$elej".bbl ]]
   then
    cp "$elej".bbl /tmp/$k
    cd /tmp/$k
   else
    cd /tmp/$k
    bibtex "$elej".aux
   fi
 
   makeindex "$elej"

   latex -interaction=nonstopmode "$i"
 
   latex -interaction=nonstopmode "$i"
   
   dvipdf "$elej".dvi
 
   evince "$elej".pdf
   
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
 
 done
done
