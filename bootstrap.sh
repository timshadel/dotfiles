#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  rsync --exclude ".git/" --exclude ".gitexclude" --exclude ".DS_Store" --exclude "bootstrap.sh" \
    --exclude "brew.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;
  rsync -avh --no-perms ~/init/*.otf ~/Library/Fonts/;
  rsync -avh --no-perms ~/init/*.dvtcolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes/;
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
