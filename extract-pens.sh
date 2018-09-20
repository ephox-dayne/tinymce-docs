#! /bin/sh

find . -name \*.md -or -name \*.html | while read filename; do

  cat $filename | grep "codepen.html" | sed -E 's/.*id=\"([0-9a-zA-Z]+)\"+.*/\1/g' | while read penid; do
    echo $filename,$penid
  done
done

