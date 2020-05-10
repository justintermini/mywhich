#!/bin/bash
# mywhich: finds a file in the PATH, determines if it is
#  executable or not
#
# Justin Termini
# Shell Scripting 061
# 10/16/2019

FINDALL=FALSE

 # Use case menu to determine if FINDALL will be used
case $1 in
  -a) FINDALL=TRUE
      shift     # throwaway this argument
      ;;
  -h) echo "Usage: $0 [-a] commands..."
      exit 0
      ;;
   *) FINDALL=FALSE
      # done processing the options
      ;;
esac

for command in "$@"
do
  # Process the PATH and make each piece of the PATH be
  #  a positional parameter.

  IFS=$OLDIFS # Save IFS as OLDIFS
  IFS=:
  set -- $PATH
  IFS=$OLDIFS # Reset IDFS as OLDIFS

  # Determines if the command is a /command/; if so, echo it
  #  if not, check the PATH
  case $command in
   */*) if [ ! -d "$command" -a -x "$command" ] ; then
        echo "$command"
        else
        echo "$command not found"
        shift
        fi
        ;;
     *) FOUND=false
         case $PATH in
                :*) PATH=".:$PATH"                              ;;
              *::*) PATH=`echo $PATH | sed -e 's/::/:.:/g'`     ;;
                *:) PATH="$PATH:."                              ;;
         esac

        for P
        do
          if [ ! -d "$P/$command" -a -x "$P/$command" ] ; then
             FOUND=true
             echo "$P/$command"
             if [ "$FINDALL" = FALSE ] ; then # if FINDALL is false then exit loop here
                 break
             fi
          else
             FOUND=false
          fi
        done
        shift
        ;;
  esac
if [ "$FOUND" = false ] ; then
  echo "$command not found"
fi
done

