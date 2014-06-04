# All of the classes under cgen/data_loader should be namespaced with this module
module CGen::DataLoader; end


# Require the YAML data loader
# At the moment we always use this data loader. In the future would be good if the user could choose the data loader
require 'cgen/data_loader/yaml_data_loader'
