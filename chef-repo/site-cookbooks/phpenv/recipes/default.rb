#
# Cookbook Name:: phpenv
# Recipe:: default
#
# Copyright 2017, app-tsukurouze.com
#
# All rights reserved - Do Not Redistribute
#

# STEP 1 : Setup Repositries
# remi
yum_repository 'remi' do
  description 'This is remi repository for Redhat Enterprice Linux 7'
  baseurl 'http://rpms.famillecollet.com/enterprise/7/remi/x86_64/'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  fastestmirror_enabled true
  action :create
end

# remi-php71
yum_repository 'remi-php71' do
  description 'This is remi PHP 7.1.x repository for Redhat Enterprice Linux 7'
  baseurl 'http://rpms.famillecollet.com/enterprise/7/php71/x86_64/'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  fastestmirror_enabled true
  action :create
end

# STEP 2 : Install applications
%w(php php-cli php-fpm php-mbstring php-mcrypt php-mysql
   php-pear php-xsl php-curl php-intl).each do |p|
  package p do
    action :install
  end
end

# STEP 3 : php.ini customize
template '/etc/php.ini' do
  owner 'root'
  group 'root'
  mode 0o0644
  action :create
end

# STEP 4 : Start service
service 'php-fpm' do
  action [:enable, :start]
end
