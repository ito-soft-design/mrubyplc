require 'thor'
require 'fileutils'

include FileUtils
include MRubyPlc

module MRubyPlc
  class CLI < Thor

    default_command :build

    desc "build", "Build a project"
    def build(path)
      irep = load path
      irep.variables.each do |v|
        next unless v
        puts "#{v.name } : #{v.var_type}, #{v.val_type}, #{v.value }"
      end
    end
  end
end
