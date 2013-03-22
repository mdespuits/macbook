require 'fileutils'

# Installation stuff goes here
include_recipe "homebrew"
include_recipe "dmg"
include_recipe "zip_app"

homebrew_tap "homebrew/dupes"

#######################################################
# Install Homebrew Packages
#######################################################
node["packages"].each do |package_name|
  package package_name do
    provider Chef::Provider::Package::Homebrew
  end
end

#######################################################
# Install .zip based App installers
#######################################################
Array(node["zip_apps"]).each do |app_name|
  zip_app_package app_name['name'] do
    %w[app source checksum destination zip_file].each do |attribute|
      send(attribute, app_name[attribute]) if app_name[attribute]
    end
  end
end

#######################################################
# Install .dmg Apps
#######################################################
Array(node["dmg_apps"]).each do |dmg|
  dmg_package dmg['app'] do
    %w[source owner checksum destination type volumes_dir package_id dmg_name dmg_passphrase accept_eula].each do |attribute|
      send(attribute, dmg[attribute]) if dmg[attribute]
    end
  end
end

#######################################################
# Install Some of my usual Git repositories
#######################################################
Array(node["repos"]).each do |repositories|
  data = OpenStruct.new(repositories)
  path = File.expand_path(data.path)
  FileUtils.mkdir_p path
  data.repos.each do |url|
    directory_name = url.split("/").last
    git "#{path}/#{directory_name}" do
      repository "https://github.com/#{url}.git"
      reference "master"
      action :sync
    end
  end
end
