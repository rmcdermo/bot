#!/bin/bash
FROM_DIR=$1
FROM_FILE=$2
RELEASEBUNDLEDIR=$3
RELEASEBRANCH=$4
GH_OWNER_ARG=$5
GH_REPO_ARG=$6

if [ ! -e $HOME/$FROM_DIR/$FROM_FILE ] ; then
  echo "***error: $FROM_FILE does not exist in $HOME/$FROM_DIR"
  exit
fi

if [ "$RELEASEBUNDLEDIR" != "" ]; then
  cd $HOME/$RELEASEBUNDLEDIR
  echo uploading $FROM_FILE to github
  gh release upload $RELEASEBRANCH $HOME/$FROM_DIR/$FROM_FILE  -R github.com/$GH_OWNER_ARG/$GH_REPO_ARG --clobber
fi

