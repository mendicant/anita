require File.expand_path("../lib/anita",     __FILE__)
require File.expand_path("../app/anita_web", __FILE__)

Anita.setup_db

run AnitaWeb
