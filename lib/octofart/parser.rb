require 'json'

module Octofart
  class Parser

    attr_accessor :file

    def self.read(file)
      new(file).parse
    end

    def initialize(file)
      @file = file
    end

    def parse
      JSON.parse File.read(@file)
    rescue
      raise ArgumentError, "File `#{@file}` can't be parsed as a valid JSON file."
    end

  end
end
