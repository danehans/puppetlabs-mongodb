Puppet::Type.type(:mongodb_auth_database).provide(:mongodb) do

  desc "Manages MongoDB database."

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
    mongo(@resource[:name], '-u', @resource[:user], '-p', @resource[:password], '--quiet', '--eval', "db.dummyData.insert({\"created_by_puppet\": 1})")
  end

  def destroy
    mongo(@resource[:name], '-u', @resource[:user], '-p', @resource[:password], '--quiet', '--eval', 'db.dropDatabase()')
  end

  def exists?
    block_until_mongodb(@resource[:tries])
    mongo(@resource[:name], "-u", @resource[:user], "-p", @resource[:password], "--quiet", "--eval", "db.getMongo().getDB(\'#@resource[:name]\')")
  end

end
