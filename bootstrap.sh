#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  rsync --exclude ".git/" \
      --exclude ".gitexclude" \
      --exclude ".DS_Store" \
      --exclude ".osx" \
      --exclude "bootstrap.sh" \
      --exclude "brew.sh" \
      --exclude "Brewfile" \
      --exclude "dotdiff.sh" \
      --exclude "init" \
      --exclude "LICENSE-MIT.txt" \
      --exclude "NEW_MACHINE.md" \
      --exclude "NEXT_TIME.md" \
      --exclude "README.md" \
      -avh --no-perms . ~;
  rsync -avh --no-perms \
      ~/init/*.otf \
      ~/Library/Fonts/;
  rsync -avh --no-perms \
      ~/init/*.dvtcolortheme \
      ~/Library/Developer/Xcode/UserData/FontAndColorThemes/;
  rsync -avh --no-perms .path .extra .crontab ~/Dropbox/; touch ~/Dropbox/.path ~/Dropbox/.extra ~/Dropbox/.crontab
  source ~/.bash_profile;
  crontab ~/.crontab;
  cp .gitexclude .git/info/exclude;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;
unset doIt;
