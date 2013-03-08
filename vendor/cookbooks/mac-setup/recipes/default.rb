# Installation stuff goes here
include_recipe "homebrew"
include_recipe "dmg"
include_recipe "zip_app"

node["packages"].each do |package_name|
  package package_name do
    provider Chef::Provider::Package::Homebrew
  end
end

Array(node["zip_apps"]).each do |app_name|
  zip_app_package app_name['name'] do
    %w[app source checksum destination zip_file].each do |attribute|
      send(attribute, app_name[attribute]) if app_name[attribute]
    end
  end
end

dmg_package "Skype" do
  source "http://www.skype.com/go/getskype-macosx.dmg"
end

dmg_package "Sublime Text 2" do
  dmg_name "sublimetext2"
  source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.dmg"
end

dmg_package "VLC" do
  source "http://sourceforge.net/projects/vlc/files/latest/download"
end

dmg_package "Google Chrome" do
  dmg_name "googlechrome"
  source "https://dl-ssl.google.com/chrome/mac/stable/GGRM/googlechrome.dmg"
end

dmg_package "Google Drive" do
  dmg_name "googledrive"
  source "http://dl.google.com/drive/installgoogledrive.dmg"
end

dmg_package "Jing" do
  source "http://download.techsmith.com/jing/mac/jing.dmg"
  accept_eula true
end

dmg_package "Virtualbox" do
  source "http://dlc.sun.com.edgesuite.net/virtualbox/4.0.8/VirtualBox-4.0.8-71778-OSX.dmg"
  type "mpkg"
end
