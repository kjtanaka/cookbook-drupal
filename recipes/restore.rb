#
# Cookbook Name:: drupal
# Recipe:: backup
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

drupal_db_name = node['drupal']['db_name']
drupal_db_user = node['drupal']['db_user']
drupal_db_user_password = node['drupal']['db_user_password']
drupal_backup_name = node['drupal']['backup_name']
drupal_dir = node['drupal']['install_dir']
drupal_work_dir = node['drupal']['work_dir']
mysql_root_password = node['drupal']['db_root_password']
node.set['mysql']['server_debian_password'] = mysql_root_password
node.set['mysql']['server_root_password'] = mysql_root_password
node.set['mysql']['server_repl_password'] = mysql_root_password

include_recipe 'mysql::client'
include_recipe 'mysql::server'

template '/etc/mysql/conf.d/mysite.cnf' do
  owner 'mysql'
  owner 'mysql'      
  source 'mysite.cnf.erb'
  variables(
    :mysql_max_allowed_packet => node['drupal']['mysql_max_allowed_packet']
  )
  notifies :restart, 'mysql_service[default]', :immediately
end

include_recipe 'database::mysql'
#include_recipe 'iptables::disabled'
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


directory drupal_work_dir do
  action :create
end

cookbook_file "#{drupal_work_dir}/#{drupal_backup_name}.tar.gz" do
  source "#{drupal_backup_name}.tar.gz"
  mode "0644"
  owner "root"
  group "root"
  action :create_if_missing
end

execute "extract_tarball" do
  cwd drupal_work_dir
  command "tar zxvf #{drupal_backup_name}.tar.gz"
  creates "#{drupal_backup_name}"
end

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => mysql_root_password}

mysql_database drupal_db_name do
  connection mysql_connection_info
  action [:create]
end

mysql_database_user drupal_db_user do
  connection mysql_connection_info
  password drupal_db_user_password
  database_name drupal_db_name
  privileges [:all]
  action [:create, :grant]
end

bash "restore_db" do
  cwd "#{drupal_work_dir}/#{drupal_backup_name}"
  code <<-EOF
  mysql --max_allowed_packet=#{node['drupal']['mysql_max_allowed_packet']} -uroot -p#{mysql_root_password} #{drupal_db_name} < DATABASE.sql
  touch .db_restored
  EOF
  creates ".db_restored"
end

script "restore_files" do
  interpreter "bash"
  user "root"
  cwd drupal_work_dir
  code <<-EOH
  rsync -av --exclude=DATABASE.sql --exclude=.db_restored #{drupal_backup_name}/ #{drupal_dir}
  chown -R apache:apache #{drupal_dir}
  EOH
  creates "#{drupal_dir}/sites"
end

