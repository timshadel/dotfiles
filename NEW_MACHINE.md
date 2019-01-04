# Setup a New Machine

1. Install Homebrew

Check the [Homebrew page](https://brew.sh/) to see if anything changed, but this should probably get you going. It'll install the Xcode commandline tools, without installing Xcode. This is also how you install `git` for the next step. Sweet, right?

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

2. Clone this repo

```sh
cd ~
mkdir projects && cd projects
git clone https://github.com/timshadel/dotfiles.git
```

3. Install Everything

One or two things may fail because they require a full Xcode install.

```sh
brew bundle install
```

4. Launch Dropbox and Start Sync

There are a few custom dotfiles in Dropbox which are not part of the checkin.

```sh
open /Applications/Dropbox
```

5. Install Ruby + `xcode-install`

See which versions are available, and pick a good one.

```sh
# Setup Ruby
rbenv install -l
rbenv install $chosenRubyVersion

# Start using the new Ruby
rbenv global $chosenRubyVersion
eval "$(rbenv init -)"

# Install xcode installer
gem install xcode-install
```

6. Install Xcode

```sh
xcversion list
xcversion install $chosenXcodeVersionA
xcversion install $chosenXcodeVersionB
```

7. Run `bootstrap.sh`

To work properly, this will require a full Xcode install.

```sh
./bootstrap.sh
```

8. Run `.macos`

This will kill your terminal.

```sh
./.macos
```
