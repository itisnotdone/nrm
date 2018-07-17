default['nrm']['user'] = 'nexus'
default['nrm']['nrm_home'] = '/opt/nexus'
# http://download.sonatype.com/nexus/3/nexus-3.12.0-01-unix.tar.gz
# default['nrm']['nrm_version'] = '3.12.0-01'
if default['nrm']['nrm_version'].empty?
  default['nrm']['download_url'] =
    'https://download.sonatype.com/nexus/3/latest-unix.tar.gz'
else
  default['nrm']['download_url'] =
    "https://download.sonatype.com/nexus/3/nexus-#{default['nrm']['nrm_version']}.tar.gz"
end
default['nrm']['md4_url'] =
  'http://download.sonatype.com/nexus/3/latest-unix.tar.gz.md5'

default['nrm']['nginx']['config_dir'] = '/etc/nginx'
default['nrm']['nginx']['ssl']['dir'] = '/etc/nginx/ssl'
default['nrm']['nginx']['ssl']['crt'] =
  'http://def-www.default.don/site/default.don_2018.crt'
default['nrm']['nginx']['ssl']['key'] =
  'http://def-www.default.don/site/default.don_2018.key'

