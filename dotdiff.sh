# Look at all dotfiles in this directory and see how the actual dotfiles differ
# find . -name  ".[^.]*" -maxdepth 1 -type f | grep -v gitexclude | sed -e "s/.\/\(.*\)/diff -u \1 ~\/\1/" | sh

DIFF=$(mktemp -u)

for fileName in $PWD/.[^.]*; do
  if [[ -f $fileName ]]; then
    localName=${fileName##*/};
    installedName=~/$localName;
    if [[ -e $installedName && -f $installedName ]]; then
      diff -u $installedName $localName >> $DIFF;
    fi
  fi
done

less < $DIFF
rm $DIFF
