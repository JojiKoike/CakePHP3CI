#
# Cookbook Name:: common
# Recipe:: default
#
# Copyright 2017, app-tsukurouze.com
#
# All rights reserved - Do Not Redistribute
#
%w(curl git).each do |p|
  package p do
    action :install
  end
end
