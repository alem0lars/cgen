# The common module for all of the CGen classes
module CGen; end


# ==> Automagically require all of the external dependencies
require 'rubygems'
require 'bundler'
Bundler.require(:default)

# Require the project stuff
require_all 'cgen/*.rb'
