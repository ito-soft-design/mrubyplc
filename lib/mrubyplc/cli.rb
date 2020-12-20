require 'thor'
require 'fileutils'

include FileUtils

module MRubyPlc
  class CLI < Thor
    desc "build", "Build a project"
    def build(path)
      p path
    end
  end
end
