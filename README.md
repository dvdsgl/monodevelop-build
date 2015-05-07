The goal of this repo is to make building MonoDevelop on a fresh OS X install as easy as:

```shell
ruby -e "$(curl -fsSL bit.ly/1zCQCam)"
```

Please watch for password prompts.

## Details

This script performs the following steps when needed:

* Installs Xcode command line tools
* Installs Homebrew package manager
* Installs autoconf and automake
* Installs Xamarin.Mac and Mono development kit
* Clones the mono/monodevelop repo
* Configures and builds monodevelop, including the OS X app bundle
* Opens the main MonoDevelop workspace in itself
