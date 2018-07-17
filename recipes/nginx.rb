apt_package 'nginx'

directory node['nrm']['nginx']['ssl']['dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file node['nrm']['nginx']['ssl']['dir'] +
  '/' + node['nrm']['nginx']['ssl']['crt'].split('/').last do
  source node['nrm']['nginx']['ssl']['crt']
  owner 'root'
  group 'www-data'
  mode '0640'
  action :create
end

remote_file node['nrm']['nginx']['ssl']['dir'] +
  '/' + node['nrm']['nginx']['ssl']['key'].split('/').last do
  source node['nrm']['nginx']['ssl']['key']
  owner 'root'
  group 'www-data'
  mode '0640'
  action :create
end

# to create nexus nginx configuration
template node['nrm']['nginx']['config_dir'] +
  '/sites-available/nexus.conf' do
  source 'nexus.conf.erb'
  mode '644'
end

# to enable nexus.conf
link node['nrm']['nginx']['config_dir'] +
  '/sites-enabled/nexus.conf' do
  to node['nrm']['nginx']['config_dir'] +
    '/sites-available/nexus.conf'
end

# to apply changes
execute 'restart_nginx' do
  command "systemctl restart nginx"
end

