#
# Cookbook Name:: phpenv
# Recipe:: develop
#
# Copyright 2017, app-tsukurouze.com
#
# All rights reserved - Do Not Redistribute
#

# Hostfile item entry
hostsfile_entry '127.0.0.1' do
  hostname 'test.localhost'
  action :append
end

# graphviz repository
template '/etc/yum.repos.d/graphviz-rhel.repo' do
  owner 'root'
  group 'root'
  mode 0o0644
end

#  Install applications
%w(php-xdebug graphviz).each do |p|
  package p do
    action :install
  end
end

# phpdoc
remote_file '/usr/local/bin/phpdoc' do
  source 'http://www.phpdoc.org/phpDocumentor.phar'
  action :create_if_missing
  owner 'root'
  group 'root'
  mode 0o0755
end

# xdebug configure customize (for avoid booking php-fpm tcp 9000 port)
service 'php-fpm' do
  action :nothing
end
template '/etc/php.d/15-xdebug.ini' do
  owner 'root'
  group 'root'
  mode 0o0644
  action :create
  notifies :restart, 'service[php-fpm]', :delayed
end
