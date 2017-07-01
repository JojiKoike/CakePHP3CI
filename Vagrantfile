# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Dont't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Package Cache
  config.cache.scope = :machine if Vagrant.has_plugin?('vagrant-cachier')

  # Development environment
  config.vm.define :develop do |develop|
    develop.omnibus.chef_version = :latest
    develop.vm.hostname = 'develop'
    develop.vm.box = 'bento/centos-7.3'
    develop.vm.network :private_network, ip: '192.168.33.10'
    develop.vm.synced_folder './application',
                             '/var/www/application/current',
                             id: 'vagrant-root',
                             nfs: false,
                             owner: 'vagrant',
                             group: 'vagrant',
                             mount_options: ['dmode=777', 'fmode=777']

    # Provisioning
    develop.vm.provision :chef_solo do |chef|
      # Log lovel setting
      chef.log_level = 'debug'
      # Cookbook location
      chef.cookbooks_path = './chef-repo/cookbooks'
      # Attribute definition for each cookbook
      chef.json = {
        nginx: {
          docroot: {
            owner: 'vagrant',
            group: 'vagrant',
            mode: 0o777,
            path: '/var/www/application/current/app/blogapp/webroot',
            force_create: true
          },
          default: {
            fastcgi_params: {
              CAKE_ENV: 'development'
            }
          },
          test: {
            available: true,
            fastcgi_params: {
              CAKE_ENV: 'test'
            }
          }
        },
        mysql: {
          hostname: 'develop',
          server_root_password: 'password'
        }
      }
      # Cookbook apply definition
      chef.run_list = %w(
        recipe[selinux::disabled]
        recipe[yum]
        recipe[yum-epel]
        recipe[common::default]
        recipe[phpenv::default]
        recipe[phpenv::composer]
        recipe[phpenv::develop]
        recipe[nginx::default]
        recipe[mysql::default]
        recipe[capistrano]
      )
    end
  end

  # CI Server
  config.vm.define :ci do |ci|
    ci.omnibus.chef_version = :latest
    ci.vm.hostname = 'ci'
    ci.vm.box = 'bento/centos-7.3'
    ci.vm.network :private_network, ip: '192.168.33.100'

    # Provisioning
    ci.vm.provision :chef_solo do |chef|
      # Log lovel setting
      chef.log_level = 'debug'
      # Cookbook location
      chef.cookbooks_path = './chef-repo/cookbooks'
      # Attribute definition for each cookbook
      chef.json = {
        nginx: {
          docroot: {
            owner: 'vagrant',
            group: 'vagrant',
            path: '/var/lib/jenkins/jobs/blogapp/workspace/app/webroot',
            mode: 0o755,
            force_create: true
          },
          default: {
            fastcgi_params: {
              CAKE_ENV: 'development'
            }
          },
          test: {
            available: true,
            fastcgi_params: {
              CAKE_ENV: 'ci'
            }
          }
        },
        mysql: {
          hostname: 'ci',
          server_root_password: 'password'
        },
        java: {
          jdk_version: '8'
        }
      }
      # Cookbook apply definition
      chef.run_list = %w(
        recipe[yum]
        recipe[yum-epel]
        recipe[common::default]
        recipe[phpenv::default]
        recipe[phpenv::composer]
        recipe[phpenv::develop]
        recipe[nginx::default]
        recipe[mysql::default]
        recipe[capistrano]
        recipe[java::default]
        recipe[jenkins::master]
        recipe[jenkinscustomize::plugin]
      )
    end
  end

  # Deployment environment
  config.vm.define :deploy do |deploy|
    deploy.omnibus.chef_version = :latest
    deploy.vm.hostname = 'deploy'
    deploy.vm.box = 'bento/centos-7.3'
    deploy.vm.network :private_network, ip: '192.168.33.200'

    # Provisioning
    deploy.vm.provision :chef_solo do |chef|
      # Log lovel setting
      chef.log_level = 'debug'
      # Cookbook location
      chef.cookbooks_path = './chef-repo/cookbooks'
      # Attribute definition for each cookbook
      chef.json = {
        nginx: {
          docroot: {
            owner: 'vagrant',
            group: 'vagrant',
            path: '/var/www/application/current/app/webroot',
            mode: 0o755,
            force_create: true
          },
          default: {
            fastcgi_params: {
              CAKE_ENV: 'production'
            }
          }
        },
        mysql: {
          hostname: 'deploy',
          server_root_password: 'password'
        }
      }
      # Cookbook apply definition
      chef.run_list = %w(
        recipe[yum]
        recipe[yum-epel]
        recipe[common::default]
        recipe[phpenv::default]
        recipe[phpenv::composer]
        recipe[nginx::default]
        recipe[mysql::default]
      )
    end
  end
end
