Puppet::Type.newtype(:mongodb_auth_database) do
  @doc = "Manage MongoDB databases."

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The name of the database."
    newvalues(/^\w+$/)
  end

  newparam(:admin_name) do
    desc "The name of the administrator's database."
    newvalues(/^\w+$/)
  end

  newparam(:admin_user) do
    desc "The admininstrator username to manage all databases."
    newvalues(/^\w+$/)
  end

  newparam(:user) do
    desc "The username of the database."
    newvalues(/^\w+$/)
  end

  newparam(:password) do
    desc "The password for :user of the database."
    newvalues(/^\w+$/)
  end

  newparam(:tries) do
    desc "The maximum amount of two second tries to wait MongoDB startup."
    defaultto 10
    newvalues(/^\d+$/)
    munge do |value|
      Integer(value)
    end
  end

end
