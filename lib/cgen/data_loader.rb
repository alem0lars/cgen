# All of the classes under cgen/data_loader should be namespaced with this module
module CGen::DataLoader; end


# Require all of the data loaders
Dir.glob(File.join(File.dirname(__FILE__), 'data_loader/*.rb')) { |mod| require mod }
