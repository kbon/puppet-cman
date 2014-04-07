Puppet::Type.newtype(:cman_cluster) do
    @doc = "High availability cluster definition"

    ensurable
    autorequire(:package) { catalog.resource(:package, 'ccs')}

    newparam(:name) do
        desc "The cluster name"

        isnamevar
    end

    newparam(:ensure) do
        defaultto 'present'
    end

    newproperty(:multicast) do
        desc "Primary multicast address"
    end

    newproperty(:altmulticast) do
        desc "Alternative multicast address"
    end

    newproperty(:logging, :array_matching => :all) do
        desc "Set logging options"

        munge do |value|
          value = [value] unless value.is_a?(Array)
          value.join(',')
        end

    end
end
