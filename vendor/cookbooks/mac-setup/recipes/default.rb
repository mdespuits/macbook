# Installation stuff goes here
include_recipe "homebrew"
include_recipe "dmg"
include_recipe "zip_app"

node["homebrew_packages"].each do |package_name|
  package package_name do
    provider Chef::Provider::Package::Homebrew
  end
end

zip_app_package "Alfred" do
  source "http://cachefly.alfredapp.com/alfred_1.3.3_267.zip"
end

zip_app_package "iTerm" do
  source "http://iterm2.googlecode.com/files/iTerm2_v1_0_0.zip"
end

zip_app_package "BetterSnapTool" do
  source "http://boastr.de/BetterSnapToolTrial.zip"
end

zip_app_package "Postgres" do
  source "http://postgresapp.com/download"
end

zip_app_package "Github" do
  source "https://central.github.com/mac/latest"
end

zip_app_package "Induction" do
  source "http://inductionapp.com/download"
end

zip_app_package "Firefox" do
  source "https://download.mozilla.org/?product=firefox-19.0.2&os=osx&lang=en-US"
end

zip_app_package "Mou" do
  source "http://mouapp.com/download/Mou.zip"
end

dmg_package "Skype" do
  source "http://www.skype.com/go/getskype-macosx.dmg"
end

dmg_package "Sublime Text 2" do
  dmg_name "sublimetext2"
  source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.dmg"
end

dmg_package "Google Chrome" do
  dmg_name "googlechrome"
  source "https://dl-ssl.google.com/chrome/mac/stable/GGRM/googlechrome.dmg"
end

dmg_package "Virtualbox" do
  source "http://dlc.sun.com.edgesuite.net/virtualbox/4.0.8/VirtualBox-4.0.8-71778-OSX.dmg"
  type "mpkg"
end
