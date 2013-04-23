require 'fileutils'

# Installation stuff goes here
include_recipe "homebrew"
include_recipe "dmg"
include_recipe "zip_app"

Packages = ["ack", "cloc", "bash-completion", "elasticsearch", "heroku-toolbelt",
            "git", "hub", "macvim", "memcached", "node", "phantomjs", "pstree",
            "rbenv", "rbenv-vars", "ruby-build", "redis", "tree", "go",
            "the_silver_searcher", "tmux", "wget", "zsh"]

ZipApps = [
  OpenStruct.new( name: "Alfred 2", source: "http://cachefly.alfredapp.com/Alfred_2.0.3_187.zip"),
  OpenStruct.new( name: "iTerm", source: "http://iterm2.googlecode.com/files/iTerm2_v1_0_0.zip"),
  OpenStruct.new( name: "BetterSnapTool", source: "http://boastr.de/BetterSnapToolTrial.zip"),
  OpenStruct.new( name: "Postgres", source: "http://postgresapp.com/download"),
  OpenStruct.new( name: "Github", source: "https://central.github.com/mac/latest"),
  OpenStruct.new( name: "Induction", source: "http://inductionapp.com/download"),
  OpenStruct.new( name: "Firefox", source: "https://download.mozilla.org/?product=firefox-19.0.2&os=osx&lang=en-US"),
  OpenStruct.new( name: "Mou", source: "http://mouapp.com/download/Mou.zip")
]

DmgApps = [
  OpenStruct.new( app: "Vagrant", source: "http://files.vagrantup.com/packages/87613ec9392d4660ffcb1d5755307136c06af08c/Vagrant.dmg", type: "pkg"),
  OpenStruct.new( app: "Skype", source: "http://www.skype.com/go/getskype-macosx.dmg"),
  OpenStruct.new( app: "VLC", source: "http://sourceforge.net/projects/vlc/files/2.0.5/macosx/vlc-2.0.5.dmg/download"),
  OpenStruct.new( app: "Sublime Text 2", dmg_name: "sublimetext2", source: "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.dmg"),
  OpenStruct.new( app: "Google Chrome", dmg_name: "googlechrome", source: "https://dl-ssl.google.com/chrome/mac/stable/GGRM/googlechrome.dmg"),
  OpenStruct.new( app: "Google Drive", dmg_name: "googledrive", source: "http://dl.google.com/drive/installgoogledrive.dmg"),
  OpenStruct.new( app: "Virtualbox", source: "http://dlc.sun.com.edgesuite.net/virtualbox/4.0.8/VirtualBox-4.0.8-71778-OSX.dmg", type: "mpkg"),
  OpenStruct.new( app: "Jing", source: "http://download.techsmith.com/jing/mac/jing.dmg", "accept_eula" => true),
]

Repositories = [
  OpenStruct.new( path: "~/code/personal/other", url: "mattdbridges/capistrano-recipes" ),
  OpenStruct.new( path: "~/code/personal/gems", url: "mattdbridges/dotify" ),
  OpenStruct.new( path: "~/code/personal/gems", url: "mattdbridges/validates_formatting_of" ),
  OpenStruct.new( path: "~/code/other-projects", directory: "mcheyne", url: "mattdbridges/mcheyne-bible-app" ),
  OpenStruct.new( path: "~/code/other-projects", url: "gabetax/twitter-bootstrap-kaminari-views" ),
  OpenStruct.new( path: "~/code/open-source/javascript", url: "twitter/bootstrap" ),
  OpenStruct.new( path: "~/code/open-source/javascript", url: "simsalabim/sisyphus" ),
  OpenStruct.new( path: "~/code/open-source/javascript", url: "visionmedia/mocha" ),
  OpenStruct.new( path: "~/code/open-source/javascript", url: "xing/wysihtml5" ),
  OpenStruct.new( path: "~/code/open-source/gems", url: "EmmanuelOga/ffaker" ),
  OpenStruct.new( path: "~/code/open-source/gems", url: "kevinjalbert/git_statistics" ),
  OpenStruct.new( path: "~/code/open-source/gems", url: "guard/guard-pow" ),
  OpenStruct.new( path: "~/code/open-source/gems", url: "github/linguist" ),
]


#######################################################
# Install Homebrew Packages
#######################################################
Packages.each do |package_name|
  package package_name do
    provider Chef::Provider::Package::Homebrew
  end
end

#######################################################
# Install .zip based App installers
#######################################################
ZipApps.each do |app|
  zip_app_package app.name do
    %w[app source checksum destination zip_file].each do |attribute|
      send(attribute, app.send(attribute)) if app.respond_to? attribute
    end
  end
end

#######################################################
# Install .dmg Apps
#######################################################
DmgApps.each do |dmg|
  dmg_package dmg.app do
    %w[source owner checksum destination type volumes_dir package_id dmg_name dmg_passphrase accept_eula].each do |attribute|
      send(attribute, dmg.send(attribute)) if dmg.respond_to? attribute
    end
  end
end

#######################################################
# Install Some of my usual Git repositories
#######################################################

Repositories.each do |repository|
  path = Pathname.new(File.expand_path(repository.path))
  FileUtils.mkdir_p path
  dir_name = repository.directory || repository.url.split("/").last
  git "#{path}/#{dir_name}" do
    repository "https://github.com/#{repository.url}.git"
    reference "master"
    action :sync
  end
end
