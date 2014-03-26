Puppet::Type.type(:mongodb_user).provide(:mongodb) do

  desc "Manage users for a MongoDB database."

  defaultfor :kernel => 'Linux'

  commands :mongo => 'mongo'

  def block_until_mongodb(tries = 10)
    begin
      mongo('--quiet', '--eval', 'db.getMongo()')
    rescue
      debug('MongoDB server not ready, retrying')
      sleep 2
      retry unless (tries -= 1) <= 0
    end
  end

  def create
    if @resource[:auth] == true
      mongo(@resource[:database], '-u', @resource[:name], '-p', @resource[:password], '--eval', "db.system.users.insert({user:\'#{@resource[:name]}\', pwd:\"#{@resource[:password_hash]}\", roles: #{@resource[:roles].inspect}})")
    else
      mongo(@resource[:database], '--eval', "db.system.users.insert({user:\'#{@resource[:name]}\', pwd:\"#{@resource[:password_hash]}\", roles: #{@resource[:roles].inspect}})")
    end
  end

  def destroy
    if @resource[:auth] == true
      mongo(@resource[:database], '-u', @resource[:name], '-p', @resource[:password], '--quiet', '--eval', "db.removeUser(\'#{@resource[:name]}\')")
    else
      mongo(@resource[:database], '--quiet', '--eval', "db.removeUser(\'#{@resource[:name]}\')")
    end
  end

  def exists?
    block_until_mongodb(@resource[:tries])
    if @resource[:auth] == true
      mongo(@resource[:database], '-u', @resource[:name], '-p', @resource[:password], '--quiet', '--eval', "db.system.users.find({user:\'#{@resource[:name]}\'}).count()").strip.eql?('1')
    else
      mongo(@resource[:database], '--quiet', '--eval', "db.system.users.find({user:\'#{@resource[:name]}\'}).count()").strip.eql?('1')
    end
  end

  def password_hash
    if @resource[:auth] == true
      mongo(@resource[:database], '-u', @resource[:name], '-p', @resource[:password], '--quiet', '--eval', "db.system.users.findOne({user:\'#{@resource[:name]}\'})[\"pwd\"]").strip
    else
      mongo(@resource[:database], '--quiet', '--eval', "db.system.users.findOne({user:\'#{@resource[:name]}\'})[\"pwd\"]").strip
    end
  end

  def password_hash=(value)
    if @resource[:auth] == true
      mongo(@resource[:database], '-u', @resource[:name], '-p', @resource[:password], '--quiet', '--eval', "db.system.users.update({user:\'#{@resource[:name]}\'}, { $set: {pwd:\"#{value}\"}})")
    else
      mongo(@resource[:database], '--quiet', '--eval', "db.system.users.update({user:\'#{@resource[:name]}\'}, { $set: {pwd:\"#{value}\"}})")
    end
  end

  def roles
    if @resource[:auth] == true
      mongo(@resource[:database], '-u', @resource[:name], '-p', @resource[:password], '--quiet', '--eval', "db.system.users.findOne({user:\'#{@resource[:name]}\'})[\"roles\"]").strip.split(",").sort
    else
      mongo(@resource[:database], '--quiet', '--eval', "db.system.users.findOne({user:\'#{@resource[:name]}\'})[\"roles\"]").strip.split(",").sort
    end
  end

  def roles=(value)
    if @resource[:auth] == true
      mongo(@resource[:database], '-u', @resource[:name], '-p', @resource[:password], '--quiet', '--eval', "db.system.users.update({user:\'#{@resource[:name]}\'}, { $set: {roles: #{@resource[:roles].inspect}}})")
    else
      mongo(@resource[:database], '--quiet', '--eval', "db.system.users.update({user:\'#{@resource[:name]}\'}, { $set: {roles: #{@resource[:roles].inspect}}})")
    end
  end

end
