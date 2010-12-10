#!/bin/sh

#rm db/*.sqlite3
#rm db/*.rb
#rake db:migrate RAILS_ENV="production"
rake db:populate RAILS_ENV="production"
