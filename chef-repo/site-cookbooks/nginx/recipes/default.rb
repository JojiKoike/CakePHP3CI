#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2017, app-tsukurouze.com
#
# All rights reserved - Do Not Redistribute
#
# STEP 1: Install repository
include_recipe 'yum-epel'

# STEP 2: Stop and disable httpd service if installed.
service 'httpd' do
  action [:disable, :stop]
  only_if "rpm -qa | grep -q '^httpd'"
end

# STEP 3: Install nginx
package 'nginx' do
  action:install
end

# STEP 4: Configure settings
# nginx configuration (for PHP)
template '/etc/nginx/nginx.conf' do
  owner 'root'
  group 'root'
  mode 0o0644
  action :create
end

# nginx configuration (for PHP test)
template '/etc/nginx/conf.d/test.conf' do
  owner 'root'
  group 'root'
  mode 0o0644
  action :create
  only_if { node['nginx']['test']['available'] == true }
end

# Making nginx document root
directory node['nginx']['docroot']['path'] do
  owner node['nginx']['docroot']['owner']
  group node['nginx']['docroot']['group']
  mode node['nginx']['docroot']['mode']
  action :create
  recursive true
  only_if do
    !File.exist?(node['nginx']['docroot']['path']) &&
      node['nginx']['docroot']['force_create']
  end
end

# Deploy Dummy PHP Script
template "#{node['nginx']['docroot']['path']}/index.php" do
  source 'index.php.erb'
  owner node['nginx']['docroot']['owner']
  group node['nginx']['docroot']['group']
  mode 0o0644
  action :create
  only_if do
    !File.exist?("#{node['nginx']['docroot']['path']}/index.php") && node['nginx']['docroot']['force_create']
  end
end

# STEP 5: Start and Enable nginx
service 'nginx' do
  action [:enable, :start]
  support_setting = { status: true, restart: true, reload: true }
  supports support_setting
end
