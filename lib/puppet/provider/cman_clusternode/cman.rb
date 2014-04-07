require 'fileutils'

Puppet::Type.type(:cman_clusternode).provide(:cman) do
    desc "CMAN provider for a clusternode"

    commands :ccscmd => 'ccs'
    @@ClusterConfigFile = '/etc/cluster/cluster.conf'
    @@CommonArgs = ['-if', @@ClusterConfigFile ]

    def create
        ccscmd(@@CommonArgs+['--addnode', resource[:name]])
        ccscmd(@@CommonArgs+['--addmethod', 'pcmk-redirect', resource[:name]])
        ccscmd(@@CommonArgs+['--addfenceinst', 'pcmk', resource[:name], 'pcmk-redirect', 'port='+resource[:name]])
        @property_hash[:ensure] = :present
    end

    def destroy
        ccscmd(@@CommonArgs+['--rmnode', resource[:name]])
    end

    def exists?
        clusternodes = ccscmd(@@CommonArgs+['--lsnodes'])
        clusternodes.match(/#{Regexp.escape(resource[:name])}: /)
    end
end
