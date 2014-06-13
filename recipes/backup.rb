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

drupal_version = node['drupal']['version']
drupal_db_name = node['drupal']['db_name']
drupal_db_user = node['drupal']['db_user']
drupal_db_user_password = node['drupal']['db_user_password']
drupal_backup = "drupal-backup"
drupal_dir = "/var/www/html"
drupal_backup_work_dir = "/tmp"

directory "#{drupal_backup_work_dir}/#{drupal_backup}" do
  action :create
end

script "backup_database" do
  interpreter "bash"
  user "root"
  cwd "#{drupal_backup_work_dir}/#{drupal_backup}"
  code <<-EOH
  mysqldump -u#{drupal_db_user} -p#{drupal_db_user_password} #{drupal_db_name} > DATABASE.sql
  tar czvf DATABASE.tar.gz DATABASE.sql
  rm -f DATABASE.sql
  EOH
  creates "DATABASE.tar.gz"
end

script "backup_files" do
  interpreter "bash"
  user "root"
  cwd "#{drupal_backup_work_dir}/#{drupal_backup}"
  code <<-EOH
  rsync -av #{drupal_dir}/ FILES
  tar czvf FILES.tar.gz FILES
  rm -rf FILES
  EOH
  creates "FILES.tar.gz"
end

