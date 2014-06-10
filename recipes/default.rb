#
# Cookbook Name:: drupal
# Recipe:: default
# Author:: Koji Tanaka (<kj.tanaka@gmail.com>)
#
# Copyright 2014, FutureGrid, Indiana University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe 'database::mysql'
include_recipe 'iptables::disabled'
include_recipe 'selinux::disabled'

# TODO: php packages should probably be replaced with cookbook php.
packages = %w[rsync httpd php php-mysql php-mbstring gd php-gd php-xml]

packages.each do |pkg|
  package pkg do
    action :install
  end
end

service "httpd" do
  action [:enable, :start]
end

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

mysql_database "drupal" do
  connection mysql_connection_info
  action :create
end

mysql_database_user "admin" do
  connection mysql_connection_info
  password "PkkdJJGKLE"
  database_name "drupal"
  privileges [:all]
  action [:create, :grant]
end

directory "/root/downloads" do
  action :create
end

execute "download_drupal" do
  cwd "/root/downloads"
  command "wget http://ftp.drupal.org/files/projects/drupal-7.28.tar.gz"
  creates "drupal-7.28.tar.gz"
end

execute "extract_tarball" do
  cwd "/root/downloads"
  command "tar zxvf drupal-7.28.tar.gz"
  creates "drupal-7.28"
end

script "install_drupal" do
  user "root"
  cwd "/root/downloads"
  code <<-EOH
  /usr/bin/rsync -av drupal-7.28/ /var/www/html
  chown -R apache:apache /var/www/html
  EOH
  creates "/var/www/html/sites"
end

template "/var/www/html/sites/default/settings.php" do
  owner "apache"
  group "apache"
  mode "0644"
	variables(
    :database => "drupal",
    :username => "admin",
    :password => "PkkdJJGKLE"
  )
end
