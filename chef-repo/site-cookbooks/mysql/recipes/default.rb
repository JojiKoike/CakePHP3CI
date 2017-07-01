#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Section 1: Repository setting
# mysql official repository
remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el7-5.noarch.rpm" do
  source 'http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm'
  action :create
end

rpm_package 'mysql-community-release' do
  source "#{Chef::Config[:file_cache_path]}/mysql-community-release-el7-5.noarch.rpm"
  action :install
end

# Section 2: Install mysql
package 'mysql-server' do
  action :install
end

# Section 3: customize settings
template '/etc/my.cnf' do
  owner 'root'
  group 'root'
  mode 0o0644
  action :create
end

# Section 4: Start mysql
service 'mysqld' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

# Section 5: Secure install
hostname = node['mysql']['hostname']
root_password = node['mysql']['server_root_password']
execute 'secure_install' do
  command "/usr/bin/mysql -u root < #{Chef::Config[:file_cache_path]}/secure_install.sql"
  action :nothing
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template "#{Chef::Config[:file_cache_path]}/secure_install.sql" do
  source 'secure_install.sql.erb'
  owner 'root'
  group 'root'
  mode 0o644
  variables(hostname: hostname, root_password: root_password)
  notifies :run, 'execute[secure_install]', :immediately
end
