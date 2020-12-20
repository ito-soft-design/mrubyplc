require 'thor'
require 'fileutils'

include FileUtils

module MRubyPlc
  class CLI < Thor

    default_command :build

    desc "build", "Build a project"
    def build(path)
      p path
      irep = load path
      p irep
    end
  end
end
