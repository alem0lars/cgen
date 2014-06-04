# All of the classes under cgen/generator should be namespaced with this module
module CGen::Generator; end


# Require the basic generator before the others, since they will assume the BasicGenerator class is already available
require 'cgen/generator/basic_generator'
# Require all of the generators
require_all 'cgen/generator/*.rb'
