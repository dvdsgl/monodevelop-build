#!/usr/bin/ruby

require "fileutils"

MONODEVELOP_REPO = "git@github.com:mono/monodevelop.git"

# Building MonoDevelop on OS X requires an older version of Xamarin.Mac.
# This isn't documented anywhere!
XAMARIN_MAC_PKG = "xamarin.mac-1.12.0.14.pkg"
XAMARIN_MAC_URL = "http://download.xamarin.com/XamarinforMac/Mac/#{XAMARIN_MAC_PKG}"

MDK_PKG_ID = "com.xamarin.mono-MDK.pkg"
MDK_PKG = "MonoFramework-MDK-4.0.0.macos10.xamarin.x86.pkg"
MDK_URL = "http://download.mono-project.com/archive/4.0.0/macos-10-x86/#{MDK_PKG}"

def installed? pkg
  system "pkgutil --pkgs=#{pkg} &>/dev/null"
end

def install_pkg url
  pkg = File.basename url
  system "curl -O #{url}" unless File.exist? pkg
  system "sudo installer -pkg #{pkg} -target /"
  FileUtils.rm_rf pkg
end

def inside_monodevelop_clone?
  begin
    `basename \`git rev-parse --show-toplevel\``.strip == "monodevelop"
  rescue
    false
  end
end

def clone
  Dir.chdir "monodevelop" if File.directory? "monodevelop"
  unless inside_monodevelop_clone?
    system "git clone #{MONODEVELOP_REPO}"
    Dir.chdir "monodevelop"
    system "git submodule update --init --recursive"
  end
end

def configure
  system "./configure --profile=mac"
end

def make
  system 'make'
  system 'cd main/build/MacOSX && make MonoDevelop.app'
end

def run
  system "open main/build/MacOSX/MonoDevelop.app"
end

install_pkg MDK_URL unless installed? MDK_PKG_ID
install_pkg XAMARIN_MAC_URL unless installed? XAMARIN_MAC_PKG

clone

system 'export PATH="/Library/Frameworks/Mono.framework/Versions/Current/bin:$PATH"'
system 'export ACLOCAL_FLAGS="-I /Library/Frameworks/Mono.framework/Versions/Current/share/aclocal"'
system 'export DYLD_FALLBACK_LIBRARY_PATH=/Library/Frameworks/Mono.framework/Versions/Current/lib:/lib:/usr/lib'
configure
make
run
