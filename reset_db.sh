#!/bin/sh

rm db/*.sqlite3
rm db/*.rb
rake db:migrate
rake db:populate
