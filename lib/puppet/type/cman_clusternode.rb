Puppet::Type.newtype(:cman_clusternode) do
    @doc = "High availability cluster node definition"

    ensurable
    autorequire(:package) { catalog.resource(:package, 'ccs')}

    newparam(:name) do
        desc "The cluster node short DNS name or IP address"
        isnamevar
    end
end
