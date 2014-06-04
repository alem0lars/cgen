# The common module for all of the CGen classes
module CGen; end


# ==> Setup RubyGems and Bundler
require 'rubygems'
require 'bundler/setup'

# ==> Require the core dependencies
require 'tmpdir'
require 'pathname'

# ==> Require all of the external dependencies
require 'hash_deep_merge'
require 'monadic'
require 'awesome_print'
require 'colorize'
require 'highline/import'
require 'erubis'

# ==> Require the project stuff
require 'cgen/version'
require 'cgen/util'
require 'cgen/compiler'
require 'cgen/curriculum'
require 'cgen/data_loader'
require 'cgen/generator'
