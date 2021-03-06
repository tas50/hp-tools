#
# Cookbook Name:: hp-tools
# Recipe:: default
#
# Copyright 2012, Webtrends Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Only execute if we're on an HP system
if node['dmi']['system'] && node['dmi']['system']['manufacturer'] == 'HP'

  # Create a symlink for a zlib shared object that doesn't get detectd correctly by the HP RPM on some systems.
  link '/usr/lib/libz.so.1' do
    to '/lib64/libz.so.1.2.3'
    only_if 'test -f /lib64/libz.so.1.2.3'
  end

  # Install HP system utilities along with the HP System Management Homepage
  %w(cpqacuxe hp-health hp-smh-templates hp-snmp-agents hpacucli hpdiags hponcfg hpsmh hpvca).each do |pkg|
    package pkg
  end

  # Include the SNMP cookbook making sure that "libcmaX64.so" is loaded in our snmpd.conf file.
  include_recipe 'snmp'

  # Because of HP's buggy init script, the only way to start this service if it's stopped is by calling the script directly.
  execute 'hp-snmp-agents service start' do
    command '/etc/init.d/hp-snmp-agents start'
    creates '/var/lock/subsys/hp-snmp-agents'
    action :run
  end

  service 'hpsmhd' do
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end

  cookbook_file '/opt/hp/hpsmh/conf/smhpd.xml' do
    source 'smhpd.xml'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[hpsmhd]'
  end

  file '/etc/sudoers.d/hpsmh-snmptrap' do
    owner 'root'
    group 'root'
    mode '0440'
    content "%hpsmh       ALL = NOPASSWD: /usr/bin/snmptrap\n"
    action :create
  end

end
