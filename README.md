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
  (credits partially go to Imre Péter Tóth). Also prepared for producing a pdf
  for email-printing. If psbind (http://freecode.com/projects/psbind) is
  installed then it applies psbind with a push of a button. The printer can be
  specified in the file ~/.prevlpr_printer.txt . It can handle a particular
  boolean LaTeX switch of the type "setbool{solu}{true}" or
  "setbool{solu}{false}" which I use for solutions on or off in problem sheets or
  exams (notice this won't work with dos-type linebreaks).

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
  as well (e.g. zathura for compiled latex files, or firefox for viewing html).
  For latex files an auxiliary file is created (and not saved!!!) if
  %szerkbodystart and %szerkbodyend are found as separate lines, handy for
  editing long presentations (don't need to compile every slide every time).

- sszerk is very similar except it opens two pdf's for latex files which makes it
  nicer to edit complicated documents.

- refszerk comes handy when you need to report on a document. Just add the
  document's filename as parameter.

- v [file(s)] or [part(s) of filename(s)] opens any matching files from the
  current directory for viewing. Latex files are compiled in /tmp/ (no mess is
  left behind) and pdf is shown. It can handle a particular boolean LaTeX switch
  of the type "setbool{solu}{true}" or "setbool{solu}{false}" which I use for
  solutions on or off in problem sheets or exams (notice this won't work with
  dos-type linebreaks).

- vcl is very similar, it also copies full filename into xclipboard, useful if
  we want to make a notice of the file.

- lo, lo2e, lowo, slo, svlo (Lots of documents Opener): these form a document
  or webpage viewing queue system, they use "silent_cpucsekk" from my other
  repo "cli_util". Script "slo" is the server, could be launched from your
  startup sequence. It waits for your system load to settle, then opens the next
  document or webpage in the queue, stored in ~/.slo/2p.txt. "svlo" does the
  actual opening (invokes "v" above for most file types). Scripts "lo", "lo2e"
  and "lowo" feed the queue: "lo/lo2e [url or (parts of) filename(s)]" just adds
  the stuff specified in its argument, while "lowo [filename]" goes through the
  file specified in your ~/.lowo folder and opens webpages in there one by one.
  Great for going through routine webpages (like news, Facebook, etc) or through
  a saved list of urls from a long day. See the script for more details.

- wothin (webpage opener thinner) is an additional layer to lowo et al. It
  reads a [file].txt in ~/.lowo/wothin/ that has lines like

```
lista 2
listb 3
listc 7
```

  where lista.txt, listb.txt and listc.txt are lists in ~/.lowo with webpage
  urls. Use as wothin [file]. The idea is that one might want to see every item
  in the file lista.txt once in two days, in listb.txt once in three days, and in
  listc.txt weekly. However, if e.g. listc has 21 urls, these shouldn't pour at
  one as 21 webpages all at once every Sunday, rather they should be evenly
  distributed in groups of 3 throughout a week. This is what wothin [file] will
  automatically do if run once a day. It prepares the thinned list for the day,
  then feeds it into lowo.

- catthatfile is just a small utility that is used by some of the above. It
  pings the original file every 30 seconds until the copy is being looked at.
  This makes sure that the filesystem under the original doesn't umount due to
  timeout (encfs can do that for example).

I'm no programmer, so please don't blame me on the quality of the code. :-)
Licensed under GNU GPLv3.
