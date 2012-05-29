require "dm-core"
require "dm-migrations"
require "timecop"

ts = Time.utc(2012, 1, 1)
Timecop.freeze(ts)
