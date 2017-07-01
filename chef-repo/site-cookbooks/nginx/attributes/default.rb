# Document root settings
# Owner
default['nginx']['docroot']['owner'] = 'root'
# Group
default['nginx']['docroot']['group'] = 'root'
# Path
default['nginx']['docroot']['path'] = '/usr/share/nginx/html'
# Whether create nginx document root or not if not exists
default['nginx']['docroot']['force_create'] = false
# default site settting params
default['nginx']['default']['fastcgi_params'] = []
# Whether use virtualhost for test or not
default['nginx']['test']['available'] = false
# test site setting params
default['nginx']['test']['fastcgi_params'] = []
