#
# Author: François Charlier <francois.charlier@enovance.com>
#

Puppet::Type.newtype(:mongodb_auth_replset) do
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

  newparam(:admin_db) do
    desc "The name of the admin database"
  end

  newparam(:user) do
    desc "The name of the user."
  end

  newparam(:password) do
    desc "The password of the user."
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
