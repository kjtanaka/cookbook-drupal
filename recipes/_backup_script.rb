#
# Cookbook Name:: drupal
# Recipe:: _backup_script
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
drupal_dir = node['drupal']['install_dir']
drupal_work_dir = node['drupal']['work_dir']
drupal_backup_name = node['drupal']['backup_name']

template "/root/drupal-backup.sh" do
  source "drupal-backup.sh.erb"
  owner "root"
  group "root"
  action :create
  variables(
    :drupal_dir => drupal_dir,
    :drupal_backup_name => drupal_backup_name,
    :drupal_db_user => drupal_db_user,
    :drupal_db_name => drupal_db_name,
    :drupal_db_password => drupal_db_user_password,
    :drupal_work_dir => drupal_work_dir
  )
end
