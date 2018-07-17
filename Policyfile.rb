name 'nrm'
default_source :supermarket
default_source :chef_repo, '../' do |s|
  s.preferred_for 'nrm'
end

run_list 'nrm'

# default['nrm']['download_url'] = THE_NEXUS_URL_YOU_ARE_CURRENTLY_USING
