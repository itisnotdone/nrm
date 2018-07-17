#
# Cookbook:: nrm
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# It will assume if installed or up-to-date by checking the file, nexus.tar.gz
if not File.exist?("#{node['nrm']['nrm_home']}/nexus.tar.gz") or
    `wget -qO- #{node['nrm']['md4_url']}`.chop! !=
    `md5sum #{node['nrm']['nrm_home']}/nexus.tar.gz`.chop!.split(' ')[0]

  include_recipe 'nrm::nexus'
else
  Chef::Log.warn("Nexus is up-to-date alreadly.")
  #return
end
include_recipe 'nrm::nginx'
