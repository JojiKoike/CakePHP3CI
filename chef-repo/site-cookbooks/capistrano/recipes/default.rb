#
# Cookbook Name:: capistrano
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'ruby' do
  action :install
end

gem_package 'capistrano' do
  action :install
end
