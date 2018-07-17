user node['nrm']['user'] do
  manage_home false
  shell '/sbin/nologin'
  home node['nrm']['nrm_home']
  system true
end

apt_package [
  'openjdk-8-jre',
]

directory node['nrm']['nrm_home'] do
  owner node['nrm']['user']
  group node['nrm']['user']
  mode '0770'
  action :create
end

file "#{node['nrm']['nrm_home']}/nexus.tar.gz" do
  action :delete
end

remote_file node['nrm']['nrm_home'] + '/nexus.tar.gz' do
  source node['nrm']['download_url']
  owner node['nrm']['user']
  group node['nrm']['user']
  mode '0660'
end

execute 'extract_tar.gz' do
  command "sudo -u #{node['nrm']['user']} tar zxvf #{node['nrm']['nrm_home'] +
    '/nexus.tar.gz'} -C #{node['nrm']['nrm_home']}"
end

# to get the latest directory from nrm_home
# `ls -td #{node['nrm']['nrm_home']}/* | grep -v sonatype-work | head -n 1`
execute 'symlink' do
  command "sudo -u #{node['nrm']['user']} "\
    "ln -s `ls -td #{node['nrm']['nrm_home']}/* | grep -v sonatype-work | head -n 1` "\
    "#{node['nrm']['nrm_home']}/nexus"
end

template "#{node['nrm']['nrm_home']}/nexus/bin/nexus.vmoptions" do
  source 'nexus.vmoptions.erb'
  owner node['nrm']['user']
  group node['nrm']['user']
  mode '644'
end

template "#{node['nrm']['nrm_home']}/nexus/bin/nexus.rc" do
  source 'nexus.rc.erb'
  owner node['nrm']['user']
  group node['nrm']['user']
  mode '644'
end

systemd_unit 'nexus.service' do
  content({
    Unit: {
      Description: 'Nexus Repository Manager',
      After: 'network.target'
    },
    Service: {
      Type: 'forking',
      ExecStart: node['nrm']['nrm_home'] + '/nexus/bin/nexus start',
      ExecStop: node['nrm']['nrm_home'] + '/nexus/bin/nexus stop',
      User: node['nrm']['user'],
      Restart: 'on-abort'
    },
    Install: {
      WantedBy: 'multi-user.target'
    }
  })
  action [:create, :enable, :start]
end
