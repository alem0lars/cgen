# ==> Require the core dependencies.
require "tmpdir"
require "pathname"

# ==> Require all of the external dependencies.
require "hash_deep_merge"
require "monadic"
require "awesome_print"
require "colorize"
require "highline/import"
require "erubis"

# ==> Require the project stuff.
require "curriculum-generator/version"
require "curriculum-generator/util"
require "curriculum-generator/compiler"
require "curriculum-generator/curriculum"
require "curriculum-generator/data_loader"
require "curriculum-generator/generator"
