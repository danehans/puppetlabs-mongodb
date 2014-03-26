#
# Author: François Charlier <francois.charlier@enovance.com>
#

Puppet::Type.newtype(:mongodb_replset) do
  @doc = "Manage a MongoDB replicaSet"

  ensurable do
    defaultto :present

    newvalue(:present) do
      provider.create
    end
  end

  newparam(:name) do
    desc "The name of the replicaSet"
  end

  newparam(:auth) do
    desc "Enable or disable authentication for connecting to Mongo replication sets"
  end

  newparam(:user) do
    desc "Username with priviledges to manage Mongo replication sets"
  end

  newparam(:password) do
    desc "Password for :user to manage Mongo replication sets"
  end

  newproperty(:members, :array_matching => :all) do
    desc "The replicaSet members"

    def insync?(is)
      is.sort == should.sort
    end
  end

  autorequire(:package) do
    'mongodb'
  end

  autorequire(:service) do
    'mongodb'
  end
end
