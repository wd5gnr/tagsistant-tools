#!/bin/bash

if [ `basename "$0"` == untag ]
then 
  NEG=1
else
  NEG=0
fi


# Al Williams al.williams@awce.com

# tag is a bash script to work with tagsistant (www.tagsistant.net)
#
# Copyright (C) 2014 Al Williams (al.williams@awce.com)
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.


# Just for fun, handle long options

# First get the arguments in an arry
args=( "$@" )
# Now list all long options next to their short equivalents
# The first argument will be used for anything that
# doesn't match that is an -- option
# so it should probably be help

# Note that -- will stop scanning arguments

long_args=( --help -h --tag-root -r --dry-run -d --move -m --no-new-tag -n  --tag -t )

# for each argument until ""
I=0
while [ ! -z "${args[$I]}" ]
  do
    parm="${args[$I]}"
# don't do anyting if does not start with --
    if [ "${parm:0:2}" != "--" ] 
    then 
	I=$((I+1))
	continue
    fi
# check for end of long arguments
    if [ "$parm" == "--" ]
    then
# delete -- and stop processing -- arguments
	args=( "${args[@]:0:$I}" "${args[@]:$((I+1))}" )
	break
    fi 
# For each long_arg (until "")
    larg=${long_args[0]}
    J=0
    lfound=0
    while [ ! -z "$larg" ]
    do
	if [ "$larg" == "$parm" ]
	  then
# found it so substitute
	  lfound=1
          args[$I]=${long_args[$((J+1))]}
	  break  # done with this loop
	fi 
# skip to next long name
	J=$((J+2))
	larg=${long_args[$J]}
    done

    if [ "$lfound" == 0 ]
      then 
# didn't find long option so use first (presumably --help)      
	args[$I]=${long_args[1]}
      fi 

# Next parameter
    I=$(( I + 1 ))
done

# Ok all long arguments converted so put them back
set -- "${args[@]}"



# process options
if [ -z "$TAGROOT" ]
then 
  TAGROOT=~/files
fi
DRYRUN=0
NONEWTAG=0
COPY=cp
TAGLIST=

function v { true 
}

while getopts hr:t:dnvD arg
do
    case $arg in
	
      t)
	    if [ -z "$TAGLIST" ]
	    then TAGLIST="$OPTARG"
	    else TAGLIST="$TAGLIST/$OPTARG"
	    fi
	    NONEWTAG=1
;;

      m)
         COPY=mv
;;
      D)  
      	    set -x
;;
      r)
	    TAGROOT="$OPTARG"
;;
      d)
	    DRYRUN=1
	    echo Dry run mode selected
;;
      n)
	    NONEWTAG=1
;;
      v)
         function v { 
	     echo $@ 
	 }
;;
      h|\?|:)
	  >&2  cat <<EOF
tag is a bash script to work with tagsistant (http://www.tagsistant.net)

Version 1.0 13 Nov 2014
Copyright (C) 2014 Al Williams (al.williams@awce.com)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

tag by Al Williams (al.williams@awce.com)
Usage:
tag [-r tag_root_directory] [-h] [-d] [-m] [-n] [-v] tag file [file...]
or
tag [-r tag_root_directory] [-h] [-d] [-m] [-n] [-v] -t tag file [file...]

If the tag starts with an @ it will be removed. That is:
  tag foo myfile.txt

Tags myfile.txt with foo, but:
  tag @foo myfile.txt

Removes the tag. This is not allowed with the -t option

-r (--tag-root) Sets the target directory
-t (--tag) Add tag (must exist; multiple -t options allowed and encouraged)
-h (--help) Shows this message (or any bad option)
-m (--move) Moves files from external file system instead of copies
   (Tagging an already tagged file always uses move and preserves tags)
-n (--no-new-tag) Prevents creating new tags (always set if using -t)
-v Verbose mode (for debugging)
-d (--dry-run) Don't actually do anything, just print what would happen

Note: calling the script as untag (via a link, for example) always
treats the tag as @tag unless called as untag

Home: https://github.com/wd5gnr/tagsistant-tools

EOF
    exit 1
;;
    esac
done

shift $((OPTIND-1))


if [ "$DRYRUN" == 0 ]
then
  ECHO=
else
  ECHO=echo
fi

if [ $# == 0 ]
then
  echo Usage:
  echo tag [-r tag_root_directory] [-h] [-d] [-n] [-v] [-t] tag file [file...]  
  echo tag -h for more info
  exit 1
fi
if [ -z "$TAGLIST" ]
then 
  TAG="$1"
  shift
  # test for negative tag
  if [ ${TAG:0:1} = '@' ]
  then
    NEG=1
    TAG=${TAG:1}
  fi
else
  TAG="$TAGLIST"
fi
if [ $NEG == 0 -a $NONEWTAG == 0 ]
then
  if [ ! -d "$TAGROOT/tags/$TAG" ]
    then
    $ECHO mkdir "$TAGROOT/tags/$TAG"
   fi
fi
while [ $# != 0 ]
do 
  if [ ! -f "$1" ]
  then
    echo File $1 not found
    exit 2
  fi
  if [ -f "$1.tags" ] 
  then
    if [ $NEG == 0 ]
    then
       CTAGS=`cat "$1.tags" | awk ' { printf "%s", $0 "/" } '`
       $ECHO mv "$1" "$TAGROOT/store/$CTAGS$TAG/@@"
    else
       if grep -q "$TAG" "$1.tags"
       then
         FN=`basename "$1"`
         $ECHO rm "$TAGROOT/store/$TAG/@@/$FN"  
       else
         echo $1 is not tagged with $TAG
       fi
    fi
  else
    if [ $NEG == 0 ]
    then
      $ECHO $COPY "$1" "$TAGROOT/store/$TAG/@@"
    else
      echo $1 does not contain tags
    fi
  fi
  shift
done
exit 0
