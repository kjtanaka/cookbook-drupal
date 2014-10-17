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

drupal_version = node['drupal']['version']
drupal_download_url = "http://ftp.drupal.org/files/projects/drupal-#{drupal_version}.tar.gz"
drupal_db_name = node['drupal']['db_name']
drupal_db_user = node['drupal']['db_user']
drupal_db_user_password = node['drupal']['db_user_password']
drupal_install_dir = node['drupal']['install_dir']
mysql_root_password = node['mysql']['server_root_password']
node.default['mysql']['server_debian_password'] = mysql_root_password
node.default['mysql']['server_root_password'] = mysql_root_password
node.default['mysql']['server_repl_password'] = mysql_root_password

#if Chef::EncryptedDataBagItem.load("drupal", "secrets")
#  secrets = Chef::EncryptedDataBagItem.load("drupal", "secrets")
#end

#if secrets
#  drupal_db_user_password = secrets['db_user_password']
#  drupal_db_name = secrets['db_name']
#  drupal_db_user = secrets['db_user']
#end

include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe 'database::mysql'
include_recipe 'iptables::disabled'
include_recipe 'selinux::disabled'

packages = %w[wget rsync httpd php php-mysql php-mbstring gd php-gd php-xml]

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
                         :password => mysql_root_password}

mysql_database "drupal" do
  connection mysql_connection_info
  action :create
end

mysql_database_user drupal_db_user do
  connection mysql_connection_info
  password drupal_db_user_password
  database_name drupal_db_name
  privileges [:all]
  action [:create, :grant]
end

directory "/root/downloads" do
  action :create
end

execute "download_drupal" do
  cwd "/root/downloads"
  command "wget #{drupal_download_url}"
  creates "drupal-#{drupal_version}.tar.gz"
end

execute "extract_tarball" do
  cwd "/root/downloads"
  command "tar zxvf drupal-#{drupal_version}.tar.gz"
  creates "drupal-#{drupal_version}"
end

script "install_drupal" do
  interpreter "bash"
  user "root"
  cwd "/root/downloads"
  code <<-EOH
  rsync -av drupal-#{drupal_version}/ #{drupal_install_dir}
  cp #{drupal_install_dir}/sites/default/default.settings.php #{drupal_install_dir}/sites/default/settings.php
  chown -R apache:apache #{drupal_install_dir}
  EOH
  creates "#{drupal_install_dir}/sites"
end
