require 'ostruct'

module Octofart
  class Config < OpenStruct

    def initialize(args = {})
      super defaults.merge(args)
    end

    def defaults
      @defaults ||= {
         base_branch: "master",
        github_token: nil,
         max_retries: 1,
      }
    end

  end
end
