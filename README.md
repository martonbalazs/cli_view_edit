cli_view_edit
=============

CLI scripts to help editing, viewing and printing many filetypes. Incl a
Spritz-like CLI reader too.

- lapdf [file] is just short for latex then dvipdf a file.

- nonascii [file] shows non-ascii characters in your file. They can be quite
  annoying sometimes.

- prevlpr [file] is a command-line utility for postscript printing documents.
  It tries to convert various file formats (including pdf, txt, office
  documents, latex, html) into ps, shows it, and asks for printing options. Can
  do, in principle, one- or two-sided printing on suitable printers, or can
  cooperate with manually (re-)feeding a printer so that the result is two-sided
  (credits partially go to Imre Péter Tóth). If psbind
  (http://freecode.com/projects/psbind) is installed then it applies psbind with
  a push of a button. The printer can be specified in the file
  ~/.prevlpr_printer.txt .

- rbyw (Read By Word) is yet another Spritz-like reader
  (http://www.spritzinc.com/). With rbyw [file] it reads text files, and also
  tries to convert many other formats to plain text before reading. Uses
  html2text, pdftotext, catdoc, docx2txt
  (http://docx2txt.cvs.sourceforge.net/docx2txt/) for this, they need to be
  installed for the corresponding file format. Requires gawk for proper utf
  handling, plain awk doesn't do it right. Can also read from the www if used as
  rbyw [url]. Comfortably adjust speed while playing with "." or "6" and "," or
  "4"; fast forward with "t" or "8"; pause with [space] or "0", and then roll
  back and forward one word "b" or "1" and "f" or "3" or 100 words "B" or "7" and
  "F" or "9". A bar shows you where you are in the file. "q" quits at any time.
  Credits go to Ferenc Wettl for making it nicer-looking.

- szerk [file(s)] or [part(s) of filename(s)] opens any matching files from the
  current directory for editing, maybe several at a time. Handles many formats
  according their file extensions. Editing and compiling (latex) is done in a new
  directory in ~/tmp, hence no mess is left behind. Opens appropriate file viewer
  as well (e.g. evince for compiled latex files, or firefox for viewing html).
  For latex files an auxiliary file is created (and not saved!!!) if
  %szerkbodystart and %szerkbodyend are found as separate lines, handy for
  editing long presentations (don't need to compile every slide every time).

- sszerk is very similar except it opens two pdf's for latex files which makes it
  nicer to edit complicated documents.

- v [file(s)] or [part(s) of filename(s)] opens any matching files from the
  current directory for viewing. Latex files are compiled in /tmp/ (no mess is
  left behind) and pdf is shown.

- vcl is very similar, it also copies full filename into xclipboard, useful if
  we want to make a notice of the file.

I'm no programmer, so please don't blame me on the quality of the code. :-)
Licensed under GNU GPLv3.
