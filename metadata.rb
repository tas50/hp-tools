name             'hp-tools'
maintainer       'Webtrends Inc'
maintainer_email 'hostedops@webtrends.com'
license          'Apache 2.0'
description      'Installs/Configures various HP tools'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

%w{ centos redhat fedora amazon scientific oracle }.each do |os|
  supports os
end

depends 'snmp'
