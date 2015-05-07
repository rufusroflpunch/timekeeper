require 'data_mapper'

TKEEP_MAJ_VER = 0
TKEEP_MIN_VER = 1

# Check for local folder to store config data
local_folder = Dir.home + '/.tkeep'

if !Dir.exists?(local_folder)
  FileUtils.mkdir(local_folder)
end

# Create sqlite3 db if it doesn't exist
db = local_folder + '/tkeep.db'
conn_string = 'sqlite://' + db

DataMapper.setup(:default, conn_string)

# The storage class for blocks of time

class Block
  include DataMapper::Resource

  property :id         , Serial
  property :category   , String
  property :start_time , DateTime
  property :end_time   , DateTime
  property :note       , Text
end

DataMapper.finalize
DataMapper.auto_upgrade!
