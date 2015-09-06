name             'hp-tools'
maintainer       'Tim Smith'
maintainer_email 'tsmith84@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures various HP tools'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

%w{ centos redhat fedora amazon scientific oracle }.each do |os|
  supports os
end

depends 'snmp'

source_url 'https://github.com/tas50/hp-tools' if respond_to?(:source_url)
issues_url 'https://github.com/tas50/hp-tools/issues' if respond_to?(:issues_url)
