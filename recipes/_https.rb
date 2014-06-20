#
# Cookbook Name:: drupal
# Recipe:: _https
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

drupal_ca_key = node['drupal']['ca_key']
drupal_ca_csr = node['drupal']['ca_csr']
drupal_ca_crt = node['drupal']['ca_crt']

packages = %w[mod_ssl openssl]

packages.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file drupal_ca_key do
  source "ca.key"
  owner "root"
  group "root"
  action :create
end

cookbook_file drupal_ca_csr do
  source "ca.csr"
  owner "root"
  group "root"
  action :create
end

cookbook_file drupal_ca_crt do
  source "ca.crt"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/etc/httpd/conf/httpd.conf" do
  owner "root"
  group "root"
  action :create
end

template "/etc/httpd/conf.d/ssl.conf" do
  action :create
  variables(
    :drupal_ca_crt => drupal_ca_crt,
    :drupal_ca_key => drupal_ca_key
  )
end

service "httpd" do
  action :restart
end
