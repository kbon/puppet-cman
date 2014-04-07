require 'fileutils'

Puppet::Type.type(:cman_cluster).provide(:cman) do
    desc "CMAN provider for a cluster"

    commands :ccscmd => 'ccs'
    @@ClusterConfigFile = '/etc/cluster/cluster.conf'
    @@CommonArgs = ['-if', @@ClusterConfigFile ]
    @@ClusterConfig = nil

    # Utility functions
    def readConfig
        return nil unless File.readable?(@@ClusterConfigFile)
        @@ClusterConfig = File.open(@@ClusterConfigFile).read()
    end


    # Standard Puppet calls
    def create
        ccscmd(@@CommonArgs+['--createcluster', @resource[:name]])
        ccscmd(@@CommonArgs+['--addfencedev', 'pcmk', 'agent=fence_pcmk'])
        if resource[:multicast]
            ccscmd(@@CommonArgs+['--setmulticast',resource[:multicast]])
        end
        if resource[:altmulticast]
            ccscmd(@@CommonArgs+['--setaltmulticast',resource[:altmulticast]])
        end
        if resource[:logging]
            # When setting the value, we don't want to provide the "'s
            logging = resource[:logging].collect { |x| x.gsub('"','') }
            ccscmd(@@CommonArgs+['--setlogging', logging])
        end
        @property_hash[:ensure] = :present
    end

    def destroy
        FileUtils.rm_rf @@ClusterConfigFile
        @property_hash.clear
    end

    def exists?
        readConfig unless @@ClusterConfig
        /^<cluster .* name="#{resource[:name]}"/ =~ @@ClusterConfig
    end


    # Below: getters/setters of individual properties
    def multicast
        readConfig unless @@ClusterConfig
        addr=/<multicast addr="([^"]*)"/.match(@@ClusterConfig)
        return addr[1] unless addr.nil?
    end
    def multicast=(new_value)
        ccscmd(@@CommonArgs+['--setmulticast', new_value])
        @property_hash[:multicast] = new_value
    end

    def altmulticast
        readConfig unless @@ClusterConfig
        addr=/<altmulticast addr="([^"]*)"/.match(@@ClusterConfig)
        return addr[1] unless addr.nil?
    end
    def altmulticast=(new_value)
        ccscmd(@@CommonArgs+['--setaltmulticast', new_value])
        @property_hash[:altmulticast] = new_value
    end

    def logging
        readConfig unless @@ClusterConfig
        logging = /<logging (.*?)\/?>/.match(@@ClusterConfig)
        return logging[1].split(' ') unless logging.nil?
    end
    def logging=(new_value)
        # When setting the value, we don't want to provide the "'s
        new_value.collect! { |x| x.gsub('"','') }
        ccscmd(@@CommonArgs+['--setlogging', new_value])
        @property_hash[:altmulticast] = new_value
    end
end
